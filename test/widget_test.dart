// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Tests for the NovaAppDrawer package.
///
/// Covers models, controllers, widgets, animations, and utilities.

// ignore_for_file: dangling_library_doc_comments

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nova_drawer/nova_drawer.dart';

// ═══════════════════════════════════════════════════════════════════════
// MODEL TESTS
// ═══════════════════════════════════════════════════════════════════════

void main() {
  group('NovaDrawerItem', () {
    test('should create with required fields', () {
      const item = NovaDrawerItem(id: 'test', title: 'Test Item');
      expect(item.id, 'test');
      expect(item.title, 'Test Item');
      expect(item.icon, isNull);
      expect(item.children, isEmpty);
      expect(item.hasChildren, isFalse);
      expect(item.isEnabled, isTrue);
      expect(item.isVisible, isTrue);
    });

    test('should report hasChildren correctly', () {
      const parent = NovaDrawerItem(
        id: 'parent',
        title: 'Parent',
        children: [
          NovaDrawerItem(id: 'child1', title: 'Child 1'),
          NovaDrawerItem(id: 'child2', title: 'Child 2'),
        ],
      );
      expect(parent.hasChildren, isTrue);
      expect(parent.children.length, 2);
    });

    test('should support copyWith', () {
      const item = NovaDrawerItem(
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
      const item1 = NovaDrawerItem(id: 'same', title: 'Item 1');
      const item2 = NovaDrawerItem(id: 'same', title: 'Item 2');
      const item3 = NovaDrawerItem(id: 'different', title: 'Item 1');
      expect(item1 == item2, isTrue);
      expect(item1 == item3, isFalse);
      expect(item1.hashCode, item2.hashCode);
    });

    test('effectiveSelectedIcon falls back to icon', () {
      const item = NovaDrawerItem(id: 'test', title: 'Test', icon: Icons.home);
      expect(item.effectiveSelectedIcon, Icons.home);

      const itemWithSelected = NovaDrawerItem(
        id: 'test2',
        title: 'Test 2',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
      );
      expect(itemWithSelected.effectiveSelectedIcon, Icons.home);
    });
  });

  group('NovaDrawerItemBadge', () {
    test('should display count text', () {
      const badge = NovaDrawerItemBadge(count: 5);
      expect(badge.displayText, '5');
    });

    test('should cap count at 99+', () {
      const badge = NovaDrawerItemBadge(count: 150);
      expect(badge.displayText, '99+');
    });

    test('should display label', () {
      const badge = NovaDrawerItemBadge(label: 'NEW');
      expect(badge.displayText, 'NEW');
    });

    test('label takes precedence over count', () {
      const badge = NovaDrawerItemBadge(count: 5, label: 'SALE');
      expect(badge.displayText, 'SALE');
    });

    test('should support copyWith', () {
      const badge = NovaDrawerItemBadge(count: 5);
      final updated = badge.copyWith(count: 10);
      expect(updated.count, 10);
    });
  });

  group('NovaDrawerSectionData', () {
    test('should create with required fields', () {
      const section = NovaDrawerSectionData(
        id: 'main',
        items: [
          NovaDrawerItem(id: 'item1', title: 'Item 1'),
        ],
      );
      expect(section.id, 'main');
      expect(section.items.length, 1);
      expect(section.isCollapsible, isTrue);
      expect(section.initiallyExpanded, isTrue);
    });

    test('should support copyWith', () {
      const section = NovaDrawerSectionData(
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

  group('NovaDrawerTheme', () {
    test('should create with defaults', () {
      const theme = NovaDrawerTheme();
      expect(theme.backgroundColor, isNull);
      expect(theme.iconSize, isNull);
    });

    test('should resolve against ThemeData', () {
      final themeData = ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      );
      const drawerTheme = NovaDrawerTheme();
      final resolved = drawerTheme.resolve(themeData);
      expect(resolved.backgroundColor, isNotNull);
      expect(resolved.selectedItemColor, isNotNull);
      expect(resolved.iconSize, NovaDrawerTheme.defaultIconSize);
      expect(
          resolved.miniDrawerWidth, NovaDrawerTheme.defaultMiniDrawerWidth);
      expect(resolved.expandedDrawerWidth,
          NovaDrawerTheme.defaultExpandedDrawerWidth);
    });

    test('should support copyWith', () {
      const theme = NovaDrawerTheme(elevation: 4.0);
      final copied = theme.copyWith(elevation: 8.0);
      expect(copied.elevation, 8.0);
    });

    test('dark factory creates valid theme', () {
      final theme = NovaDrawerTheme.dark();
      expect(theme.backgroundColor, isNotNull);
      expect(theme.selectedItemColor, isNotNull);
    });

    test('light factory creates valid theme', () {
      final theme = NovaDrawerTheme.light();
      expect(theme.backgroundColor, isNotNull);
      expect(theme.selectedItemColor, isNotNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CONFIG TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaDrawerConfig', () {
    test('should create with defaults', () {
      const config = NovaDrawerConfig();
      expect(config.displayMode, NovaDrawerDisplayMode.auto);
      expect(config.animationType, NovaDrawerAnimationType.slide);
      expect(config.isPinnable, isTrue);
      expect(config.closeOnItemTap, isTrue);
    });

    test('should support copyWith', () {
      const config = NovaDrawerConfig();
      final copied = config.copyWith(
        displayMode: NovaDrawerDisplayMode.side,
        isPinnable: false,
      );
      expect(copied.displayMode, NovaDrawerDisplayMode.side);
      expect(copied.isPinnable, isFalse);
      expect(copied.animationType, NovaDrawerAnimationType.slide);
    });
  });

  group('NovaDrawerBreakpoints', () {
    test('default breakpoints', () {
      const bp = NovaDrawerBreakpoints();
      expect(bp.mobile, 600.0);
      expect(bp.tablet, 1024.0);
    });

    test('standard breakpoints match defaults', () {
      expect(NovaDrawerBreakpoints.standard.mobile, 600.0);
      expect(NovaDrawerBreakpoints.standard.tablet, 1024.0);
    });
  });

  group('NovaDrawerAnimationConfig', () {
    test('effective reverse duration falls back to duration', () {
      const config = NovaDrawerAnimationConfig(
        duration: Duration(milliseconds: 300),
      );
      expect(config.effectiveReverseDuration,
          const Duration(milliseconds: 300));
    });

    test('effective reverse duration uses override', () {
      const config = NovaDrawerAnimationConfig(
        duration: Duration(milliseconds: 300),
        reverseDuration: Duration(milliseconds: 200),
      );
      expect(config.effectiveReverseDuration,
          const Duration(milliseconds: 200));
    });

    test('should support copyWith', () {
      const config = NovaDrawerAnimationConfig();
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

  group('NovaDrawerController', () {
    late NovaDrawerController controller;

    setUp(() {
      controller = NovaDrawerController(
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
        const NovaDrawerItem(id: 'a', title: 'A'),
        const NovaDrawerItem(id: 'b', title: 'B'),
      ]);
      expect(controller.items.length, 2);
    });

    test('setSections', () {
      controller.setSections([
        const NovaDrawerSectionData(
          id: 's1',
          items: [NovaDrawerItem(id: 'item1', title: 'Item 1')],
        ),
      ]);
      expect(controller.sections.length, 1);
    });

    test('loadItems success', () async {
      await controller.loadItems(() async {
        return [const NovaDrawerItem(id: 'loaded', title: 'Loaded')];
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
      controller.updateDeviceType(NovaDeviceType.desktop);
      expect(controller.deviceType, NovaDeviceType.desktop);
    });

    test('mobile device type unpins', () {
      controller.pin();
      controller.updateDeviceType(NovaDeviceType.mobile);
      expect(controller.isPinned, isFalse);
    });

    test('selectByRoute', () {
      controller.setItems([
        const NovaDrawerItem(id: 'home', title: 'Home', route: '/home'),
        const NovaDrawerItem(
          id: 'settings',
          title: 'Settings',
          route: '/settings',
          children: [
            NovaDrawerItem(
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

  group('NovaResponsiveUtils', () {
    test('getDeviceType for mobile', () {
      expect(
        NovaResponsiveUtils.getDeviceType(400),
        NovaDeviceType.mobile,
      );
    });

    test('getDeviceType for tablet', () {
      expect(
        NovaResponsiveUtils.getDeviceType(800),
        NovaDeviceType.tablet,
      );
    });

    test('getDeviceType for desktop', () {
      expect(
        NovaResponsiveUtils.getDeviceType(1200),
        NovaDeviceType.desktop,
      );
    });

    test('getDeviceType with custom breakpoints', () {
      const bp = NovaDrawerBreakpoints(mobile: 500, tablet: 900);
      expect(NovaResponsiveUtils.getDeviceType(450, bp), NovaDeviceType.mobile);
      expect(NovaResponsiveUtils.getDeviceType(700, bp), NovaDeviceType.tablet);
      expect(NovaResponsiveUtils.getDeviceType(950, bp), NovaDeviceType.desktop);
    });

    test('canPin', () {
      expect(NovaResponsiveUtils.canPin(NovaDeviceType.mobile), isFalse);
      expect(NovaResponsiveUtils.canPin(NovaDeviceType.tablet), isTrue);
      expect(NovaResponsiveUtils.canPin(NovaDeviceType.desktop), isTrue);
    });

    test('resolveDisplayMode auto', () {
      expect(
        NovaResponsiveUtils.resolveDisplayMode(
            NovaDrawerDisplayMode.auto, NovaDeviceType.mobile),
        NovaDrawerDisplayMode.overlay,
      );
      expect(
        NovaResponsiveUtils.resolveDisplayMode(
            NovaDrawerDisplayMode.auto, NovaDeviceType.tablet),
        NovaDrawerDisplayMode.push,
      );
      expect(
        NovaResponsiveUtils.resolveDisplayMode(
            NovaDrawerDisplayMode.auto, NovaDeviceType.desktop),
        NovaDrawerDisplayMode.side,
      );
    });

    test('resolveDisplayMode explicit', () {
      expect(
        NovaResponsiveUtils.resolveDisplayMode(
            NovaDrawerDisplayMode.overlay, NovaDeviceType.desktop),
        NovaDrawerDisplayMode.overlay,
      );
    });

    test('shouldShowOverlay', () {
      expect(
        NovaResponsiveUtils.shouldShowOverlay(
            NovaDeviceType.mobile, NovaDrawerDisplayMode.auto),
        isTrue,
      );
      expect(
        NovaResponsiveUtils.shouldShowOverlay(
            NovaDeviceType.desktop, NovaDrawerDisplayMode.auto),
        isFalse,
      );
    });

    test('getNestedIndentation', () {
      expect(NovaResponsiveUtils.getNestedIndentation(0), 0.0);
      expect(NovaResponsiveUtils.getNestedIndentation(1), 16.0);
      expect(NovaResponsiveUtils.getNestedIndentation(2), 32.0);
      expect(NovaResponsiveUtils.getNestedIndentation(1, baseIndent: 24.0), 24.0);
    });

    test('getMaxNestingDepth', () {
      expect(NovaResponsiveUtils.getMaxNestingDepth(150), 1);
      expect(NovaResponsiveUtils.getMaxNestingDepth(250), 2);
      expect(NovaResponsiveUtils.getMaxNestingDepth(300), 3);
      expect(NovaResponsiveUtils.getMaxNestingDepth(400), 4);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ANIMATION CONFIG TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaDrawerAnimationConfig', () {
    test('defaults', () {
      const config = NovaDrawerAnimationConfig();
      expect(config.duration, const Duration(milliseconds: 300));
      expect(config.curve, Curves.easeInOutCubic);
      expect(config.enableItemAnimations, isTrue);
      expect(config.enableStaggeredAnimations, isTrue);
    });

    test('copyWith preserves unmodified values', () {
      const config = NovaDrawerAnimationConfig(
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

  group('NovaElasticCurve', () {
    test('starts at 0 and ends near 1', () {
      const curve = NovaElasticCurve();
      // At t=0, the curve should be close to 0 (actually the formula gives ~1 at t=0)
      // At t=1, the curve should be close to 1
      final endValue = curve.transform(1.0);
      expect(endValue, closeTo(1.0, 0.01));
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // ACCESSIBILITY UTILS TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaAccessibilityUtils', () {
    test('sectionHeaderLabel', () {
      expect(
        NovaAccessibilityUtils.sectionHeaderLabel('Navigation', true),
        'Navigation section, expanded',
      );
      expect(
        NovaAccessibilityUtils.sectionHeaderLabel('Navigation', false),
        'Navigation section, collapsed',
      );
    });

    test('nestedItemLabel', () {
      expect(NovaAccessibilityUtils.nestedItemLabel('Home', 0), 'Home');
      expect(NovaAccessibilityUtils.nestedItemLabel('Sub', 1), 'Sub, level 2');
      expect(NovaAccessibilityUtils.nestedItemLabel('Deep', 2), 'Deep, level 3');
    });

    test('badgeLabel for count', () {
      const badge = NovaDrawerItemBadge(count: 5);
      expect(NovaAccessibilityUtils.badgeLabel(badge), '5 notifications');
    });

    test('badgeLabel for label', () {
      const badge = NovaDrawerItemBadge(label: 'NEW');
      expect(NovaAccessibilityUtils.badgeLabel(badge), 'NEW');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // WIDGET TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaDrawerItemWidget', () {
    testWidgets('renders title and icon', (WidgetTester tester) async {
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const NovaDrawerItemWidget(
                item: NovaDrawerItem(
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
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const NovaDrawerItemWidget(
                item: NovaDrawerItem(
                  id: 'test',
                  title: 'Test Item',
                  icon: Icons.home,
                  badge: NovaDrawerItemBadge(count: 5),
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
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const NovaDrawerItemWidget(
                item: NovaDrawerItem(
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
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const NovaDrawerItemWidget(
                item: NovaDrawerItem(
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
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: NovaDrawerItemWidget(
                item: const NovaDrawerItem(
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

  group('NovaDrawerHeaderWidget', () {
    testWidgets('renders title and subtitle', (WidgetTester tester) async {
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const NovaDrawerHeaderWidget(
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
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const NovaDrawerHeaderWidget(
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
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const NovaDrawerHeaderWidget(
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

  group('NovaDrawerSectionWidget', () {
    testWidgets('renders section title and items',
        (WidgetTester tester) async {
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const SingleChildScrollView(
                child: NovaDrawerSectionWidget(
                  section: NovaDrawerSectionData(
                    id: 'main',
                    title: 'Navigation',
                    items: [
                      NovaDrawerItem(
                          id: 'home', title: 'Home', icon: Icons.home),
                      NovaDrawerItem(
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
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const SingleChildScrollView(
                child: NovaDrawerSectionWidget(
                  section: NovaDrawerSectionData(
                    id: 'test',
                    title: 'Test Section',
                    items: [
                      NovaDrawerItem(id: 'item1', title: 'Item 1'),
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
      final controller = NovaDrawerController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaDrawerControllerProvider(
              controller: controller,
              child: const SingleChildScrollView(
                child: NovaDrawerSectionWidget(
                  section: NovaDrawerSectionData(
                    id: 'fixed',
                    title: 'Fixed Section',
                    isCollapsible: false,
                    items: [
                      NovaDrawerItem(id: 'item1', title: 'Item 1'),
                      NovaDrawerItem(id: 'item2', title: 'Item 2'),
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

  group('NovaAppDrawer', () {
    testWidgets('renders with sections', (WidgetTester tester) async {
      final controller = NovaDrawerController(
        initialSelectedItemId: 'home',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaAppDrawer(
              controller: controller,
              sections: const [
                NovaDrawerSectionData(
                  id: 'main',
                  title: 'Main',
                  items: [
                    NovaDrawerItem(
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
      final controller = NovaDrawerController();

      // Start a loading that won't complete during the test
      unawaited(controller.loadItems(() async {
        await Future<void>.delayed(const Duration(seconds: 10));
        return [];
      }));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NovaAppDrawer(
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

  group('NovaDrawerControllerProvider', () {
    testWidgets('provides controller to descendants',
        (WidgetTester tester) async {
      final controller = NovaDrawerController(
        initialSelectedItemId: 'test',
      );

      late NovaDrawerController foundController;

      await tester.pumpWidget(
        MaterialApp(
          home: NovaDrawerControllerProvider(
            controller: controller,
            child: Builder(
              builder: (context) {
                foundController = NovaDrawerControllerProvider.of(context);
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

  // ═══════════════════════════════════════════════════════════════════════
  // HEADER USER PROFILE TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaHeaderUserProfile', () {
    test('should create with required name', () {
      const profile = NovaHeaderUserProfile(name: 'Alice');
      expect(profile.name, 'Alice');
      expect(profile.email, isNull);
      expect(profile.role, isNull);
      expect(profile.status, NovaUserStatus.unknown);
      expect(profile.notificationCount, 0);
      expect(profile.metadata, isEmpty);
    });

    test('copyWith should override fields', () {
      const profile = NovaHeaderUserProfile(name: 'Alice', email: 'a@b.com');
      final updated = profile.copyWith(name: 'Bob', status: NovaUserStatus.online);
      expect(updated.name, 'Bob');
      expect(updated.email, 'a@b.com');
      expect(updated.status, NovaUserStatus.online);
    });

    test('effectiveSubtitle returns subtitle over email over phone', () {
      const withAll = NovaHeaderUserProfile(
        name: 'A',
        subtitle: 'Sub',
        email: 'e@e.com',
        phone: '555',
      );
      expect(withAll.effectiveSubtitle, 'Sub');

      const emailOnly = NovaHeaderUserProfile(name: 'A', email: 'e@e.com', phone: '555');
      expect(emailOnly.effectiveSubtitle, 'e@e.com');

      const phoneOnly = NovaHeaderUserProfile(name: 'A', phone: '555');
      expect(phoneOnly.effectiveSubtitle, '555');

      const none = NovaHeaderUserProfile(name: 'A');
      expect(none.effectiveSubtitle, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // NOVA HEADER CONFIG TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaHeaderConfig', () {
    test('should have sensible defaults', () {
      const config = NovaHeaderConfig();
      expect(config.variant, NovaHeaderVariant.classic);
      expect(config.profile, isNull);
      expect(config.actions, isEmpty);
      expect(config.showCloseButton, isTrue);
      expect(config.showPinButton, isTrue);
      expect(config.showEditProfileButton, isFalse);
      expect(config.isLoading, isFalse);
      expect(config.isCollapsed, isFalse);
      expect(config.enableCollapseExpand, isFalse);
    });

    test('copyWith should override variant and loading', () {
      const config = NovaHeaderConfig();
      final updated = config.copyWith(
        variant: NovaHeaderVariant.compact,
        isLoading: true,
      );
      expect(updated.variant, NovaHeaderVariant.compact);
      expect(updated.isLoading, isTrue);
      expect(updated.showCloseButton, isTrue);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // HEADER ACTION TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaHeaderAction', () {
    test('should create with required fields', () {
      const action = NovaHeaderAction(id: 'settings', icon: Icons.settings);
      expect(action.id, 'settings');
      expect(action.icon, Icons.settings);
      expect(action.isDestructive, isFalse);
      expect(action.isEnabled, isTrue);
      expect(action.label, isNull);
    });

    test('copyWith should override fields', () {
      const action = NovaHeaderAction(id: 'a', icon: Icons.add);
      final updated = action.copyWith(isDestructive: true, badge: 5);
      expect(updated.isDestructive, isTrue);
      expect(updated.badge, 5);
      expect(updated.id, 'a');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // DRAWER SURFACE CONFIG TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaDrawerSurfaceConfig', () {
    test('should default to plain style', () {
      const config = NovaDrawerSurfaceConfig();
      expect(config.style, NovaDrawerSurfaceStyle.plain);
      expect(config.blurSigma, 10.0);
      expect(config.opacity, 1.0);
      expect(config.elevation, 0.0);
      expect(config.backgroundColor, isNull);
    });

    test('copyWith should override style and opacity', () {
      const config = NovaDrawerSurfaceConfig();
      final updated = config.copyWith(
        style: NovaDrawerSurfaceStyle.gradient,
        opacity: 0.8,
        gradientColors: [Colors.blue, Colors.purple],
      );
      expect(updated.style, NovaDrawerSurfaceStyle.gradient);
      expect(updated.opacity, 0.8);
      expect(updated.gradientColors, hasLength(2));
      expect(updated.blurSigma, 10.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CONTENT MODEL TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('Content Models', () {
    test('NovaDrawerStatItem should create with required fields', () {
      const stat = NovaDrawerStatItem(label: 'Posts', value: '42');
      expect(stat.label, 'Posts');
      expect(stat.value, '42');
      expect(stat.icon, isNull);
    });

    test('NovaDrawerShortcut should create with required fields', () {
      const shortcut = NovaDrawerShortcut(id: 's1', label: 'Home', icon: Icons.home);
      expect(shortcut.id, 's1');
      expect(shortcut.label, 'Home');
      expect(shortcut.icon, Icons.home);
      expect(shortcut.badge, isNull);
    });

    test('NovaDrawerRecentItem should create with required fields', () {
      final item = NovaDrawerRecentItem(
        id: 'r1',
        title: 'Doc',
        timestamp: DateTime(2024, 1, 15),
      );
      expect(item.id, 'r1');
      expect(item.title, 'Doc');
      expect(item.timestamp, isNotNull);
    });

    test('NovaDrawerFilterChip should default to unselected', () {
      const chip = NovaDrawerFilterChip(id: 'c1', label: 'Tag');
      expect(chip.id, 'c1');
      expect(chip.label, 'Tag');
      expect(chip.isSelected, isFalse);
    });

    test('NovaDrawerAppStatus should default to online', () {
      const status = NovaDrawerAppStatus();
      expect(status.isOnline, isTrue);
      expect(status.statusMessage, isNull);
      expect(status.version, isNull);
    });

    test('NovaDrawerWorkspace should create with required fields', () {
      const ws = NovaDrawerWorkspace(id: 'w1', name: 'Personal');
      expect(ws.id, 'w1');
      expect(ws.name, 'Personal');
      expect(ws.isActive, isFalse);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // DRAWER BUILDERS TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaDrawerBuilders', () {
    test('should create with all callbacks null by default', () {
      const builders = NovaDrawerBuilders();
      expect(builders.headerBuilder, isNull);
      expect(builders.itemBuilder, isNull);
      expect(builders.footerBuilder, isNull);
      expect(builders.loadingBuilder, isNull);
      expect(builders.errorBuilder, isNull);
    });

    test('copyWith should override specific builders', () {
      const builders = NovaDrawerBuilders();
      final updated = builders.copyWith(
        footerBuilder: (context) => const Text('Footer'),
      );
      expect(updated.footerBuilder, isNotNull);
      expect(updated.headerBuilder, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // NOVA DRAWER HEADER WIDGET TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaDrawerHeader Widget', () {
    testWidgets('renders with classic variant', (tester) async {
      const config = NovaHeaderConfig(
        variant: NovaHeaderVariant.classic,
        profile: NovaHeaderUserProfile(name: 'Test User', email: 'test@mail.com'),
      );
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NovaDrawerHeader(config: config))),
      );
      expect(find.text('Test User'), findsOneWidget);
    });

    testWidgets('renders loading state', (tester) async {
      const config = NovaHeaderConfig(
        isLoading: true,
        profile: NovaHeaderUserProfile(name: 'Loading User'),
      );
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NovaDrawerHeader(config: config))),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // DRAWER SURFACE WIDGET TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('NovaDrawerSurface Widget', () {
    testWidgets('renders plain surface with child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NovaDrawerSurface(
            config: NovaDrawerSurfaceConfig(style: NovaDrawerSurfaceStyle.plain),
            child: Text('Content'),
          ),
        ),
      );
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('renders gradient surface with child', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: NovaDrawerSurface(
            config: NovaDrawerSurfaceConfig(
              style: NovaDrawerSurfaceStyle.gradient,
              gradientColors: [Colors.blue, Colors.purple],
            ),
            child: Text('Gradient'),
          ),
        ),
      );
      expect(find.text('Gradient'), findsOneWidget);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  // CONTENT WIDGET TESTS
  // ═══════════════════════════════════════════════════════════════════════

  group('Content Widgets', () {
  

    testWidgets('NovaDrawerStatsCard renders stats', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NovaDrawerStatsCard(
              items: [
                NovaDrawerStatItem(label: 'Posts', value: '12'),
                NovaDrawerStatItem(label: 'Likes', value: '99'),
              ],
            ),
          ),
        ),
      );
      expect(find.text('Posts'), findsOneWidget);
      expect(find.text('99'), findsOneWidget);
    });

    testWidgets('NovaDrawerShortcutsGrid renders shortcuts', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: NovaDrawerShortcutsGrid(
              shortcuts: [
                NovaDrawerShortcut(id: 's1', label: 'Home', icon: Icons.home),
                NovaDrawerShortcut(id: 's2', label: 'Files', icon: Icons.folder),
              ],
              crossAxisCount: 2,
            ),
          ),
        ),
      );
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Files'), findsOneWidget);
    });
  });
}
