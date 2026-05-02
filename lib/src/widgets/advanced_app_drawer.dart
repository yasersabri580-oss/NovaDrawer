// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Main NovaAppDrawer widget.
///
/// The primary widget that assembles the full drawer experience,
/// including header, sections, items, animations, and responsive
/// behavior. This is the main entry point for using the package.
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/drawer_item.dart';
import '../models/drawer_theme.dart';
import '../models/drawer_config.dart';
import '../controllers/drawer_controller.dart';
import '../animations/animation_wrapper.dart';
import '../animations/shimmer_animation.dart';
import '../utils/responsive_utils.dart';
import '../utils/navigation_utils.dart';
import '../backgrounds/gradient_background.dart';
import '../backgrounds/particle_background.dart';
import 'drawer_section.dart';
import 'drawer_item_widget.dart';
import 'nested_menu_item.dart';

/// The main NovaAppDrawer widget.
///
/// Provides a complete, fully-featured navigation drawer with
/// responsive layout, animations, theming, accessibility, and
/// support for nested/dynamic items.
///
/// Use [NovaAppDrawer] as a direct child inside a [Scaffold.drawer]
/// or within a [NovaDrawerScaffold] for automatic responsive behavior.
///
/// Example:
/// ```dart
/// NovaAppDrawer(
///   controller: drawerController,
///   sections: [
///     NovaDrawerSectionData(
///       id: 'main',
///       title: 'Menu',
///       items: [
///         NovaDrawerItem(id: 'home', title: 'Home', icon: Icons.home),
///         NovaDrawerItem(id: 'profile', title: 'Profile', icon: Icons.person),
///       ],
///     ),
///   ],
///   header: NovaDrawerHeaderWidget(title: 'My App'),
///   onItemTap: (item) => print('Tapped: ${item.title}'),
/// )
/// ```
class NovaAppDrawer extends StatefulWidget {
  /// Creates an [NovaAppDrawer].
  const NovaAppDrawer({
    super.key,
    required this.controller,
    this.sections = const [],
    this.items = const [],
    this.entries = const [],
    this.header,
    this.footer,
    this.onItemTap,
    this.onNavigate,
    this.theme,
    this.config = const NovaDrawerConfig(),
    this.width,
    this.backgroundWidget,
    this.enableGradientBackground = false,
    this.gradientColors,
    this.enableParticleBackground = false,
    this.particleColor,
    this.particleCount = 20,
  });

  /// Controller managing drawer state.
  final NovaDrawerController controller;

  /// Sections grouping related items.
  final List<NovaDrawerSectionData> sections;

  /// Flat list of items (used when sections are empty).
  final List<NovaDrawerItem> items;

  /// Ordered mix of items and sections.
  ///
  /// When non-empty, [entries] takes precedence over [sections] and [items],
  /// allowing you to interleave standalone [NovaDrawerItem]s and
  /// [NovaDrawerSectionData] groups in any order:
  ///
  /// ```dart
  /// entries: [
  ///   NovaDrawerItemEntry(NovaDrawerItem(id: 'home', title: 'Home', icon: Icons.home)),
  ///   NovaDrawerSectionEntry(NovaDrawerSectionData(id: 'tools', title: 'Tools', items: [...])),
  ///   NovaDrawerItemEntry(NovaDrawerItem(id: 'logout', title: 'Logout', icon: Icons.logout)),
  /// ],
  /// ```
  final List<NovaDrawerEntry> entries;

  /// Header widget at the top of the drawer.
  final Widget? header;

  /// Footer widget at the bottom of the drawer.
  final Widget? footer;

  /// Callback when any item is tapped.
  final void Function(NovaDrawerItem item)? onItemTap;

  /// Router-agnostic navigation callback invoked when an item with a [NovaDrawerItem.route]
  /// is tapped.
  ///
  /// Use this to support any navigation system (GoRouter, auto_route, Navigator 2.0, etc.).
  /// When omitted the drawer falls back to [Navigator.pushNamed].
  ///
  /// Example with GoRouter:
  /// ```dart
  /// NovaAppDrawer(
  ///   onNavigate: (context, route) => context.go(route),
  ///   ...
  /// )
  /// ```
  final void Function(BuildContext context, String route)? onNavigate;

  /// Theme customization.
  final NovaDrawerTheme? theme;

  /// Behavior configuration.
  final NovaDrawerConfig config;

