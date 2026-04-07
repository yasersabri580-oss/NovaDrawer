// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// Example demo application for the NovaDrawer package.
///
/// This demo showcases all major features including:
/// - 10 header variants (classic, glassmorphism, compact, hero, etc.)
/// - 10 drawer surface styles
/// - Content widgets (search, stats, shortcuts, etc.)
/// - 10+ animation types
/// - Responsive layout (mobile, tablet, desktop)
/// - Theming (light/dark mode)
/// - Nested menu items
/// - Dynamic data loading
/// - Gesture controls
/// - Mini-drawer mode
/// - Custom backgrounds
/// - RTL support
/// - Accessibility
library;

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:nova_drawer/main.dart';

import 'screens/header_showcase_screen.dart';
import 'screens/surface_showcase_screen.dart';
import 'screens/content_showcase_screen.dart';
import 'screens/animation_showcase_screen.dart';

void main() {
  runApp(const NovaDrawerDemoApp());
}

/// Root application widget.
class NovaDrawerDemoApp extends StatefulWidget {
  const NovaDrawerDemoApp({super.key});

  @override
  State<NovaDrawerDemoApp> createState() => _NovaDrawerDemoAppState();
}

class _NovaDrawerDemoAppState extends State<NovaDrawerDemoApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isRtl = false;
  DrawerAnimationType _animationType = DrawerAnimationType.slide;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void _toggleRtl() {
    setState(() {
      _isRtl = !_isRtl;
    });
  }

  void _setAnimationType(DrawerAnimationType type) {
    setState(() {
      _animationType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaDrawer Demo',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return Directionality(
          textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: DemoHomePage(
        onToggleTheme: _toggleTheme,
        onToggleRtl: _toggleRtl,
        onAnimationTypeChanged: _setAnimationType,
        currentAnimationType: _animationType,
        isRtl: _isRtl,
        isDark: _themeMode == ThemeMode.dark,
      ),
    );
  }
}

/// The main demo page with the drawer.
class DemoHomePage extends StatefulWidget {
  const DemoHomePage({
    super.key,
    required this.onToggleTheme,
    required this.onToggleRtl,
    required this.onAnimationTypeChanged,
    required this.currentAnimationType,
    required this.isRtl,
    required this.isDark,
  });

  final VoidCallback onToggleTheme;
  final VoidCallback onToggleRtl;
  final void Function(DrawerAnimationType) onAnimationTypeChanged;
  final DrawerAnimationType currentAnimationType;
  final bool isRtl;
  final bool isDark;

  @override
  State<DemoHomePage> createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  late AdvancedDrawerController _drawerController;
  String _selectedPageId = 'home';
  String _selectedPageTitle = 'Home';
  bool _showGradientBg = false;
  bool _showParticleBg = false;
  bool _useDynamicLoading = false;
  HeaderVariant _headerVariant = HeaderVariant.classic;

