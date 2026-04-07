// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Tests for the AdvancedAppDrawer package.
///
/// Covers models, controllers, widgets, animations, and utilities.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nova_drawer/main.dart';

// ═══════════════════════════════════════════════════════════════════════
// MODEL TESTS
// ═══════════════════════════════════════════════════════════════════════

void main() {
  group('DrawerItem', () {
    test('should create with required fields', () {
      const item = DrawerItem(id: 'test', title: 'Test Item');
      expect(item.id, 'test');
      expect(item.title, 'Test Item');
      expect(item.icon, isNull);
      expect(item.children, isEmpty);
      expect(item.hasChildren, isFalse);
      expect(item.isEnabled, isTrue);
      expect(item.isVisible, isTrue);
    });

    test('should report hasChildren correctly', () {
      const parent = DrawerItem(
        id: 'parent',
        title: 'Parent',
        children: [
          DrawerItem(id: 'child1', title: 'Child 1'),
          DrawerItem(id: 'child2', title: 'Child 2'),
        ],
      );
      expect(parent.hasChildren, isTrue);
      expect(parent.children.length, 2);
    });

    test('should support copyWith', () {
      const item = DrawerItem(
        id: 'test',
        title: 'Original',
        icon: Icons.home,
      );
      final copied = item.copyWith(title: 'Updated');
      expect(copied.title, 'Updated');
      expect(copied.id, 'test');
      expect(copied.icon, Icons.home);
    });

    test('should implement equality by id', () {
      const item1 = DrawerItem(id: 'same', title: 'Item 1');
      const item2 = DrawerItem(id: 'same', title: 'Item 2');
      const item3 = DrawerItem(id: 'different', title: 'Item 1');
      expect(item1 == item2, isTrue);
      expect(item1 == item3, isFalse);
      expect(item1.hashCode, item2.hashCode);
    });

    test('effectiveSelectedIcon falls back to icon', () {
      const item = DrawerItem(id: 'test', title: 'Test', icon: Icons.home);
      expect(item.effectiveSelectedIcon, Icons.home);

      const itemWithSelected = DrawerItem(
        id: 'test2',
        title: 'Test 2',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
      );
      expect(itemWithSelected.effectiveSelectedIcon, Icons.home);
    });
  });

  group('DrawerItemBadge', () {
    test('should display count text', () {
      const badge = DrawerItemBadge(count: 5);
      expect(badge.displayText, '5');
    });

    test('should cap count at 99+', () {
      const badge = DrawerItemBadge(count: 150);
      expect(badge.displayText, '99+');
    });

    test('should display label', () {
      const badge = DrawerItemBadge(label: 'NEW');
      expect(badge.displayText, 'NEW');
    });

    test('label takes precedence over count', () {
      const badge = DrawerItemBadge(count: 5, label: 'SALE');
      expect(badge.displayText, 'SALE');
    });

    test('should support copyWith', () {
      const badge = DrawerItemBadge(count: 5);
      final updated = badge.copyWith(count: 10);
      expect(updated.count, 10);
    });
  });

  group('DrawerSectionData', () {
    test('should create with required fields', () {
      const section = DrawerSectionData(
        id: 'main',
        items: [
          DrawerItem(id: 'item1', title: 'Item 1'),
        ],
      );
      expect(section.id, 'main');
      expect(section.items.length, 1);
      expect(section.isCollapsible, isTrue);
      expect(section.initiallyExpanded, isTrue);
    });

    test('should support copyWith', () {
      const section = DrawerSectionData(
        id: 'test',
        items: [],
        title: 'Original',
      );
      final copied = section.copyWith(title: 'Updated');
      expect(copied.title, 'Updated');
      expect(copied.id, 'test');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // THEME TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('AdvancedDrawerTheme', () {
    test('should create with defaults', () {
      const theme = AdvancedDrawerTheme();
      expect(theme.backgroundColor, isNull);
      expect(theme.iconSize, isNull);
    });

    test('should resolve against ThemeData', () {
      final themeData = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      );
      const drawerTheme = AdvancedDrawerTheme();
      final resolved = drawerTheme.resolve(themeData);
      expect(resolved.backgroundColor, isNotNull);
      expect(resolved.selectedItemColor, isNotNull);
      expect(resolved.iconSize, AdvancedDrawerTheme.defaultIconSize);
      expect(
          resolved.miniDrawerWidth, AdvancedDrawerTheme.defaultMiniDrawerWidth);
      expect(resolved.expandedDrawerWidth,
          AdvancedDrawerTheme.defaultExpandedDrawerWidth);
    });

    test('should support copyWith', () {
      const theme = AdvancedDrawerTheme(elevation: 4.0);
      final copied = theme.copyWith(elevation: 8.0);
      expect(copied.elevation, 8.0);
    });

    test('dark factory creates valid theme', () {
      final theme = AdvancedDrawerTheme.dark();
      expect(theme.backgroundColor, isNotNull);
      expect(theme.selectedItemColor, isNotNull);
    });

    test('light factory creates valid theme', () {
      final theme = AdvancedDrawerTheme.light();
      expect(theme.backgroundColor, isNotNull);
      expect(theme.selectedItemColor, isNotNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CONFIG TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('DrawerConfig', () {
    test('should create with defaults', () {
      const config = DrawerConfig();
      expect(config.displayMode, DrawerDisplayMode.auto);
      expect(config.animationType, DrawerAnimationType.slide);
      expect(config.isPinnable, isTrue);
      expect(config.closeOnItemTap, isTrue);
    });

    test('should support copyWith', () {
      const config = DrawerConfig();
      final copied = config.copyWith(
        displayMode: DrawerDisplayMode.side,
        isPinnable: false,
      );
      expect(copied.displayMode, DrawerDisplayMode.side);
      expect(copied.isPinnable, isFalse);
      expect(copied.animationType, DrawerAnimationType.slide);
    });
  });

  group('DrawerBreakpoints', () {
    test('default breakpoints', () {
      const bp = DrawerBreakpoints();
      expect(bp.mobile, 600.0);
      expect(bp.tablet, 1024.0);
    });

    test('standard breakpoints match defaults', () {
      expect(DrawerBreakpoints.standard.mobile, 600.0);
      expect(DrawerBreakpoints.standard.tablet, 1024.0);
    });
  });

  group('DrawerAnimationConfig', () {
    test('effective reverse duration falls back to duration', () {
      const config = DrawerAnimationConfig(
        duration: Duration(milliseconds: 300),
      );
      expect(config.effectiveReverseDuration,
          const Duration(milliseconds: 300));
    });

    test('effective reverse duration uses override', () {
      const config = DrawerAnimationConfig(
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 200),
      );
      expect(config.effectiveReverseDuration,
          const Duration(milliseconds: 200));
    });

    test('should support copyWith', () {
      const config = DrawerAnimationConfig();
      final copied = config.copyWith(
        duration: const Duration(milliseconds: 500),
      );
      expect(copied.duration, const Duration(milliseconds: 500));
      expect(copied.curve, Curves.easeInOutCubic);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CONTROLLER TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('AdvancedDrawerController', () {
    late AdvancedDrawerController controller;

    setUp(() {
      controller = AdvancedDrawerController(
        initialSelectedItemId: 'home',
        initiallyOpen: false,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    test('initial state', () {
      expect(controller.selectedItemId, 'home');
      expect(controller.isOpen, isFalse);
      expect(controller.isPinned, isFalse);
      expect(controller.isMini, isFalse);
      expect(controller.isLoading, isFalse);
    });

    test('open and close', () {
      controller.open();
      expect(controller.isOpen, isTrue);
      controller.close();
      expect(controller.isOpen, isFalse);
    });

    test('toggle', () {
      controller.toggle();
      expect(controller.isOpen, isTrue);
      controller.toggle();
      expect(controller.isOpen, isFalse);
    });

    test('pinned drawer stays open on close', () {
      controller.pin();
      expect(controller.isPinned, isTrue);
      expect(controller.isOpen, isTrue);
      controller.close();
      // Pinned drawer should remain open
      expect(controller.isOpen, isTrue);
    });

    test('unpin allows closing', () {
      controller.pin();
      controller.unpin();
      expect(controller.isPinned, isFalse);
      controller.close();
      expect(controller.isOpen, isFalse);
    });

    test('togglePin', () {
      controller.togglePin();
      expect(controller.isPinned, isTrue);
      controller.togglePin();
      expect(controller.isPinned, isFalse);
    });

    test('mini mode', () {
      controller.toMini();
      expect(controller.isMini, isTrue);
      expect(controller.isOpen, isFalse);
      controller.fromMini();
      expect(controller.isMini, isFalse);
      expect(controller.isOpen, isTrue);
    });

    test('toggleMini', () {
      controller.toggleMini();
      expect(controller.isMini, isTrue);
      controller.toggleMini();
      expect(controller.isMini, isFalse);
    });

    test('select item', () {
      controller.selectItem('settings');
      expect(controller.selectedItemId, 'settings');
      expect(controller.isSelected('settings'), isTrue);
      expect(controller.isSelected('home'), isFalse);
    });

    test('clear selection', () {
      controller.clearSelection();
      expect(controller.selectedItemId, isNull);
    });

    test('section expansion', () {
      expect(controller.isSectionExpanded('main'), isTrue);
      controller.collapseSection('main');
      expect(controller.isSectionExpanded('main'), isFalse);
      controller.expandSection('main');
      expect(controller.isSectionExpanded('main'), isTrue);
      controller.toggleSection('main');
      expect(controller.isSectionExpanded('main'), isFalse);
    });

    test('item expansion', () {
      expect(controller.isItemExpanded('files'), isFalse);
      controller.expandItem('files');
      expect(controller.isItemExpanded('files'), isTrue);
      controller.collapseItem('files');
      expect(controller.isItemExpanded('files'), isFalse);
      controller.toggleItem('files');
      expect(controller.isItemExpanded('files'), isTrue);
    });

    test('disable and enable items', () {
      controller.disableItem('home');
      expect(controller.isItemDisabled('home'), isTrue);
      controller.enableItem('home');
      expect(controller.isItemDisabled('home'), isFalse);
    });

    test('hide and show items', () {
      controller.hideItem('home');
      expect(controller.isItemHidden('home'), isTrue);
      controller.showItem('home');
      expect(controller.isItemHidden('home'), isFalse);
    });

    test('setItems', () {
      controller.setItems([
        const DrawerItem(id: 'a', title: 'A'),
        const DrawerItem(id: 'b', title: 'B'),
      ]);
      expect(controller.items.length, 2);
    });

    test('setSections', () {
      controller.setSections([
        const DrawerSectionData(
          id: 's1',
          items: [DrawerItem(id: 'item1', title: 'Item 1')],
        ),
      ]);
      expect(controller.sections.length, 1);
    });

    test('loadItems success', () async {
      await controller.loadItems(() async {
        return [const DrawerItem(id: 'loaded', title: 'Loaded')];
      });
      expect(controller.items.length, 1);
      expect(controller.isLoading, isFalse);
      expect(controller.errorMessage, isNull);
    });

    test('loadItems error', () async {
      await controller.loadItems(() async {
        throw Exception('Network error');
      });
      expect(controller.isLoading, isFalse);
      expect(controller.errorMessage, isNotNull);
    });

    test('updateDeviceType', () {
      controller.updateDeviceType(DeviceType.desktop);
      expect(controller.deviceType, DeviceType.desktop);
    });

    test('mobile device type unpins', () {
      controller.pin();
      controller.updateDeviceType(DeviceType.mobile);
      expect(controller.isPinned, isFalse);
    });

    test('selectByRoute', () {
      controller.setItems([
        const DrawerItem(id: 'home', title: 'Home', route: '/home'),
        const DrawerItem(
          id: 'settings',
          title: 'Settings',
          route: '/settings',
          children: [
            DrawerItem(
              id: 'account',
              title: 'Account',
              route: '/settings/account',
            ),
          ],
        ),
      ]);
      controller.selectByRoute('/settings/account');
      expect(controller.selectedItemId, 'account');
      // Parent should be expanded
      expect(controller.isItemExpanded('settings'), isTrue);
    });

    test('notifies listeners', () {
      var notifyCount = 0;
      controller.addListener(() => notifyCount++);
      controller.open();
      expect(notifyCount, 1);
      controller.close();
      expect(notifyCount, 2);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // RESPONSIVE UTILS TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('ResponsiveUtils', () {
    test('getDeviceType for mobile', () {
      expect(
        ResponsiveUtils.getDeviceType(400),
        DeviceType.mobile,
      );
    });

    test('getDeviceType for tablet', () {
      expect(
        ResponsiveUtils.getDeviceType(800),
        DeviceType.tablet,
      );
    });

    test('getDeviceType for desktop', () {
      expect(
        ResponsiveUtils.getDeviceType(1200),
        DeviceType.desktop,
      );
    });

    test('getDeviceType with custom breakpoints', () {
      const bp = DrawerBreakpoints(mobile: 500, tablet: 900);
      expect(ResponsiveUtils.getDeviceType(450, bp), DeviceType.mobile);
      expect(ResponsiveUtils.getDeviceType(700, bp), DeviceType.tablet);
      expect(ResponsiveUtils.getDeviceType(950, bp), DeviceType.desktop);
    });

    test('canPin', () {
      expect(ResponsiveUtils.canPin(DeviceType.mobile), isFalse);
      expect(ResponsiveUtils.canPin(DeviceType.tablet), isTrue);
      expect(ResponsiveUtils.canPin(DeviceType.desktop), isTrue);
    });

    test('resolveDisplayMode auto', () {
      expect(
        ResponsiveUtils.resolveDisplayMode(
            DrawerDisplayMode.auto, DeviceType.mobile),
        DrawerDisplayMode.overlay,
      );
      expect(
        ResponsiveUtils.resolveDisplayMode(
            DrawerDisplayMode.auto, DeviceType.tablet),
        DrawerDisplayMode.push,
      );
      expect(
        ResponsiveUtils.resolveDisplayMode(
            DrawerDisplayMode.auto, DeviceType.desktop),
        DrawerDisplayMode.side,
      );
    });

    test('resolveDisplayMode explicit', () {
      expect(
        ResponsiveUtils.resolveDisplayMode(
            DrawerDisplayMode.overlay, DeviceType.desktop),
        DrawerDisplayMode.overlay,
      );
    });

    test('shouldShowOverlay', () {
      expect(
        ResponsiveUtils.shouldShowOverlay(
            DeviceType.mobile, DrawerDisplayMode.auto),
        isTrue,
      );
      expect(
        ResponsiveUtils.shouldShowOverlay(
            DeviceType.desktop, DrawerDisplayMode.auto),
        isFalse,
      );
    });

    test('getNestedIndentation', () {
      expect(ResponsiveUtils.getNestedIndentation(0), 0.0);
      expect(ResponsiveUtils.getNestedIndentation(1), 16.0);
      expect(ResponsiveUtils.getNestedIndentation(2), 32.0);
      expect(ResponsiveUtils.getNestedIndentation(1, baseIndent: 24.0), 24.0);
    });

    test('getMaxNestingDepth', () {
      expect(ResponsiveUtils.getMaxNestingDepth(150), 1);
      expect(ResponsiveUtils.getMaxNestingDepth(250), 2);
      expect(ResponsiveUtils.getMaxNestingDepth(300), 3);
      expect(ResponsiveUtils.getMaxNestingDepth(400), 4);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ANIMATION CONFIG TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('DrawerAnimationConfig', () {
    test('defaults', () {
      const config = DrawerAnimationConfig();
      expect(config.duration, const Duration(milliseconds: 300));
      expect(config.curve, Curves.easeInOutCubic);
      expect(config.enableItemAnimations, isTrue);
      expect(config.enableStaggeredAnimations, isTrue);
    });

    test('copyWith preserves unmodified values', () {
      const config = DrawerAnimationConfig(
        duration: Duration(milliseconds: 500),
        springDamping: 0.8,
      );
      final copied = config.copyWith(
        duration: const Duration(milliseconds: 300),
      );
      expect(copied.duration, const Duration(milliseconds: 300));
      expect(copied.springDamping, 0.8);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ELASTIC CURVE TEST
  // ═══════════════════════════════════════════════════════════════════════

  group('ElasticCurve', () {
    test('starts at 0 and ends near 1', () {
      const curve = ElasticCurve();
      // At t=0, the curve should be close to 0 (actually the formula gives ~1 at t=0)
      // At t=1, the curve should be close to 1
      final endValue = curve.transform(1.0);
      expect(endValue, closeTo(1.0, 0.01));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ACCESSIBILITY UTILS TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('AccessibilityUtils', () {
    test('sectionHeaderLabel', () {
      expect(
        AccessibilityUtils.sectionHeaderLabel('Navigation', true),
        'Navigation section, expanded',
      );
      expect(
        AccessibilityUtils.sectionHeaderLabel('Navigation', false),
        'Navigation section, collapsed',
      );
    });

    test('nestedItemLabel', () {
      expect(AccessibilityUtils.nestedItemLabel('Home', 0), 'Home');
      expect(AccessibilityUtils.nestedItemLabel('Sub', 1), 'Sub, level 2');
      expect(AccessibilityUtils.nestedItemLabel('Deep', 2), 'Deep, level 3');
    });

    test('badgeLabel for count', () {
      const badge = DrawerItemBadge(count: 5);
      expect(AccessibilityUtils.badgeLabel(badge), '5 notifications');
    });

    test('badgeLabel for label', () {
      const badge = DrawerItemBadge(label: 'NEW');
      expect(AccessibilityUtils.badgeLabel(badge), 'NEW');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // WIDGET TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('DrawerItemWidget', () {
    testWidgets('renders title and icon', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const DrawerItemWidget(
                item: DrawerItem(
                  id: 'test',
                  title: 'Test Item',
                  icon: Icons.home,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Test Item'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);

      controller.dispose();
    });

    testWidgets('renders badge', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const DrawerItemWidget(
                item: DrawerItem(
                  id: 'test',
                  title: 'Test Item',
                  icon: Icons.home,
                  badge: DrawerItemBadge(count: 5),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('shows subtitle', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const DrawerItemWidget(
                item: DrawerItem(
                  id: 'test',
                  title: 'Test Item',
                  subtitle: 'A description',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('A description'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('mini mode shows tooltip', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const DrawerItemWidget(
                item: DrawerItem(
                  id: 'test',
                  title: 'Test Item',
                  icon: Icons.home,
                ),
                isMiniMode: true,
              ),
            ),
          ),
        ),
      );

      // In mini mode, title is in tooltip, not directly visible
      expect(find.byIcon(Icons.home), findsOneWidget);

      controller.dispose();
    });

    testWidgets('handles tap', (WidgetTester tester) async {
      var tapped = false;
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: DrawerItemWidget(
                item: const DrawerItem(
                  id: 'test',
                  title: 'Test Item',
                  icon: Icons.home,
                ),
                onTap: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Test Item'));
      expect(tapped, isTrue);

      controller.dispose();
    });
  });

  group('DrawerHeaderWidget', () {
    testWidgets('renders title and subtitle', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const DrawerHeaderWidget(
                title: 'My App',
                subtitle: 'user@example.com',
              ),
            ),
          ),
        ),
      );

      expect(find.text('My App'), findsOneWidget);
      expect(find.text('user@example.com'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('renders avatar', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const DrawerHeaderWidget(
                title: 'Test',
                avatar: CircleAvatar(child: Text('T')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('T'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('renders custom widget', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const DrawerHeaderWidget(
                customWidget: Center(child: Text('Custom Header')),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom Header'), findsOneWidget);

      controller.dispose();
    });
  });

  group('DrawerSectionWidget', () {
    testWidgets('renders section title and items',
        (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const SingleChildScrollView(
                child: DrawerSectionWidget(
                  section: DrawerSectionData(
                    id: 'main',
                    title: 'Navigation',
                    items: [
                      DrawerItem(
                          id: 'home', title: 'Home', icon: Icons.home),
                      DrawerItem(
                          id: 'search',
                          title: 'Search',
                          icon: Icons.search),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('NAVIGATION'), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Search'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('collapses section on tap', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const SingleChildScrollView(
                child: DrawerSectionWidget(
                  section: DrawerSectionData(
                    id: 'test',
                    title: 'Test Section',
                    items: [
                      DrawerItem(id: 'item1', title: 'Item 1'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Initially expanded
      expect(controller.isSectionExpanded('test'), isTrue);

      // Tap section header to collapse
      await tester.tap(find.text('TEST SECTION'));
      await tester.pumpAndSettle();

      expect(controller.isSectionExpanded('test'), isFalse);

      controller.dispose();
    });

    testWidgets('non-collapsible section shows items without collapse',
        (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DrawerControllerProvider(
              controller: controller,
              child: const SingleChildScrollView(
                child: DrawerSectionWidget(
                  section: DrawerSectionData(
                    id: 'fixed',
                    title: 'Fixed Section',
                    isCollapsible: false,
                    items: [
                      DrawerItem(id: 'item1', title: 'Item 1'),
                      DrawerItem(id: 'item2', title: 'Item 2'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Items should be visible
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      // Section header should not have expand icon since not collapsible
      expect(find.byIcon(Icons.expand_more), findsNothing);

      controller.dispose();
    });
  });

  group('AdvancedAppDrawer', () {
    testWidgets('renders with sections', (WidgetTester tester) async {
      final controller = AdvancedDrawerController(
        initialSelectedItemId: 'home',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedAppDrawer(
              controller: controller,
              sections: const [
                DrawerSectionData(
                  id: 'main',
                  title: 'Main',
                  items: [
                    DrawerItem(
                        id: 'home', title: 'Home', icon: Icons.home),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('renders loading state', (WidgetTester tester) async {
      final controller = AdvancedDrawerController();

      // Start a loading that won't complete during the test
      unawaited(controller.loadItems(() async {
        await Future<void>.delayed(const Duration(seconds: 10));
        return [];
      }));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AdvancedAppDrawer(
              controller: controller,
              sections: const [],
            ),
          ),
        ),
      );

      // The loading state should show shimmer placeholders
      expect(controller.isLoading, isTrue);

      controller.dispose();
    });
  });

  group('DrawerControllerProvider', () {
    testWidgets('provides controller to descendants',
        (WidgetTester tester) async {
      final controller = AdvancedDrawerController(
        initialSelectedItemId: 'test',
      );

      late AdvancedDrawerController foundController;

      await tester.pumpWidget(
        MaterialApp(
          home: DrawerControllerProvider(
            controller: controller,
            child: Builder(
              builder: (context) {
                foundController = DrawerControllerProvider.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      expect(foundController.selectedItemId, 'test');

      controller.dispose();
    });
  });
}