  /// Override width (otherwise derived from responsive config).
  final double? width;

  /// Custom background widget.
  final Widget? backgroundWidget;

  /// Whether to use animated gradient background.
  final bool enableGradientBackground;

  /// Colors for the gradient background.
  final List<Color>? gradientColors;

  /// Whether to use particle effect background.
  final bool enableParticleBackground;

  /// Color for particles.
  final Color? particleColor;

  /// Number of particles.
  final int particleCount;

  @override
  State<NovaAppDrawer> createState() => _NovaAppDrawerState();
}

class _NovaAppDrawerState extends State<NovaAppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  /// Keys registered per item ID — used for auto-scroll via [Scrollable.ensureVisible].
  final Map<String, GlobalKey> _itemKeys = {};

  /// Tracks whether the drawer was open on the previous controller notification.
  bool _wasOpen = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.config.animationConfig.duration,
      reverseDuration: widget.config.animationConfig.effectiveReverseDuration,
    );

    // Listen to controller changes so that selection and other state changes
    // cause this widget to rebuild. This is necessary for flat items rendered
    // directly in _buildFlatItem, which do not go through a widget that
    // depends on NovaDrawerControllerProvider.of(context).
    _wasOpen = widget.controller.isOpen;
    widget.controller.addListener(_onControllerChanged);

    // Defer controller state updates to post-frame to avoid calling
    // notifyListeners() while the widget tree is still being built, which
    // would cause a "setState() called during build" error via the
    // NovaDrawerControllerProvider InheritedNotifier.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.sections.isNotEmpty) {
        widget.controller.setSections(widget.sections);
      }
      if (widget.items.isNotEmpty) {
        widget.controller.setItems(widget.items);
      }
    });

    // Start the entrance animation
    _animationController.forward();
  }

  @override
  void didUpdateWidget(NovaAppDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      _wasOpen = widget.controller.isOpen;
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      final isNowOpen = widget.controller.isOpen;
      // Trigger auto-scroll when the drawer transitions from closed → open.
      if (isNowOpen && !_wasOpen && widget.config.enableAutoScrollToSelected) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _scrollToSelectedItem();
        });
      }
      _wasOpen = isNowOpen;
      setState(() {});
    }
  }

  /// Scrolls the list to centre the currently selected item, if any.
  void _scrollToSelectedItem() {
    final selectedId = widget.controller.selectedItemId;
    if (selectedId == null) return;
    final key = _itemKeys[selectedId];
    if (key?.currentContext == null) return;
    Scrollable.ensureVisible(
      key!.currentContext!,
      alignment: 0.5,
      duration: widget.config.autoScrollDuration,
      curve: widget.config.autoScrollCurve,
    );
  }

  /// Returns (and lazily creates) the [GlobalKey] for the given item ID.
  GlobalKey _keyFor(String itemId) =>
      _itemKeys.putIfAbsent(itemId, GlobalKey.new);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final drawerTheme = widget.theme?.resolve(themeData) ??
        const NovaDrawerTheme().resolve(themeData);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveWidth = widget.width ??
        NovaResponsiveUtils.getDrawerWidth(
          widget.controller.deviceType,
          drawerTheme,
        );

    return NovaDrawerControllerProvider(
      controller: widget.controller,
      child: Semantics(
        label: widget.config.accessibilityConfig.drawerLabel,
        child: Material(
          elevation: drawerTheme.elevation ?? 1.0,
          shadowColor: drawerTheme.shadowColor,
          color: Colors.transparent,
          shape: drawerTheme.drawerShape,
          child: Container(
            width: effectiveWidth,
            decoration: _buildDecoration(drawerTheme),
            child: _buildContent(drawerTheme, isRtl),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(NovaDrawerTheme drawerTheme) {
    return BoxDecoration(
      color: drawerTheme.gradient == null
          ? drawerTheme.backgroundColor
          : null,
      gradient: drawerTheme.gradient,
      image: drawerTheme.backgroundImage,
      borderRadius: drawerTheme.borderRadius,
      border: drawerTheme.border,
    );
  }

  Widget _buildContent(NovaDrawerTheme drawerTheme, bool isRtl) {
    Widget content = Column(
      children: [
        // Header
        if (widget.header != null) widget.header!,

        // Loading state
        if (widget.controller.isLoading)
          _buildLoadingState(drawerTheme)
        // Error state
        else if (widget.controller.errorMessage != null)
          _buildErrorState(drawerTheme)
        // Content
        else
          Expanded(
            child: _buildScrollableContent(drawerTheme),
          ),

        // Footer
        if (widget.footer != null) ...[
          Divider(
            color: drawerTheme.dividerColor,
            height: 1.0,
          ),
          widget.footer!,
        ],
      ],
    );

    // Apply background effects
    if (widget.backgroundWidget != null) {
      content = Stack(
        children: [
          Positioned.fill(child: widget.backgroundWidget!),
          content,
        ],
      );
    }

    if (widget.enableGradientBackground) {
      content = NovaGradientBackground(
        colors: widget.gradientColors,
        child: content,
      );
    }

    if (widget.enableParticleBackground) {
      content = NovaParticleBackground(
        color: widget.particleColor,
        particleCount: widget.particleCount,
        child: content,
      );
    }

    // Apply entrance animation
    if (widget.config.animationConfig.enableItemAnimations) {
      content = NovaDrawerAnimationWrapper(
        animation: _animationController,
        animationType: widget.config.animationType,
        animationConfig: widget.config.animationConfig,
        isRtl: isRtl,
        child: content,
      );
    }

    return ClipRect(child: content);
  }

  Widget _buildScrollableContent(NovaDrawerTheme drawerTheme) {
    final controller = widget.controller;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: drawerTheme.scrollbarTheme?.isAlwaysShown ?? false,
      child: ListView(
        controller: _scrollController,
        padding: drawerTheme.contentPadding,
        children: [
          // Mixed entries (items and sections interleaved)
          if (widget.entries.isNotEmpty)
            for (final entry in widget.entries)
              if (entry is NovaDrawerItemEntry &&
                  entry.item.isVisible &&
                  !controller.isItemHidden(entry.item.id))
                _buildFlatItem(entry.item, drawerTheme, controller)
              else if (entry is NovaDrawerSectionEntry)
                NovaDrawerSectionWidget(
                  section: entry.section,
                  onItemTap: widget.onItemTap,
                  onNavigate: widget.onNavigate,
                  theme: widget.theme,
                  config: widget.config,
                  itemKeys: _itemKeys,
                )
          // Sections
          else if (widget.sections.isNotEmpty)
            for (final section in widget.sections)
              NovaDrawerSectionWidget(
                section: section,
                onItemTap: widget.onItemTap,
                onNavigate: widget.onNavigate,
                theme: widget.theme,
                config: widget.config,
                itemKeys: _itemKeys,
              )
          // Flat items
          else
            for (final item in widget.items)
              if (item.isVisible && !controller.isItemHidden(item.id))
                _buildFlatItem(item, drawerTheme, controller),
        ],
      ),
    );
  }

  Widget _buildFlatItem(
    NovaDrawerItem item,
    NovaDrawerTheme drawerTheme,
    NovaDrawerController controller,
  ) {
    if (item.customWidget != null) {
      return KeyedSubtree(key: _keyFor(item.id), child: item.customWidget!);
    }

    final isSelected = controller.isSelected(item.id);

    if (item.hasChildren) {
      return KeyedSubtree(
        key: _keyFor(item.id),
        child: NovaNestedMenuItem(
          item: item,
          isSelected: isSelected,
          onItemTap: widget.onItemTap,
          onNavigate: widget.onNavigate,
          theme: widget.theme,
          config: widget.config,
        ),
      );
    }

    return Padding(
      key: _keyFor(item.id),
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: NovaDrawerItemWidget(
        item: item,
        isSelected: isSelected,
        onTap: () {
          controller.selectItem(item.id);
          widget.onItemTap?.call(item);
          item.onTap?.call();
          novaNavigateForItem(context, item, widget.onNavigate);
          if (widget.config.closeOnItemTap &&
              controller.deviceType == NovaDeviceType.mobile) {
            controller.close();
          }
        },
        theme: widget.theme,
        config: widget.config,
      ),
    );
  }

  Widget _buildLoadingState(NovaDrawerTheme drawerTheme) {
    return Expanded(
      child: NovaContinuousShimmer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(
              6,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: drawerTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: drawerTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(NovaDrawerTheme drawerTheme) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load items',
                style: drawerTheme.itemTextStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.controller.errorMessage ?? 'Unknown error',
                style: drawerTheme.subtitleTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  // Re-trigger loading
                  widget.controller.notifyListeners();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
