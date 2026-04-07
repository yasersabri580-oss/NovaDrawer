// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Drawer controller for the NovaAppDrawer.
///
/// Manages drawer state including open/close, pinned/unpinned,
/// expanded/collapsed, and active item tracking. Provides a
/// [ChangeNotifier] interface for reactive updates.
library;

import 'package:flutter/material.dart';

import '../models/drawer_item.dart';
import '../models/drawer_config.dart';
import '../utils/responsive_utils.dart';

/// Controller that manages the state of the NovaAppDrawer.
///
/// Holds the current open/close status, selected item, expansion
/// states, and provides methods to manipulate drawer behavior.
///
/// Extend or compose with this controller to add custom state logic.
///
/// Example:
/// ```dart
/// final controller = NovaDrawerController(
///   initialSelectedItemId: 'home',
///   initiallyOpen: false,
/// );
/// controller.open();
/// controller.selectItem('settings');
/// ```
class NovaDrawerController extends ChangeNotifier {
  /// Creates an [NovaDrawerController].
  NovaDrawerController({
    String? initialSelectedItemId,
    bool initiallyOpen = false,
    bool initiallyPinned = false,
    bool initiallyMini = false,
  })  : _selectedItemId = initialSelectedItemId,
        _isOpen = initiallyOpen,
        _isPinned = initiallyPinned,
        _isMini = initiallyMini;

  // ── State fields ────────────────────────────────────────────────────

  String? _selectedItemId;
  bool _isOpen;
  bool _isPinned;
  bool _isMini;
  bool _isAnimating = false;
  NovaDeviceType _deviceType = NovaDeviceType.mobile;
  final Map<String, bool> _expandedSections = {};
  final Map<String, bool> _expandedItems = {};
  final Set<String> _disabledItems = {};
  final Set<String> _hiddenItems = {};
  List<NovaDrawerItem> _items = [];
  List<NovaDrawerSectionData> _sections = [];
  bool _isLoading = false;
  String? _errorMessage;

  // ── Getters ─────────────────────────────────────────────────────────

  /// The ID of the currently selected/active drawer item.
  String? get selectedItemId => _selectedItemId;

  /// Whether the drawer is currently open.
  bool get isOpen => _isOpen;

  /// Whether the drawer is pinned (persistent on tablet/desktop).
  bool get isPinned => _isPinned;

  /// Whether the drawer is in mini/collapsed mode.
  bool get isMini => _isMini;

  /// Whether an animation is currently in progress.
  bool get isAnimating => _isAnimating;

  /// The current device type.
  NovaDeviceType get deviceType => _deviceType;

  /// Current list of drawer items.
  List<NovaDrawerItem> get items => List.unmodifiable(_items);

  /// Current list of drawer sections.
  List<NovaDrawerSectionData> get sections => List.unmodifiable(_sections);

  /// Whether data is currently loading.
  bool get isLoading => _isLoading;

  /// Error message from the last data loading attempt.
  String? get errorMessage => _errorMessage;

  /// Whether a section is currently expanded.
  bool isSectionExpanded(String sectionId) {
    return _expandedSections[sectionId] ?? true;
  }

  /// Whether a nested item is currently expanded.
  bool isItemExpanded(String itemId) {
    return _expandedItems[itemId] ?? false;
  }

  /// Whether an item is disabled.
  bool isItemDisabled(String itemId) {
    return _disabledItems.contains(itemId);
  }

  /// Whether an item is hidden.
  bool isItemHidden(String itemId) {
    return _hiddenItems.contains(itemId);
  }

  /// Whether the given item is selected.
  bool isSelected(String itemId) {
    return _selectedItemId == itemId;
  }

  // ── Open / Close ───────────────────────────────────────────────────

  /// Opens the drawer.
  void open() {
    if (!_isOpen) {
      _isOpen = true;
      _isMini = false;
      notifyListeners();
    }
  }

  /// Closes the drawer.
  void close() {
    if (_isOpen && !_isPinned) {
      _isOpen = false;
      notifyListeners();
    }
  }

  /// Toggles the drawer between open and closed.
  void toggle() {
    if (_isOpen) {
      close();
    } else {
      open();
    }
  }

  // ── Pin / Unpin ────────────────────────────────────────────────────

  /// Pins the drawer open (persistent).
  void pin() {
    if (!_isPinned) {
      _isPinned = true;
      _isOpen = true;
      notifyListeners();
    }
  }

  /// Unpins the drawer.
  void unpin() {
    if (_isPinned) {
      _isPinned = false;
      notifyListeners();
    }
  }

  /// Toggles the pinned state.
  void togglePin() {
    if (_isPinned) {
      unpin();
    } else {
      pin();
    }
  }

  // ── Mini Mode ──────────────────────────────────────────────────────

  /// Switches to mini (collapsed icon-only) mode.
  void toMini() {
    if (!_isMini) {
      _isMini = true;
      _isOpen = false;
      notifyListeners();
    }
  }

  /// Switches from mini to expanded mode.
  void fromMini() {
    if (_isMini) {
      _isMini = false;
      _isOpen = true;
      notifyListeners();
    }
  }

  /// Toggles between mini and expanded.
  void toggleMini() {
    if (_isMini) {
      fromMini();
    } else {
      toMini();
    }
  }

  // ── Item Selection ─────────────────────────────────────────────────

  /// Selects a drawer item by its [itemId].
  void selectItem(String itemId) {
    if (_selectedItemId != itemId) {
      _selectedItemId = itemId;
      notifyListeners();
    }
  }

  /// Clears the current selection.
  void clearSelection() {
    if (_selectedItemId != null) {
      _selectedItemId = null;
      notifyListeners();
    }
  }

