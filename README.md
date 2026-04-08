# NovaDrawer

<p align="center">
  <a href="https://pub.dev/packages/nova_drawer"><img src="https://img.shields.io/pub/v/nova_drawer.svg" alt="pub.dev"></a>
  <a href="https://github.com/yasersabri580-oss/NovaDrawer/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT License"></a>
  <a href="https://flutter.dev"><img src="https://img.shields.io/badge/Flutter-%3E%3D3.22-blue.svg" alt="Flutter"></a>
  <a href="https://dart.dev"><img src="https://img.shields.io/badge/Dart-%5E3.10-blue.svg" alt="Dart"></a>
</p>

<p align="center">
  A <strong>modern, production-grade, and highly responsive</strong> app drawer system for Flutter.<br>
  Supports <strong>mobile, tablet, and desktop</strong> with 16+ animation types, 10 header variants,<br>
  10 surface styles, nested menus, RTL, accessibility, slot-based builders, and much more.
</p>

---

## 📋 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Complete Example](#-complete-example)
- [Header System](#-header-system)
- [Surface Styles](#-surface-styles)
- [Animations](#-animations)
- [Content Widgets](#-content-widgets)
- [Controller API](#-controller-api)
- [Responsive Behavior](#-responsive-behavior)
- [Theming](#-theming)
- [Slot-Based Builder APIs](#-slot-based-builder-apis)
- [Background Effects](#-background-effects)
- [Gesture Controls](#-gesture-controls)
- [Mini-Drawer Mode](#-mini-drawer-mode)
- [Dynamic Data Loading](#-dynamic-data-loading)
- [RTL Support](#-rtl-support)
- [Accessibility](#-accessibility)
- [Package Structure](#-package-structure)
- [API Reference](#-api-reference)
- [Migration Guide](#-migration-guide)

---

## ✨ Features

### Core

- **Fully responsive** layout that adapts seamlessly across mobile, tablet, and desktop
- **LTR and RTL** language support
- **Expandable and collapsible sections** with smooth transitions
- **Nested menu items** with animated expansion (multi-level)
- Dynamic width adjustment depending on screen size

### 🎨 Header System (10 variants)

| Variant | Description |
|---------|-------------|
| `classic` | Standard cover + avatar + user info layout |
| `glassmorphism` | Frosted glass effect with blur and transparency |
| `compact` | Minimal single-row layout for space-constrained UIs |
| `hero` | Large cover image, magazine-style dramatic layout |
| `expanded` | Full detail with expand/collapse animation |
| `animatedGradient` | Cycling gradient background header |
| `avatarStack` | Multiple account avatars overlapping |
| `multiAction` | Prominent action buttons row |
| `statusAware` | Status-focused with breathing animation |
| `collapsible` | Toggle between expanded/collapsed states |

Each header supports: avatar, cover image, user name, role, email, status indicator, action buttons, notification badge, edit profile shortcut, RTL, theme awareness, loading skeleton state, and custom widget slots.

### 🏗️ Surface Styles (10 variants)

| Style | Description |
|-------|-------------|
| `plain` | Flat background color |
| `elevated` | Shadow-lifted surface |
| `glassmorphism` | Frosted glass with backdrop blur |
| `blurred` | Background-blurred surface |
| `gradient` | Linear gradient fill |
| `premiumShadow` | Deep multi-layer shadow |
| `outlinedMinimal` | Subtle border outline |
| `neumorphic` | Soft inset/outset shadows |
| `imageBacked` | Background image surface |
| `animatedMeshGradient` | Animated shifting gradient |

### 📦 Content Widgets

- **NovaDrawerStatsCard** — Row of stat items with dividers
- **NovaDrawerShortcutsGrid** — Tappable shortcut grid with badges
- **NovaDrawerRecentItems** — Recent items list with timestamps
- **NovaDrawerFilterChipsWidget** — Horizontally scrollable filter chips
- **NovaDrawerAppStatusWidget** — Connection status and version info
- **NovaDrawerWorkspaceSwitcher** — Expandable workspace/account switcher

### 🎬 Animations (16+ types)

| Animation | Description |
|-----------|-------------|
| `slide` | Slides in from the edge |
| `fade` | Opacity fade in/out |
| `scale` | Scales up from a point |
| `rotate` | 3D perspective rotation |
| `morph` | Shape morphing transition |
| `elastic` | Bouncy overshoot effect |
| `spring` | Physics-based spring motion |
| `shimmer` | Loading/highlight sweep |
| `blur` | Gaussian blur transition |
| `gradient` | Color gradient transition |
| `floating` | Floating overlay with shadow depth |
| `floatingBounce` | Floating entry with bounce settle |
| `floatingReveal` | Floating progressive reveal |
| `wave` | Wave distortion transition |
| `parallax` | Parallax depth layers |
| `curtain` | Theatrical curtain open/close |

All animations are smooth and performant. Developers can customize **duration, curve, and style**.

### 🔧 Customizability

- Themeable colors, text styles, icons, shadows, and borders
- **Slot-based builder APIs** for every component (header, items, sections, backgrounds, footer, etc.)
- Inject **custom widgets** inside drawer sections
- **Gesture controls** (swipe to open/close)
- **Pin drawer** open on desktop/tablet
- Light and dark theme support

### 🚀 Advanced Features

- **Dynamic data loading** (menu items fetched from API)
- **Active route highlighting**
- Built-in **accessibility support** (screen readers, focus order, scalable fonts)
- **Mini-drawer mode** for tablet/desktop
- **Custom backgrounds** (animated gradient, particle effects)
- **Auto-hide on scroll** support
- **Account switcher** support
- **Loading skeletons** for headers and content

---

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  nova_drawer:
    git:
      url: https://github.com/yasersabri580-oss/NovaDrawer.git
```

Then run:

```bash
flutter pub get
```

---

## 🚀 Quick Start

The fastest way to add a drawer to your app:

### 1. Import the package

```dart
import 'package:nova_drawer/main.dart';
```

### 2. Create a controller

```dart
final _controller = NovaDrawerController(
  initialSelectedItemId: 'home',
);
```

### 3. Build the scaffold

```dart
NovaDrawerScaffold(
  controller: _controller,
  appBar: AppBar(
    title: const Text('My App'),
    leading: IconButton(
      icon: const Icon(Icons.menu),
      onPressed: _controller.toggle,
    ),
  ),
  drawer: NovaAppDrawer(
    controller: _controller,
    sections: [
      NovaDrawerSectionData(
        id: 'main',
        title: 'Navigation',
        items: [
          NovaDrawerItem(
            id: 'home',
            title: 'Home',
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            route: '/home',
          ),
          NovaDrawerItem(
            id: 'profile',
            title: 'Profile',
            icon: Icons.person_outline,
            selectedIcon: Icons.person,
            badge: NovaDrawerItemBadge(count: 2),
          ),
        ],
      ),
    ],
    header: NovaDrawerHeader(
      config: NovaHeaderConfig(
        variant: NovaHeaderVariant.classic,
        profile: NovaHeaderUserProfile(
          name: 'Jane Developer',
          email: 'jane@example.com',
          status: NovaUserStatus.online,
        ),
      ),
    ),
    onItemTap: (item) {
      Navigator.pushNamed(context, item.route ?? '/');
    },
  ),
  body: const Center(child: Text('Hello, NovaDrawer!')),
)
```

---

## 🔥 Complete Example

The following is a full, self-contained Flutter app that showcases the most important NovaDrawer features:

```dart
import 'package:flutter/material.dart';
import 'package:nova_drawer/main.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaDrawer Demo',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── 1. Create controller ──────────────────────────────────────────────
  final _controller = NovaDrawerController(
    initialSelectedItemId: 'home',
  );

  String _currentPage = 'Home';

  // ── 2. Define sections with nested items and badges ───────────────────
  late final _sections = [
    NovaDrawerSectionData(
      id: 'main',
      title: 'Main',
      items: [
        NovaDrawerItem(
          id: 'home',
          title: 'Home',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home,
          route: '/home',
          onTap: () => setState(() => _currentPage = 'Home'),
        ),
        NovaDrawerItem(
          id: 'dashboard',
          title: 'Dashboard',
          icon: Icons.dashboard_outlined,
          selectedIcon: Icons.dashboard,
          badge: const NovaDrawerItemBadge(count: 3),
          onTap: () => setState(() => _currentPage = 'Dashboard'),
        ),
        NovaDrawerItem(
          id: 'messages',
          title: 'Messages',
          icon: Icons.chat_bubble_outline,
          selectedIcon: Icons.chat_bubble,
          badge: const NovaDrawerItemBadge(label: 'NEW'),
          onTap: () => setState(() => _currentPage = 'Messages'),
        ),
      ],
    ),
    NovaDrawerSectionData(
      id: 'workspace',
      title: 'Workspace',
      items: [
        // Nested menu with sub-items
        NovaDrawerItem(
          id: 'projects',
          title: 'Projects',
          icon: Icons.folder_outlined,
          selectedIcon: Icons.folder,
          initiallyExpanded: true,
          children: [
            NovaDrawerItem(
              id: 'active',
              title: 'Active',
              icon: Icons.circle,
              onTap: () => setState(() => _currentPage = 'Active Projects'),
            ),
            NovaDrawerItem(
              id: 'archived',
              title: 'Archived',
              icon: Icons.archive_outlined,
              onTap: () => setState(() => _currentPage = 'Archived'),
            ),
          ],
        ),
        NovaDrawerItem(
          id: 'team',
          title: 'Team',
          icon: Icons.group_outlined,
          selectedIcon: Icons.group,
          onTap: () => setState(() => _currentPage = 'Team'),
        ),
      ],
    ),
    NovaDrawerSectionData(
      id: 'account',
      title: 'Account',
      items: [
        NovaDrawerItem(
          id: 'settings',
          title: 'Settings',
          icon: Icons.settings_outlined,
          selectedIcon: Icons.settings,
          onTap: () => setState(() => _currentPage = 'Settings'),
        ),
        NovaDrawerItem(
          id: 'logout',
          title: 'Sign Out',
          icon: Icons.logout,
          isEnabled: true,
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    ),
  ];

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── 3. Build with NovaDrawerScaffold ──────────────────────────────
    return NovaDrawerScaffold(
      controller: _controller,

      // App bar with hamburger menu
      appBar: AppBar(
        title: Text(_currentPage),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _controller.toggle,
        ),
      ),

      // ── 4. Configure the drawer ──────────────────────────────────────
      drawer: NovaAppDrawer(
        controller: _controller,
        sections: _sections,

        // ── 5. Hero-style header with user profile ───────────────────
        header: NovaDrawerHeader(
          config: NovaHeaderConfig(
            variant: NovaHeaderVariant.hero,
            profile: const NovaHeaderUserProfile(
              name: 'Jane Developer',
              email: 'jane@acme.io',
              role: 'Senior Engineer',
              status: NovaUserStatus.online,
              notificationCount: 5,
              avatarUrl: 'https://i.pravatar.cc/150?img=47',
            ),
            showCloseButton: true,
            showPinButton: true,
            showEditProfileButton: true,
            actions: [
              NovaHeaderAction(
                id: 'notifications',
                icon: Icons.notifications_outlined,
                badge: 5,
                tooltip: 'Notifications',
                onTap: () {},
              ),
              NovaHeaderAction(
                id: 'settings',
                icon: Icons.settings_outlined,
                tooltip: 'Settings',
                onTap: () {},
              ),
            ],
            onProfileTap: () {},
            onEditProfile: () {},
          ),
        ),

        // ── 6. Content widgets above and below the menu ──────────────
        // (inject via section headerWidget / footerWidget or as items)
        footer: Column(
          children: [
            // Stats bar
            NovaDrawerStatsCard(
              stats: const [
                NovaDrawerStatItem(label: 'Projects', value: '12'),
                NovaDrawerStatItem(label: 'Tasks', value: '48'),
                NovaDrawerStatItem(label: 'Done', value: '89%'),
              ],
            ),
            // App status
            NovaDrawerAppStatusWidget(
              status: const NovaDrawerAppStatus(
                isOnline: true,
                version: '2.4.1',
                statusMessage: 'All systems operational',
              ),
            ),
          ],
        ),

        // ── 7. Animation ─────────────────────────────────────────────
        config: const NovaDrawerConfig(
          animationType: NovaDrawerAnimationType.spring,
          animationConfig: NovaDrawerAnimationConfig(
            duration: Duration(milliseconds: 380),
          ),
          displayMode: NovaDrawerDisplayMode.auto,
          isPinnable: true,
          gestureConfig: NovaDrawerGestureConfig(
            enableSwipeToOpen: true,
            enableSwipeToClose: true,
            swipeEdgeWidth: 24.0,
          ),
          accessibilityConfig: NovaDrawerAccessibilityConfig(
            enableSemantics: true,
            drawerLabel: 'Main navigation drawer',
          ),
        ),

        // ── 8. Surface style ─────────────────────────────────────────
        // Pass the surface via the theme or use NovaDrawerSurface widget.
        theme: const NovaDrawerTheme(
          selectedItemColor: Color(0xFF6366F1),
          selectedItemBackgroundColor: Color(0x1A6366F1),
          itemBorderRadius: BorderRadius.all(Radius.circular(12)),
          elevation: 6.0,
        ),

        // ── 9. Callback ───────────────────────────────────────────────
        onItemTap: (item) {
          _controller.selectItem(item.id);
        },
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome, size: 48, color: Colors.indigo),
            const SizedBox(height: 16),
            Text(
              _currentPage,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('Swipe from the left edge to open the drawer'),
          ],
        ),
      ),
    );
  }
}
```

---

## 🎭 Header System

### Switching between header variants

All 10 variants share the same `NovaHeaderConfig`. Change a single parameter to switch styles:

```dart
// Classic — avatar + name + subtitle
NovaHeaderConfig(variant: NovaHeaderVariant.classic, profile: profile)

// Glassmorphism — frosted glass with blur overlay
NovaHeaderConfig(variant: NovaHeaderVariant.glassmorphism, profile: profile)

// Compact — icon-only row, ideal for mini/side drawers
NovaHeaderConfig(variant: NovaHeaderVariant.compact, profile: profile)

// Hero — large cover photo with magazine-style layout
NovaHeaderConfig(variant: NovaHeaderVariant.hero, profile: profile)

// Expanded — shows additional details and extra actions
NovaHeaderConfig(variant: NovaHeaderVariant.expanded, profile: profile)

// Animated gradient — cycling colour background
NovaHeaderConfig(
  variant: NovaHeaderVariant.animatedGradient,
  profile: profile,
  gradientColors: [Colors.indigo, Colors.purple, Colors.pink],
)

// Avatar stack — multi-account overlay avatars
NovaHeaderConfig(
  variant: NovaHeaderVariant.avatarStack,
  profile: primaryUser,
  accounts: [
    NovaHeaderUserProfile(name: 'Alice', status: NovaUserStatus.online),
    NovaHeaderUserProfile(name: 'Bob',   status: NovaUserStatus.busy),
    NovaHeaderUserProfile(name: 'Carol', status: NovaUserStatus.away),
  ],
  onSwitchAccount: () => showAccountPicker(context),
)

// Multi-action — big action buttons row
NovaHeaderConfig(
  variant: NovaHeaderVariant.multiAction,
  profile: profile,
  actions: [
    NovaHeaderAction(id: 'edit',   icon: Icons.edit,           label: 'Edit',    onTap: () {}),
    NovaHeaderAction(id: 'share',  icon: Icons.share,          label: 'Share',   onTap: () {}),
    NovaHeaderAction(id: 'logout', icon: Icons.logout,         label: 'Sign Out',
        isDestructive: true, onTap: () {}),
  ],
)

// Status-aware — breathing animation on online indicator
NovaHeaderConfig(
  variant: NovaHeaderVariant.statusAware,
  profile: profile.copyWith(status: NovaUserStatus.online),
)

// Collapsible — toggles between full and mini header
NovaHeaderConfig(
  variant: NovaHeaderVariant.collapsible,
  profile: profile,
  enableCollapseExpand: true,
  isCollapsed: false,
)
```

### Loading skeleton state

```dart
NovaHeaderConfig(
  variant: NovaHeaderVariant.classic,
  profile: myProfile,
  isLoading: isLoadingUser, // Shows skeleton shimmer while true
)
```

### Fully custom header

```dart
NovaHeaderConfig(
  customHeaderBuilder: (context, config) {
    return Container(
      height: 180,
      color: Colors.teal,
      child: Center(
        child: Text(
          config.profile?.name ?? '',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  },
)
```

---

## 🏗️ Surface Styles

`NovaDrawerSurface` wraps any child with one of the 10 built-in surface styles:

```dart
NovaDrawerSurface(
  config: NovaDrawerSurfaceConfig(
    style: NovaDrawerSurfaceStyle.glassmorphism,
    blurSigma: 18.0,
    opacity: 0.75,
    borderRadius: BorderRadius.circular(20),
  ),
  child: myContent,
)
```

**Quick surface showcase:**

```dart
// Glassmorphism
NovaDrawerSurfaceConfig(style: NovaDrawerSurfaceStyle.glassmorphism, blurSigma: 15)

// Deep premium shadow
NovaDrawerSurfaceConfig(style: NovaDrawerSurfaceStyle.premiumShadow, elevation: 16)

// Gradient fill
NovaDrawerSurfaceConfig(
  style: NovaDrawerSurfaceStyle.gradient,
  gradientColors: [Color(0xFF1E3A5F), Color(0xFF4A1942)],
)

// Neumorphic soft-UI
NovaDrawerSurfaceConfig(
  style: NovaDrawerSurfaceStyle.neumorphic,
  backgroundColor: Color(0xFFE0E5EC),
)

// Animated mesh gradient
NovaDrawerSurfaceConfig(
  style: NovaDrawerSurfaceStyle.animatedMeshGradient,
  meshColors: [Colors.blue, Colors.purple, Colors.pink, Colors.cyan],
)

// Image-backed
NovaDrawerSurfaceConfig(
  style: NovaDrawerSurfaceStyle.imageBacked,
  backgroundImage: AssetImage('assets/drawer_bg.jpg'),
  backgroundImageFit: BoxFit.cover,
)
```

---

## 🎬 Animations

### Choosing an animation type

```dart
NovaDrawerConfig(
  animationType: NovaDrawerAnimationType.elastic, // 16 types available
  animationConfig: NovaDrawerAnimationConfig(
    duration: Duration(milliseconds: 420),
    curve: Curves.easeOutBack,
  ),
)
```

### Physics-based spring animation

```dart
NovaDrawerConfig(
  animationType: NovaDrawerAnimationType.spring,
  animationConfig: NovaDrawerAnimationConfig(
    springDamping: 0.65,
    springStiffness: 250.0,
  ),
)
```

### Wave / Curtain / Parallax

```dart
// Wave distortion
NovaDrawerConfig(animationType: NovaDrawerAnimationType.wave)

// Theatrical curtain split
NovaDrawerConfig(animationType: NovaDrawerAnimationType.curtain)

// Multi-layer depth parallax
NovaDrawerConfig(animationType: NovaDrawerAnimationType.parallax)
```

---

## 📦 Content Widgets

### Stats card

```dart
NovaDrawerStatsCard(
  stats: const [
    NovaDrawerStatItem(label: 'Projects', value: '12', icon: Icons.folder),
    NovaDrawerStatItem(label: 'Tasks',    value: '48', icon: Icons.task_alt),
    NovaDrawerStatItem(label: 'Messages', value: '7',  icon: Icons.chat_bubble),
  ],
)
```

### Shortcuts grid

```dart
NovaDrawerShortcutsGrid(
  shortcuts: [
    NovaDrawerShortcut(
      id: 'new_doc',
      label: 'New Doc',
      icon: Icons.add_box_outlined,
      color: Colors.blue,
      onTap: () {},
    ),
    NovaDrawerShortcut(
      id: 'upload',
      label: 'Upload',
      icon: Icons.cloud_upload_outlined,
      color: Colors.green,
      badge: 2,
      onTap: () {},
    ),
    NovaDrawerShortcut(
      id: 'calendar',
      label: 'Calendar',
      icon: Icons.calendar_today_outlined,
      color: Colors.orange,
      onTap: () {},
    ),
    NovaDrawerShortcut(
      id: 'analytics',
      label: 'Analytics',
      icon: Icons.bar_chart,
      color: Colors.purple,
      onTap: () {},
    ),
  ],
)
```

### Recent items

```dart
NovaDrawerRecentItems(
  items: [
    NovaDrawerRecentItem(
      id: 'r1',
      title: 'Q3 Report.pdf',
      subtitle: 'Edited 2h ago',
      icon: Icons.picture_as_pdf,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      onTap: () {},
    ),
    NovaDrawerRecentItem(
      id: 'r2',
      title: 'Sprint Planning',
      subtitle: 'Meeting notes',
      icon: Icons.description_outlined,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      onTap: () {},
    ),
  ],
)
```

### Filter chips

```dart
NovaDrawerFilterChipsWidget(
  chips: [
    NovaDrawerFilterChip(id: 'all',    label: 'All',    isSelected: true,  onSelected: (_) {}),
    NovaDrawerFilterChip(id: 'active', label: 'Active',                    onSelected: (_) {}),
    NovaDrawerFilterChip(id: 'done',   label: 'Done',                      onSelected: (_) {}),
  ],
)
```

### Workspace switcher

```dart
NovaDrawerWorkspaceSwitcher(
  workspaces: [
    NovaDrawerWorkspace(
      id: 'personal',
      name: 'Personal',
      icon: Icons.person,
      isActive: true,
      onSelect: () {},
    ),
    NovaDrawerWorkspace(
      id: 'acme',
      name: 'Acme Corp',
      icon: Icons.business,
      onSelect: () {},
    ),
    NovaDrawerWorkspace(
      id: 'startup',
      name: 'My Startup',
      icon: Icons.rocket_launch,
      onSelect: () {},
    ),
  ],
)
```

### App status footer

```dart
NovaDrawerAppStatusWidget(
  status: const NovaDrawerAppStatus(
    isOnline: true,
    version: '2.4.1',
    buildNumber: '142',
    statusMessage: 'Connected · Last sync 5 min ago',
  ),
)
```

---

## 🎛️ Controller API

`NovaDrawerController` is a `ChangeNotifier`. Use it directly or provide it via `NovaDrawerControllerProvider`.

```dart
final controller = NovaDrawerController(
  initialSelectedItemId: 'home',
  initiallyOpen: false,
  initiallyPinned: false,  // useful for desktop default
);

// Open / close
controller.open();
controller.close();
controller.toggle();

// Pin (tablet/desktop persistent mode)
controller.pin();
controller.unpin();
controller.togglePin();

// Mini mode (icon-only sidebar)
controller.toMini();
controller.fromMini();
controller.toggleMini();

// Item selection
controller.selectItem('settings');
controller.selectByRoute('/settings/account');  // auto-expands parents
controller.clearSelection();

// Section expand/collapse
controller.expandSection('workspace');
controller.collapseSection('workspace');
controller.toggleSection('workspace');

// Nested item expand/collapse
controller.expandItem('projects');
controller.collapseItem('projects');

// Visibility / enable
controller.disableItem('logout');
controller.enableItem('logout');
controller.hideItem('admin');
controller.showItem('admin');

// Read state
print(controller.isOpen);
print(controller.isPinned);
print(controller.isMini);
print(controller.selectedItemId);
print(controller.isLoading);
```

### Accessing the controller from descendants

```dart
// Provide at the top:
NovaDrawerControllerProvider(
  controller: _controller,
  child: MyDrawerContent(),
)

// Read anywhere below:
final ctrl = NovaDrawerControllerProvider.of(context);   // subscribes
final ctrl = NovaDrawerControllerProvider.read(context); // one-shot read
```

---

## 📱 Responsive Behavior

| Device | Breakpoint | Default Mode |
|--------|-----------|--------------|
| Mobile | < 600 px | Overlay (slides over content) |
| Tablet | 600–1024 px | Push (pushes content aside) |
| Desktop | > 1024 px | Side (persistent alongside content) |

### Custom breakpoints

```dart
NovaDrawerConfig(
  breakpoints: const NovaDrawerBreakpoints(
    mobile: 540,
    tablet: 960,
  ),
)
```

### Force a specific mode

```dart
NovaDrawerConfig(displayMode: NovaDrawerDisplayMode.side)   // Always persistent
NovaDrawerConfig(displayMode: NovaDrawerDisplayMode.overlay) // Always overlay
NovaDrawerConfig(displayMode: NovaDrawerDisplayMode.push)    // Always push
NovaDrawerConfig(displayMode: NovaDrawerDisplayMode.mini)    // Always mini
```

---

## 🎨 Theming

### Using the built-in theme

```dart
NovaAppDrawer(
  theme: const NovaDrawerTheme(
    backgroundColor: Color(0xFF1E1E2E),
    selectedItemColor: Color(0xFF89B4FA),
    selectedItemBackgroundColor: Color(0x2089B4FA),
    unselectedItemColor: Color(0xFFCDD6F4),
    headerBackgroundColor: Color(0xFF181825),
    itemBorderRadius: BorderRadius.all(Radius.circular(10)),
    itemTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    sectionTitleStyle: TextStyle(fontSize: 11, letterSpacing: 1.2),
    elevation: 8.0,
    iconSize: 22.0,
    itemHeight: 48.0,
    expandedDrawerWidth: 280.0,
    miniDrawerWidth: 64.0,
  ),
)
```

---

## 🔌 Slot-Based Builder APIs

Override any part of the drawer with custom widgets:

```dart
NovaAppDrawer(
  controller: _controller,
  sections: _sections,
  builders: NovaDrawerBuilders(
    // Replace the default item rendering
    itemBuilder: (context, item, isSelected) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Icon(item.icon, color: isSelected ? Colors.indigo : null),
          title: Text(item.title),
          selected: isSelected,
        ),
      );
    },

    // Custom section header
    sectionBuilder: (context, section) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          section.title?.toUpperCase() ?? '',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: Colors.grey,
          ),
        ),
      );
    },

    // Custom loading placeholder
    loadingBuilder: (context) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    },

    // Custom empty state
    emptyStateBuilder: (context) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 48, color: Colors.grey),
            SizedBox(height: 8),
            Text('No menu items', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    },

    // Custom error state
    errorBuilder: (context, message, onRetry) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            Text(message ?? 'Error'),
            if (onRetry != null)
              TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      );
    },

    // Custom footer
    footerBuilder: (context) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('v1.0.0 · NovaDrawer', style: TextStyle(color: Colors.grey)),
      );
    },
  ),
)
```

---

## 🎆 Background Effects

### Animated gradient background

```dart
NovaAppDrawer(
  controller: _controller,
  sections: _sections,
  enableGradientBackground: true,
  gradientColors: const [
    Color(0xFF0F2027),
    Color(0xFF203A43),
    Color(0xFF2C5364),
  ],
)
```

### Particle effects

```dart
NovaAppDrawer(
  controller: _controller,
  sections: _sections,
  enableParticleBackground: true,
  particleColor: Colors.white,
  particleCount: 30,
)
```

---

## 👆 Gesture Controls

```dart
NovaDrawerConfig(
  gestureConfig: const NovaDrawerGestureConfig(
    enableSwipeToOpen: true,     // Swipe from left edge to open
    enableSwipeToClose: true,    // Swipe drawer to close
    swipeEdgeWidth: 24.0,        // Detection edge width in logical px
    swipeSensitivity: 0.5,       // 0.0 = very sensitive, 1.0 = very resistant
    enableDragHandle: true,      // Show a visible drag handle
    dragHandleColor: Colors.grey,
  ),
)
```

---

## 📐 Mini-Drawer Mode

On tablet/desktop the drawer can collapse to a slim icon-only sidebar:

```dart
NovaDrawerConfig(
  showMiniOnCollapse: true,
  enableHoverExpand: true,                          // Expand on mouse hover
  hoverExpandDelay: const Duration(milliseconds: 400),
)

// Programmatic control
_controller.toMini();    // Collapse to icon-only
_controller.fromMini();  // Expand back
_controller.toggleMini();
```

You can also use `NovaMiniDrawer` directly for a fixed sidebar:

```dart
NovaMiniDrawer(
  controller: _controller,
  items: iconOnlyItems,
  width: 64,
)
```

---

## 🔗 Dynamic Data Loading

The drawer shows a shimmer skeleton automatically while loading:

```dart
// Load items from an API
await _controller.loadItems(() async {
  final response = await http.get(Uri.parse('https://api.example.com/menu'));
  final data = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();
  return data
      .map((e) => NovaDrawerItem(
            id: e['id'] as String,
            title: e['title'] as String,
            icon: Icons.circle,
          ))
      .toList();
});

// Load sections from an API
await _controller.loadSections(() async {
  // ... fetch and return List<NovaDrawerSectionData>
});

// Error state is stored in controller.errorMessage
if (_controller.errorMessage != null) {
  print('Failed: ${_controller.errorMessage}');
}
```

---

## 🌐 RTL Support

RTL is automatically inferred from `Directionality`. To force RTL:

```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: NovaDrawerScaffold(
    controller: _controller,
    drawer: NovaAppDrawer(
      controller: _controller,
      config: const NovaDrawerConfig(rtlSupport: true),
      sections: _sections,
    ),
    body: myBody,
  ),
)
```

---

## ♿ Accessibility

NovaDrawer is built with accessibility first:

- **Semantic labels** for screen readers (TalkBack / VoiceOver)
- **Focus traversal** for keyboard and switch-access navigation
- **Scalable text** respects system font size settings
- **Minimum touch targets** (48 × 48 logical pixels)
- **Drawer open/close announcements** for screen readers

```dart
NovaDrawerConfig(
  accessibilityConfig: const NovaDrawerAccessibilityConfig(
    enableSemantics: true,
    enableFocusTraversal: true,
    enableScalableText: true,
    minimumTouchTarget: 48.0,
    announceOnOpen: true,
    announceOnClose: true,
    drawerLabel: 'Main navigation drawer',
    closeButtonLabel: 'Close navigation drawer',
  ),
)
```

Custom semantic labels per item:

```dart
NovaDrawerItem(
  id: 'inbox',
  title: 'Inbox',
  icon: Icons.inbox,
  badge: const NovaDrawerItemBadge(count: 12),
  semanticLabel: 'Inbox, 12 unread messages',
)
```

---

## 📁 Package Structure

```
lib/
  main.dart                     # Barrel export (library nova_drawer)
  src/
    models/
      drawer_item.dart          # NovaDrawerItem · NovaDrawerSectionData · NovaDrawerItemBadge
      drawer_theme.dart         # NovaDrawerTheme · NovaDrawerBadgeTheme
      drawer_config.dart        # NovaDrawerConfig · NovaDrawerAnimationType · NovaDrawerDisplayMode
      header_config.dart        # NovaHeaderConfig · NovaHeaderUserProfile · NovaHeaderAction
      surface_config.dart       # NovaDrawerSurfaceConfig · NovaDrawerSurface
      content_config.dart       # NovaDrawerStatItem · NovaDrawerShortcut · NovaDrawerRecentItem
                                # NovaDrawerFilterChip · NovaDrawerAppStatus · NovaDrawerWorkspace
    controllers/
      drawer_controller.dart    # NovaDrawerController · NovaDrawerControllerProvider
    headers/
      nova_drawer_header.dart   # NovaDrawerHeader (routes to variant widgets)
      header_utils.dart         # NovaHeaderWidgetUtils (shared helpers)
      profile_header_*.dart     # 10 individual header variant widgets
    builders/
      drawer_builders.dart      # NovaDrawerBuilders (slot callbacks)
    widgets/
      advanced_app_drawer.dart  # NovaAppDrawer (main widget)
      drawer_header.dart        # NovaDrawerHeaderWidget (legacy)
      drawer_item_widget.dart   # NovaDrawerItemWidget
      drawer_section.dart       # NovaDrawerSectionWidget
      nested_menu_item.dart     # NovaNestedMenuItem
      mini_drawer.dart          # NovaMiniDrawer
      drawer_scaffold.dart      # NovaDrawerScaffold
      drawer_stats_card.dart    # NovaDrawerStatsCard
      drawer_shortcuts_grid.dart# NovaDrawerShortcutsGrid
      drawer_recent_items.dart  # NovaDrawerRecentItems
      drawer_filter_chips.dart  # NovaDrawerFilterChipsWidget
      drawer_app_status.dart    # NovaDrawerAppStatusWidget
      drawer_workspace_switcher.dart # NovaDrawerWorkspaceSwitcher
    animations/
      animation_config.dart     # NovaDrawerAnimationConfig
      animation_wrapper.dart    # NovaDrawerAnimationWrapper
      *_animation.dart          # 16 individual animation implementations
    utils/
      responsive_utils.dart     # NovaResponsiveUtils · NovaDeviceType
      accessibility_utils.dart  # NovaAccessibilityUtils
    backgrounds/
      gradient_background.dart  # NovaGradientBackground
      particle_background.dart  # NovaParticleBackground
    deprecated_aliases.dart     # @Deprecated typedefs for backward compatibility
```

---

## 🔧 API Reference

### `NovaDrawerController`

| Method | Description |
|--------|-------------|
| `open()` | Opens the drawer |
| `close()` | Closes the drawer (no-op when pinned) |
| `toggle()` | Toggles open/close |
| `pin()` / `unpin()` / `togglePin()` | Persistent pin control |
| `toMini()` / `fromMini()` / `toggleMini()` | Mini/icon-only mode |
| `selectItem(id)` | Select item by ID |
| `selectByRoute(path)` | Select item by route, auto-expands parents |
| `clearSelection()` | Clear active selection |
| `expandSection(id)` / `collapseSection(id)` | Section expand/collapse |
| `expandItem(id)` / `collapseItem(id)` | Nested item expand/collapse |
| `disableItem(id)` / `enableItem(id)` | Item enable state |
| `hideItem(id)` / `showItem(id)` | Item visibility |
| `setItems(items)` | Bulk-set items |
| `setSections(sections)` | Bulk-set sections |
| `loadItems(loader)` | Async dynamic item loading |
| `loadSections(loader)` | Async dynamic section loading |

| Property | Type | Description |
|----------|------|-------------|
| `isOpen` | `bool` | Whether drawer is open |
| `isPinned` | `bool` | Whether drawer is pinned |
| `isMini` | `bool` | Whether in mini mode |
| `isAnimating` | `bool` | Animation in progress |
| `isLoading` | `bool` | Data load in progress |
| `errorMessage` | `String?` | Last load error |
| `selectedItemId` | `String?` | Active item ID |

---

### `NovaAppDrawer`

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `NovaDrawerController` | required | Drawer state manager |
| `sections` | `List<NovaDrawerSectionData>` | `[]` | Grouped menu items |
| `items` | `List<NovaDrawerItem>` | `[]` | Flat item list (when no sections) |
| `header` | `Widget?` | `null` | Header widget |
| `footer` | `Widget?` | `null` | Footer widget |
| `onItemTap` | `Function(NovaDrawerItem)?` | `null` | Item tap callback |
| `theme` | `NovaDrawerTheme?` | `null` | Visual theme |
| `config` | `NovaDrawerConfig` | `NovaDrawerConfig()` | Behavior configuration |
| `builders` | `NovaDrawerBuilders?` | `null` | Slot-based custom builders |
| `width` | `double?` | auto | Override drawer width |
| `enableGradientBackground` | `bool` | `false` | Animated gradient backdrop |
| `gradientColors` | `List<Color>?` | `null` | Gradient color stops |
| `enableParticleBackground` | `bool` | `false` | Particle effect backdrop |
| `particleColor` | `Color?` | `null` | Particle color |
| `particleCount` | `int` | `20` | Number of particles |

---

### `NovaHeaderConfig`

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `variant` | `NovaHeaderVariant` | `classic` | Header style |
| `profile` | `NovaHeaderUserProfile?` | `null` | User data |
| `actions` | `List<NovaHeaderAction>` | `[]` | Action buttons |
| `showCloseButton` | `bool` | `true` | Show × button |
| `showPinButton` | `bool` | `true` | Show pin button |
| `showEditProfileButton` | `bool` | `false` | Show edit shortcut |
| `showStatusIndicator` | `bool` | `true` | Show online status dot |
| `showNotificationBadge` | `bool` | `true` | Show notification count |
| `isLoading` | `bool` | `false` | Show skeleton shimmer |
| `isCollapsed` | `bool` | `false` | Collapsed state |
| `enableCollapseExpand` | `bool` | `false` | Allow toggling |
| `accounts` | `List<NovaHeaderUserProfile>` | `[]` | Extra accounts for stack |
| `gradientColors` | `List<Color>?` | `null` | For `animatedGradient` variant |
| `customHeaderBuilder` | `Widget Function?` | `null` | Fully custom header |

---

### `NovaDrawerItem`

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | **Required** unique identifier |
| `title` | `String` | **Required** display text |
| `icon` | `IconData?` | Default icon |
| `selectedIcon` | `IconData?` | Icon when selected (falls back to `icon`) |
| `children` | `List<NovaDrawerItem>` | Nested sub-items |
| `badge` | `NovaDrawerItemBadge?` | Notification badge |
| `route` | `String?` | Route path for `selectByRoute()` |
| `subtitle` | `String?` | Secondary text |
| `tooltip` | `String?` | Hover tooltip |
| `semanticLabel` | `String?` | Screen reader label |
| `onTap` | `VoidCallback?` | Tap callback |
| `isEnabled` | `bool` | Interactive state |
| `isVisible` | `bool` | Visibility |
| `initiallyExpanded` | `bool` | Start expanded (nested) |
| `customWidget` | `Widget?` | Replace entire item rendering |
| `leading` | `Widget?` | Custom leading widget |
| `trailing` | `Widget?` | Custom trailing widget |
| `metadata` | `Map<String, dynamic>?` | Arbitrary extra data |

---

### Enumerations

**`NovaDrawerAnimationType`**
`slide` · `fade` · `scale` · `rotate` · `morph` · `elastic` · `spring` · `shimmer` · `blur` · `gradient` · `floating` · `floatingBounce` · `floatingReveal` · `wave` · `parallax` · `curtain`

**`NovaDrawerDisplayMode`**
`auto` · `overlay` · `push` · `side` · `mini`

**`NovaHeaderVariant`**
`classic` · `glassmorphism` · `compact` · `hero` · `expanded` · `animatedGradient` · `avatarStack` · `multiAction` · `statusAware` · `collapsible`

**`NovaDrawerSurfaceStyle`**
`plain` · `elevated` · `glassmorphism` · `blurred` · `gradient` · `premiumShadow` · `outlinedMinimal` · `neumorphic` · `imageBacked` · `animatedMeshGradient`

**`NovaUserStatus`**
`online` · `offline` · `busy` · `away` · `unknown`

---

## 🔄 Migration Guide

All public APIs were renamed from the old `Drawer*` / `Advanced*` prefix to the unified `Nova*` prefix. The old names remain available as **deprecated typedefs** in `deprecated_aliases.dart` and will be removed in v2.

### Key renames

| Old Name | New Name |
|----------|----------|
| `AdvancedDrawerController` | `NovaDrawerController` |
| `AdvancedDrawerTheme` | `NovaDrawerTheme` |
| `AdvancedAppDrawer` | `NovaAppDrawer` |
| `DrawerScaffoldWidget` | `NovaDrawerScaffold` |
| `DrawerItem` | `NovaDrawerItem` |
| `DrawerItemBadge` | `NovaDrawerItemBadge` |
| `DrawerSectionData` | `NovaDrawerSectionData` |
| `DrawerConfig` | `NovaDrawerConfig` |
| `DrawerAnimationType` | `NovaDrawerAnimationType` |
| `DrawerAnimationConfig` | `NovaDrawerAnimationConfig` |
| `DrawerDisplayMode` | `NovaDrawerDisplayMode` |
| `DrawerBreakpoints` | `NovaDrawerBreakpoints` |
| `DrawerGestureConfig` | `NovaDrawerGestureConfig` |
| `DrawerAccessibilityConfig` | `NovaDrawerAccessibilityConfig` |
| `DrawerHeaderWidget` | `NovaDrawerHeaderWidget` |
| `DrawerStatsCard` | `NovaDrawerStatsCard` |
| `DrawerStatItem` | `NovaDrawerStatItem` |
| `DrawerShortcutsGrid` | `NovaDrawerShortcutsGrid` |
| `DrawerShortcut` | `NovaDrawerShortcut` |
| `DrawerRecentItems` | `NovaDrawerRecentItems` |
| `DrawerRecentItem` | `NovaDrawerRecentItem` |
| `DrawerFilterChips` | `NovaDrawerFilterChipsWidget` |
| `DrawerFilterChip` | `NovaDrawerFilterChip` |
| `DrawerAppStatusWidget` | `NovaDrawerAppStatusWidget` |
| `DrawerAppStatus` | `NovaDrawerAppStatus` |
| `DrawerWorkspaceSwitcher` | `NovaDrawerWorkspaceSwitcher` |
| `DrawerWorkspace` | `NovaDrawerWorkspace` |
| `DrawerSurface` | `NovaDrawerSurface` |
| `DrawerSurfaceConfig` | `NovaDrawerSurfaceConfig` |
| `DrawerSurfaceStyle` | `NovaDrawerSurfaceStyle` |
| `DrawerBuilders` | `NovaDrawerBuilders` |
| `MiniDrawerWidget` | `NovaMiniDrawer` |
| `NestedMenuItem` | `NovaNestedMenuItem` |
| `HeaderVariant` | `NovaHeaderVariant` |
| `HeaderAction` | `NovaHeaderAction` |
| `HeaderUserProfile` | `NovaHeaderUserProfile` |
| `UserStatus` | `NovaUserStatus` |
| `DrawerGradientBackground` | `NovaGradientBackground` |
| `DrawerParticleBackground` | `NovaParticleBackground` |
| `ResponsiveUtils` | `NovaResponsiveUtils` |
| `AccessibilityUtils` | `NovaAccessibilityUtils` |
| `DeviceType` | `NovaDeviceType` |

Old names still compile but produce deprecation warnings:

```dart
// ⚠️ Shows deprecation warning — will be removed in v2
final c = AdvancedDrawerController();

// ✅ Correct
final c = NovaDrawerController();
```

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