  @override
  void initState() {
    super.initState();
    _drawerController = AdvancedDrawerController(
      initialSelectedItemId: 'home',
      initiallyOpen: false,
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  // ── Sample user profile for the header ─────────────────────────────

  static const _profile = HeaderUserProfile(
    name: 'Jane Developer',
    email: 'jane@novadev.io',
    role: 'Senior Engineer',
    status: UserStatus.online,
    notificationCount: 5,
  );

  static const _accounts = [
    HeaderUserProfile(name: 'Alice', email: 'alice@team.io', status: UserStatus.online),
    HeaderUserProfile(name: 'Bob', email: 'bob@team.io', status: UserStatus.busy),
    HeaderUserProfile(name: 'Carol', email: 'carol@team.io', status: UserStatus.away),
  ];

  // ── Drawer Data ──────────────────────────────────────────────────────

  List<DrawerSectionData> get _sections => [
        DrawerSectionData(
          id: 'main',
          title: 'Main',
          items: [
            DrawerItem(
              id: 'home',
              title: 'Home',
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              route: '/home',
              badge: const DrawerItemBadge(count: 3),
            ),
            DrawerItem(
              id: 'dashboard',
              title: 'Dashboard',
              icon: Icons.dashboard_outlined,
              selectedIcon: Icons.dashboard,
              route: '/dashboard',
            ),
            DrawerItem(
              id: 'analytics',
              title: 'Analytics',
              icon: Icons.analytics_outlined,
              selectedIcon: Icons.analytics,
              route: '/analytics',
              badge: const DrawerItemBadge(label: 'NEW'),
            ),
          ],
        ),
        DrawerSectionData(
          id: 'content',
          title: 'Content',
          items: [
            DrawerItem(
              id: 'messages',
              title: 'Messages',
              icon: Icons.message_outlined,
              selectedIcon: Icons.message,
              route: '/messages',
              badge: const DrawerItemBadge(count: 42),
            ),
            DrawerItem(
              id: 'files',
              title: 'Files & Media',
              icon: Icons.folder_outlined,
              selectedIcon: Icons.folder,
              children: [
                DrawerItem(
                  id: 'documents',
                  title: 'Documents',
                  icon: Icons.description_outlined,
                  route: '/files/documents',
                ),
                DrawerItem(
                  id: 'images',
                  title: 'Images',
                  icon: Icons.image_outlined,
                  route: '/files/images',
                ),
                DrawerItem(
                  id: 'videos',
                  title: 'Videos',
                  icon: Icons.video_library_outlined,
                  route: '/files/videos',
                  children: [
                    DrawerItem(
                      id: 'recent_videos',
                      title: 'Recent',
                      icon: Icons.access_time,
                      route: '/files/videos/recent',
                    ),
                    DrawerItem(
                      id: 'favorites_videos',
                      title: 'Favorites',
                      icon: Icons.star_outline,
                      route: '/files/videos/favorites',
                    ),
                  ],
                ),
              ],
            ),
            DrawerItem(
              id: 'calendar',
              title: 'Calendar',
              icon: Icons.calendar_today_outlined,
              selectedIcon: Icons.calendar_today,
              route: '/calendar',
            ),
          ],
        ),
        DrawerSectionData(
          id: 'showcase',
          title: 'Showcase',
          icon: Icons.auto_awesome,
          items: [
            DrawerItem(
              id: 'header_showcase',
              title: 'Header Variants',
              icon: Icons.account_circle_outlined,
              selectedIcon: Icons.account_circle,
              route: '/showcase/headers',
            ),
            DrawerItem(
              id: 'surface_showcase',
              title: 'Surface Styles',
              icon: Icons.layers_outlined,
              selectedIcon: Icons.layers,
              route: '/showcase/surfaces',
            ),
            DrawerItem(
              id: 'content_showcase',
              title: 'Content Widgets',
              icon: Icons.widgets_outlined,
              selectedIcon: Icons.widgets,
              route: '/showcase/content',
            ),
            DrawerItem(
              id: 'animation_showcase',
              title: 'Animations',
              icon: Icons.animation_outlined,
              selectedIcon: Icons.animation,
              route: '/showcase/animations',
            ),
          ],
        ),
        DrawerSectionData(
          id: 'settings_section',
          title: 'Settings & Tools',
          items: [
            DrawerItem(
              id: 'settings',
              title: 'Settings',
              icon: Icons.settings_outlined,
              selectedIcon: Icons.settings,
              route: '/settings',
            ),
            DrawerItem(
              id: 'help',
              title: 'Help & Support',
              icon: Icons.help_outline,
              selectedIcon: Icons.help,
              route: '/help',
            ),
            DrawerItem(
              id: 'about',
              title: 'About',
              icon: Icons.info_outline,
              selectedIcon: Icons.info,
              route: '/about',
              subtitle: 'v2.0.0',
            ),
          ],
        ),
      ];

  /// Simulates loading drawer items from an API.
  Future<List<DrawerItem>> _loadDynamicItems() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    return [
      DrawerItem(
        id: 'dynamic_1',
        title: 'Dynamic Item 1',
        icon: Icons.cloud_outlined,
        route: '/dynamic/1',
      ),
      DrawerItem(
        id: 'dynamic_2',
        title: 'Dynamic Item 2',
        icon: Icons.cloud_download_outlined,
        route: '/dynamic/2',
        badge: const DrawerItemBadge(label: 'API'),
      ),
      DrawerItem(
        id: 'dynamic_3',
        title: 'Dynamic Item 3',
        icon: Icons.cloud_upload_outlined,
        route: '/dynamic/3',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final drawerTheme =
        widget.isDark ? AdvancedDrawerTheme.dark() : AdvancedDrawerTheme.light();

    final config = DrawerConfig(
      animationType: widget.currentAnimationType,
      displayMode: DrawerDisplayMode.auto,
      isPinnable: true,
      showMiniOnCollapse: true,
      gestureConfig: const DrawerGestureConfig(
        enableSwipeToOpen: true,
        enableSwipeToClose: true,
      ),
      animationConfig: const DrawerAnimationConfig(
        duration: Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        enableStaggeredAnimations: true,
      ),
    );

    // Build the new header using the header system.
    final headerConfig = NovaHeaderConfig(
      variant: _headerVariant,
      profile: _profile,
      accounts: _accounts,
      showCloseButton: true,
      showPinButton: true,
      showEditProfileButton: true,
      showStatusIndicator: true,
      showNotificationBadge: true,
      enableCollapseExpand: true,
      gradientColors: const [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
      actions: [
        HeaderAction(
          id: 'notifications',
          icon: Icons.notifications_outlined,
          tooltip: 'Notifications',
          badge: 5,
          onTap: () {},
        ),
        HeaderAction(
          id: 'settings',
          icon: Icons.settings_outlined,
          tooltip: 'Settings',
          onTap: () {},
        ),
      ],
      onEditProfile: () {},
      onSwitchAccount: () {},
    );

    // Build the drawer widget
    final drawer = AdvancedAppDrawer(
      controller: _drawerController,
      sections: _sections,
      header: NovaDrawerHeader(config: headerConfig),
      footer: _buildDrawerFooter(),
      onItemTap: (item) {
        setState(() {
          _selectedPageId = item.id;
          _selectedPageTitle = item.title;
        });
      },
      theme: drawerTheme,
      config: config,
      enableGradientBackground: _showGradientBg,
      enableParticleBackground: _showParticleBg,
      particleCount: 15,
    );

    return DrawerScaffoldWidget(
      controller: _drawerController,
      drawer: drawer,
      theme: drawerTheme,
      config: config,
      onItemTap: (item) {
        setState(() {
          _selectedPageId = item.id;
          _selectedPageTitle = item.title;
        });
      },
      miniDrawerHeader: Icon(
        Icons.widgets_outlined,
        color: Theme.of(context).colorScheme.primary,
      ),
      appBar: AppBar(
        title: Text(_selectedPageTitle),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _drawerController.toggle(),
          tooltip: 'Toggle drawer',
        ),
        actions: [
          // Theme toggle
          IconButton(
            icon: Icon(
                widget.isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
            onPressed: widget.onToggleTheme,
            tooltip: 'Toggle theme',
          ),
          // RTL toggle
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: widget.onToggleRtl,
            tooltip: widget.isRtl ? 'Switch to LTR' : 'Switch to RTL',
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildDrawerFooter() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        DrawerAppStatusWidget(
          status: const DrawerAppStatus(
            isOnline: true,
            version: '2.0.0',
            buildNumber: '42',
            statusMessage: 'All systems operational',
          ),
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    // Route to showcase screens based on selected drawer item.
    switch (_selectedPageId) {
      case 'header_showcase':
        return const HeaderShowcaseScreen();
      case 'surface_showcase':
        return const SurfaceShowcaseScreen();
      case 'content_showcase':
        return const ContentShowcaseScreen();
      case 'animation_showcase':
        return const AnimationShowcaseScreen();
      default:
        return _buildMainBody(context);
    }
  }

  Widget _buildMainBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current page indicator
          _buildPageIndicator(),
          const SizedBox(height: 24),

          // Header variant selector
          _buildHeaderVariantSelector(),
          const SizedBox(height: 24),

          // Animation type selector
          _buildAnimationSelector(),
          const SizedBox(height: 24),

          // Feature toggles
          _buildFeatureToggles(),
          const SizedBox(height: 24),

          // Dynamic loading demo
          _buildDynamicLoadingDemo(),
          const SizedBox(height: 24),

          // Responsive info card
          _buildResponsiveInfoCard(context),
          const SizedBox(height: 24),

          // Feature showcase grid
          _buildFeatureShowcase(),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              Icons.navigation_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Page',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                Text(
                  _selectedPageTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderVariantSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Header Variant',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Select a header style for the drawer',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: HeaderVariant.values.map((variant) {
                final isSelected = variant == _headerVariant;
                return ChoiceChip(
                  label: Text(_headerVariantName(variant)),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _headerVariant = variant);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Animation Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              'Select an animation type for the drawer transition',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: DrawerAnimationType.values.map((type) {
                final isSelected = type == widget.currentAnimationType;
                return ChoiceChip(
                  label: Text(_animationTypeName(type)),
                  selected: isSelected,
                  onSelected: (_) => widget.onAnimationTypeChanged(type),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureToggles() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Background Effects',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Gradient Background'),
              subtitle: const Text('Animated color gradient on drawer'),
              value: _showGradientBg,
              onChanged: (value) => setState(() => _showGradientBg = value),
            ),
            SwitchListTile(
              title: const Text('Particle Effects'),
              subtitle: const Text('Floating particles on drawer'),
              value: _showParticleBg,
              onChanged: (value) => setState(() => _showParticleBg = value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicLoadingDemo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dynamic Loading',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Simulate loading drawer items from an API',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                FilledButton.icon(
                  onPressed: () {
                    _drawerController.loadItems(_loadDynamicItems);
                    setState(() => _useDynamicLoading = true);
                  },
                  icon: const Icon(Icons.cloud_download, size: 18),
                  label: const Text('Load Dynamic Items'),
                ),
                const SizedBox(width: 12),
                if (_useDynamicLoading)
                  OutlinedButton(
                    onPressed: () {
                      _drawerController.setSections(_sections);
                      setState(() => _useDynamicLoading = false);
                    },
                    child: const Text('Reset'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponsiveInfoCard(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final deviceType = ResponsiveUtils.getDeviceType(width);

    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Icon(
              deviceType == DeviceType.mobile
                  ? Icons.phone_android
                  : deviceType == DeviceType.tablet
                      ? Icons.tablet_mac
                      : Icons.desktop_mac,
              size: 48,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Device: ${deviceType.name.toUpperCase()}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Width: ${width.toStringAsFixed(0)}px',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withAlpha(179),
                    ),
                  ),
                  Text(
                    'Mode: ${ResponsiveUtils.resolveDisplayMode(DrawerDisplayMode.auto, deviceType).name}',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimaryContainer
                          .withAlpha(179),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureShowcase() {
    final features = [
      _FeatureItem(Icons.account_circle, 'Header System',
          '10 header variants: classic, glassmorphism, hero, collapsible, and more'),
      _FeatureItem(Icons.layers, 'Surface Styles',
          '10 surface styles: glass, neumorphic, gradient, mesh, and more'),
      _FeatureItem(Icons.widgets, 'Content Blocks',
          'Search bar, stats card, shortcuts grid, recent items, filter chips'),
      _FeatureItem(Icons.animation, '10+ Animations',
          'Slide, fade, scale, rotate, morph, elastic, spring, shimmer, blur, gradient'),
      _FeatureItem(Icons.devices, 'Responsive',
          'Adapts to mobile, tablet, and desktop layouts'),
      _FeatureItem(Icons.format_textdirection_r_to_l, 'RTL Support',
          'Full right-to-left language support'),
      _FeatureItem(Icons.account_tree, 'Nested Menus',
          'Multi-level expandable menu items'),
      _FeatureItem(Icons.cloud_download, 'Dynamic Loading',
          'Load menu items from API with loading states'),
      _FeatureItem(Icons.accessibility, 'Accessibility',
          'Screen reader support, focus management, scalable text'),
      _FeatureItem(Icons.palette, 'Theming',
          'Full light/dark mode and custom theme support'),
      _FeatureItem(Icons.view_sidebar, 'Mini Drawer',
          'Collapsed icon-only mode for tablet/desktop'),
      _FeatureItem(Icons.build, 'Builder APIs',
          'Slot-based builder callbacks for deep customization'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 900
                ? 4
                : constraints.maxWidth > 600
                    ? 3
                    : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.3,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final feature = features[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(feature.icon,
                            color: Theme.of(context).colorScheme.primary,
                            size: 28),
                        const SizedBox(height: 8),
                        Text(
                          feature.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            feature.description,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  String _headerVariantName(HeaderVariant variant) {
    switch (variant) {
      case HeaderVariant.classic:
        return 'Classic';
      case HeaderVariant.glassmorphism:
        return 'Glass';
      case HeaderVariant.compact:
        return 'Compact';
      case HeaderVariant.hero:
        return 'Hero';
      case HeaderVariant.expanded:
        return 'Expanded';
      case HeaderVariant.animatedGradient:
        return 'Gradient';
      case HeaderVariant.avatarStack:
        return 'Avatars';
      case HeaderVariant.multiAction:
        return 'Actions';
      case HeaderVariant.statusAware:
        return 'Status';
      case HeaderVariant.collapsible:
        return 'Collapsible';
    }
  }

  String _animationTypeName(DrawerAnimationType type) {
    switch (type) {
      case DrawerAnimationType.slide:
        return 'Slide';
      case DrawerAnimationType.fade:
        return 'Fade';
      case DrawerAnimationType.scale:
        return 'Scale';
      case DrawerAnimationType.rotate:
        return 'Rotate';
      case DrawerAnimationType.morph:
        return 'Morph';
      case DrawerAnimationType.elastic:
        return 'Elastic';
      case DrawerAnimationType.spring:
        return 'Spring';
      case DrawerAnimationType.shimmer:
        return 'Shimmer';
      case DrawerAnimationType.blur:
        return 'Blur';
      case DrawerAnimationType.gradient:
        return 'Gradient';
    }
  }
}

/// Simple data class for feature showcase.
class _FeatureItem {
  const _FeatureItem(this.icon, this.title, this.description);

  final IconData icon;
  final String title;
  final String description;
}