  /// Selects an item by matching its [route] against the given path.
  void selectByRoute(String routePath) {
    final item = _findItemByRoute(routePath, _items);
    if (item != null && _selectedItemId != item.id) {
      _selectedItemId = item.id;
      // Auto-expand parent items
      _expandParentsOf(item.id, _items);
      notifyListeners();
    }
  }

  // ── Section Expansion ──────────────────────────────────────────────

  /// Expands a section.
  void expandSection(String sectionId) {
    _expandedSections[sectionId] = true;
    notifyListeners();
  }

  /// Collapses a section.
  void collapseSection(String sectionId) {
    _expandedSections[sectionId] = false;
    notifyListeners();
  }

  /// Toggles section expansion.
  void toggleSection(String sectionId) {
    _expandedSections[sectionId] = !(isSectionExpanded(sectionId));
    notifyListeners();
  }

  // ── Item Expansion (nested) ────────────────────────────────────────

  /// Expands a nested item's children.
  void expandItem(String itemId) {
    _expandedItems[itemId] = true;
    notifyListeners();
  }

  /// Collapses a nested item's children.
  void collapseItem(String itemId) {
    _expandedItems[itemId] = false;
    notifyListeners();
  }

  /// Toggles nested item expansion.
  void toggleItem(String itemId) {
    _expandedItems[itemId] = !(isItemExpanded(itemId));
    notifyListeners();
  }

  // ── Item Enable / Disable ─────────────────────────────────────────

  /// Disables an item (non-interactive).
  void disableItem(String itemId) {
    _disabledItems.add(itemId);
    notifyListeners();
  }

  /// Enables a previously disabled item.
  void enableItem(String itemId) {
    _disabledItems.remove(itemId);
    notifyListeners();
  }

  /// Hides an item from the drawer.
  void hideItem(String itemId) {
    _hiddenItems.add(itemId);
    notifyListeners();
  }

  /// Shows a previously hidden item.
  void showItem(String itemId) {
    _hiddenItems.remove(itemId);
    notifyListeners();
  }

  // ── Data Management ────────────────────────────────────────────────

  /// Sets the drawer items.
  void setItems(List<NovaDrawerItem> items) {
    _items = items;
    notifyListeners();
  }

  /// Sets the drawer sections.
  void setSections(List<NovaDrawerSectionData> sections) {
    _sections = sections;
    // Initialize section expansion states
    for (final section in sections) {
      _expandedSections.putIfAbsent(section.id, () => section.initiallyExpanded);
    }
    notifyListeners();
  }

  /// Loads items dynamically using the provided [loader] function.
  ///
  /// Sets [isLoading] to true during the load, and populates
  /// [errorMessage] on failure.
  Future<void> loadItems(
    Future<List<NovaDrawerItem>> Function() loader,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedItems = await loader();
      _items = loadedItems;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads sections dynamically using the provided [loader] function.
  Future<void> loadSections(
    Future<List<NovaDrawerSectionData>> Function() loader,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final loadedSections = await loader();
      setSections(loadedSections);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Device Type ────────────────────────────────────────────────────

  /// Updates the device type (called when screen size changes).
  void updateDeviceType(NovaDeviceType type) {
    if (_deviceType != type) {
      _deviceType = type;
      // Auto-adjust behavior based on device type
      if (type == NovaDeviceType.mobile) {
        _isPinned = false;
      }
      notifyListeners();
    }
  }

  // ── Animation State ────────────────────────────────────────────────

  /// Marks the beginning of an animation.
  void startAnimation() {
    _isAnimating = true;
    notifyListeners();
  }

  /// Marks the end of an animation.
  void endAnimation() {
    _isAnimating = false;
    notifyListeners();
  }

  // ── Private Helpers ────────────────────────────────────────────────

  /// Recursively finds an item by route.
  NovaDrawerItem? _findItemByRoute(String route, List<NovaDrawerItem> items) {
    for (final item in items) {
      if (item.route == route) return item;
      if (item.hasChildren) {
        final found = _findItemByRoute(route, item.children);
        if (found != null) return found;
      }
    }
    return null;
  }

  /// Expands all parent items containing the target item.
  void _expandParentsOf(String targetId, List<NovaDrawerItem> items) {
    for (final item in items) {
      if (item.hasChildren) {
        if (_containsItem(targetId, item.children)) {
          _expandedItems[item.id] = true;
          _expandParentsOf(targetId, item.children);
        }
      }
    }
  }

  /// Checks if items contain an item with the given ID.
  bool _containsItem(String targetId, List<NovaDrawerItem> items) {
    for (final item in items) {
      if (item.id == targetId) return true;
      if (item.hasChildren && _containsItem(targetId, item.children)) {
        return true;
      }
    }
    return false;
  }
}

/// An [InheritedNotifier] that provides the [NovaDrawerController]
/// to descendant widgets.
///
/// Wrap your drawer subtree with this to make the controller
/// accessible via [NovaDrawerControllerProvider.of(context)].
class NovaDrawerControllerProvider
    extends InheritedNotifier<NovaDrawerController> {
  /// Creates a [NovaDrawerControllerProvider].
  const NovaDrawerControllerProvider({
    super.key,
    required NovaDrawerController controller,
    required super.child,
  }) : super(notifier: controller);

  /// Retrieves the nearest [NovaDrawerController] from the widget tree.
  static NovaDrawerController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<NovaDrawerControllerProvider>();
    assert(provider != null, 'No NovaDrawerControllerProvider found in context');
    return provider!.notifier!;
  }

  /// Retrieves the controller without establishing a dependency.
  static NovaDrawerController read(BuildContext context) {
    final provider = context
        .getInheritedWidgetOfExactType<NovaDrawerControllerProvider>();
    assert(provider != null, 'No NovaDrawerControllerProvider found in context');
    return provider!.notifier!;
  }
}
