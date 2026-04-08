# NovaDrawer

A **modern, production-grade, and highly responsive** app drawer system for Flutter. Supports **mobile, tablet, and desktop** with 16+ animation types, 10 header variants, 10 surface styles, content widgets, nested menus, RTL support, theming, accessibility, slot-based builder APIs, and much more.

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

<<<<<<< HEAD

- **DrawerSearchBar** — Animated focus state, clear button
- **DrawerStatsCard** — Row of stat items with dividers
- **DrawerShortcutsGrid** — Tappable shortcut grid with badges
- **DrawerRecentItems** — Recent items list with timestamps
- **DrawerFilterChips** — Horizontally scrollable filter chips
- **DrawerAppStatusWidget** — Connection status and version info
- **DrawerWorkspaceSwitcher** — Expandable workspace/account switcher

### 🎬 Animations (10+ types)

=======

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

### 1. Import the package

```dart
import 'package:nova_drawer/main.dart';
```

### 2. Create a controller

```dart
final controller = NovaDrawerController(
  initialSelectedItemId: 'home',
);
```

### 3. Define your menu structure

```dart
final sections = [
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
        id: 'dashboard',
        title: 'Dashboard',
        icon: Icons.dashboard_outlined,
        badge: NovaDrawerItemBadge(count: 3),
      ),
      NovaDrawerItem(
        id: 'settings',
        title: 'Settings',
        icon: Icons.settings_outlined,
        children: [
          NovaDrawerItem(id: 'account', title: 'Account', icon: Icons.person),
          NovaDrawerItem(id: 'privacy', title: 'Privacy', icon: Icons.lock),
        ],
      ),
    ],
  ),
];
```

### 4. Build the drawer

```dart
NovaDrawerScaffold(
  controller: controller,
  drawer: NovaAppDrawer(
    controller: controller,
    sections: sections,
    header: NovaDrawerHeaderWidget(
      title: 'My App',
      subtitle: 'user@example.com',
      avatar: CircleAvatar(child: Text('U')),
      showPinButton: true,
    ),
    onItemTap: (item) => print('Selected: ${item.title}'),
  ),
  body: YourPageContent(),
  appBar: AppBar(title: Text('My App')),
)
```

---

## 🎭 Header System

### Using the header system

Replace the old `NovaDrawerHeaderWidget` with the new `NovaDrawerHeader`:

```dart
NovaAppDrawer(
  controller: controller,
  sections: sections,
  header: NovaDrawerHeader(
    config: NovaHeaderConfig(
      variant: NovaHeaderVariant.classic,
      profile: NovaHeaderUserProfile(
        name: 'Jane Developer',
        email: 'jane@example.com',
        role: 'Senior Engineer',
        status: NovaUserStatus.online,
        notificationCount: 5,
      ),
      showCloseButton: true,
      showPinButton: true,
      actions: [
        NovaHeaderAction(id: 'settings', icon: Icons.settings, tooltip: 'Settings'),
        NovaHeaderAction(id: 'notifications', icon: Icons.notifications, badge: 3),
      ],
    ),
  ),
)
```

### Switch header variant

Just change the `variant` parameter:

```dart
NovaHeaderConfig(
  variant: NovaHeaderVariant.glassmorphism, // or hero, compact, collapsible, etc.
  profile: myProfile,
)
```

### Account switcher with avatar stack

```dart
NovaHeaderConfig(
  variant: NovaHeaderVariant.avatarStack,
  profile: primaryUser,
  accounts: [
    NovaHeaderUserProfile(name: 'Alice', status: NovaUserStatus.online),
    NovaHeaderUserProfile(name: 'Bob', status: NovaUserStatus.busy),
  ],
  onSwitchAccount: () => showAccountPicker(),
)
```

### Custom header builder

```dart
NovaHeaderConfig(
  customHeaderBuilder: (context, config) {
    return MyCustomHeader(profile: config.profile);
  },
)
```

---

## 🏗️ Surface Styles

Wrap your drawer content with a surface style:

```dart
NovaDrawerSurface(
  config: NovaDrawerSurfaceConfig(
    style: NovaDrawerSurfaceStyle.glassmorphism,
    blurSigma: 15.0,
    opacity: 0.8,
  ),
  child: myDrawerContent,
)
```

---

## 📦 Content Widgets

### Search bar

> **Note:** `NovaDrawerSearchBar` is now powered by the [`search_plus`](https://pub.dev/packages/search_plus) package, providing advanced search capabilities out of the box.

```dart
NovaDrawerSearchBar<String>.simple(
  items: ['Home', 'Settings', 'Profile'],
  searchableFields: (item) => [item],
  toResult: (item) => SearchResult(id: item, title: item, data: item),
  hintText: 'Search menu…',
  onChanged: (query) => filterDrawerItems(query),
)
```

### Stats card

```dart
NovaDrawerStatsCard(
  stats: [
    NovaDrawerStatItem(label: 'Projects', value: '42'),
    NovaDrawerStatItem(label: 'Tasks', value: '128'),
  ],
)
```

### Workspace switcher

```dart
NovaDrawerWorkspaceSwitcher(
  workspaces: [
    NovaDrawerWorkspace(id: '1', name: 'Personal', isActive: true),
    NovaDrawerWorkspace(id: '2', name: 'Work'),
  ],
)
```

---

## 🔌 Builder APIs

Customize every component with builder callbacks:

```dart
NovaDrawerBuilders(
  headerBuilder: (context, config) => MyCustomHeader(config: config),
  itemBuilder: (context, item, isSelected) => MyCustomItem(item: item),
  footerBuilder: (context) => MyCustomFooter(),
  loadingBuilder: (context) => MyCustomLoader(),
  errorBuilder: (context, msg, retry) => MyErrorWidget(msg, retry),
  emptyStateBuilder: (context) => MyEmptyState(),
)
```

---

## 🎨 Theming

### Light/Dark themes

```dart
NovaAppDrawer(
  theme: NovaDrawerTheme.light(), // or .dark()
  // ...
)
```

### Custom theme

```dart
NovaAppDrawer(
  theme: NovaDrawerTheme(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.indigo,
    selectedItemBackgroundColor: Colors.indigo.withOpacity(0.1),
    elevation: 4.0,
    itemBorderRadius: BorderRadius.circular(12),
    headerBackgroundColor: Colors.indigo,
    headerTextColor: Colors.white,
  ),
  // ...
)
```

---

## 🎬 Animations

### Change animation type

```dart
NovaDrawerConfig(
  animationType: NovaDrawerAnimationType.elastic,
  animationConfig: NovaDrawerAnimationConfig(
    duration: Duration(milliseconds: 400),
    curve: Curves.easeOutBack,
    springDamping: 0.7,
    springStiffness: 200,
    elasticPeriod: 0.4,
  ),
)
```

### Staggered item animations

```dart
NovaDrawerAnimationConfig(
  enableStaggeredAnimations: true,
  itemStaggerDelay: Duration(milliseconds: 50),
)
```

---

## 📱 Responsive Behavior

The drawer automatically adapts based on screen size:

| Device | Breakpoint | Default Mode |
|--------|-----------|--------------|
| Mobile | < 600px | Overlay (slides over content) |
| Tablet | 600-1024px | Push (pushes content aside) |
| Desktop | > 1024px | Side (persistent alongside content) |

### Custom breakpoints

```dart
NovaDrawerConfig(
  breakpoints: NovaDrawerBreakpoints(
    mobile: 500,
    tablet: 900,
  ),
)
```

### Force a display mode

```dart
NovaDrawerConfig(
  displayMode: NovaDrawerDisplayMode.side, // Always side-by-side
)
```

---

## 🔗 Dynamic Data Loading

```dart
// Load items from API
await controller.loadItems(() async {
  final response = await http.get(Uri.parse('/api/menu'));
  final data = json.decode(response.body) as List;
  return data.map((item) => NovaDrawerItem(
    id: item['id'],
    title: item['title'],
    icon: iconFromString(item['icon']),
  )).toList();
});
```

The drawer automatically shows a shimmer loading state while fetching data.

---

## ♿ Accessibility

Built-in accessibility features:

- **Semantic labels** for screen readers
- **Focus traversal** for keyboard navigation
- **Scalable text** respecting system settings
- **Minimum touch targets** (48px)
- **Announcements** on drawer open/close

```dart
NovaDrawerConfig(
  accessibilityConfig: NovaDrawerAccessibilityConfig(
    enableSemantics: true,
    enableFocusTraversal: true,
    enableScalableText: true,
    minimumTouchTarget: 48.0,
    drawerLabel: 'Main navigation',
  ),
)
```

---

## 📐 Mini-Drawer Mode

On tablet/desktop, the drawer can collapse to a mini icon-only view:

```dart
NovaDrawerConfig(
  showMiniOnCollapse: true,
  enableHoverExpand: true, // Expand on mouse hover
  hoverExpandDelay: Duration(milliseconds: 500),
)
```

```dart
// Programmatic control
controller.toMini();    // Collapse to mini
controller.fromMini();  // Expand from mini
controller.toggleMini();
```

---

## 👆 Gesture Controls

```dart
NovaDrawerConfig(
  gestureConfig: NovaDrawerGestureConfig(
    enableSwipeToOpen: true,
    enableSwipeToClose: true,
    swipeEdgeWidth: 20.0,
    swipeSensitivity: 0.5,
  ),
)
```

---

## 📌 Pinning

Pin the drawer open on tablet/desktop:

```dart
// In header
NovaDrawerHeaderWidget(
  showPinButton: true,
)

// Programmatic
controller.pin();
controller.unpin();
controller.togglePin();
```

---

## 🎆 Background Effects

### Animated gradient

```dart
NovaAppDrawer(
  enableGradientBackground: true,
  gradientColors: [Colors.blue.shade900, Colors.purple.shade900],
)
```

### Particle effects

```dart
NovaAppDrawer(
  enableParticleBackground: true,
  particleColor: Colors.white,
  particleCount: 20,
)
```

---

## 🌐 RTL Support

RTL is automatically detected from `Directionality`. You can also wrap with:

```dart
Directionality(
  textDirection: TextDirection.rtl,
  child: NovaDrawerScaffold(/* ... */),
)
```

---

## 📁 Package Structure

```
lib/
  main.dart                          # Barrel export file
  src/
    models/
      drawer_item.dart               # NovaDrawerItem, NovaDrawerSectionData, Badge
      drawer_theme.dart              # NovaDrawerTheme
      drawer_config.dart             # NovaDrawerConfig, enums, sub-configs
      header_config.dart             # NovaHeaderConfig, NovaHeaderUserProfile, NovaHeaderAction
      surface_config.dart            # NovaDrawerSurfaceConfig, NovaDrawerSurface widget
      content_config.dart            # Content models (stats, shortcuts, etc.)
    controllers/
      drawer_controller.dart         # NovaDrawerController
    headers/
      nova_drawer_header.dart        # Main header router widgets
      header_utils.dart              # Shared header utilities
      profile_header_classic.dart    # Classic variant
      profile_header_glassmorphism.dart # Glassmorphism variant
      profile_header_compact.dart    # Compact variant
      profile_header_hero.dart       # Hero variant
      profile_header_expanded.dart   # Expanded variant
      profile_header_animated_gradient.dart # Animated gradient variant
      profile_header_avatar_stack.dart # Avatar stack variant
      profile_header_multi_action.dart # Multi-action variant
      profile_header_status_aware.dart # Status-aware variant
      profile_header_collapsible.dart # Collapsible variant
    builders/
      drawer_builders.dart           # Slot-based builder callbacks
    widgets/
      advanced_app_drawer.dart       # Main drawer widget (NovaAppDrawer)
      drawer_header.dart             # Legacy header widget (NovaDrawerHeaderWidget)
      drawer_item_widget.dart        # Individual item widget
      drawer_section.dart            # Collapsible section widget
      nested_menu_item.dart          # Nested expandable items (NovaNestedMenuItem)
      mini_drawer.dart               # Mini/collapsed drawer (NovaMiniDrawer)
      drawer_scaffold.dart           # Responsive scaffold (NovaDrawerScaffold)
      drawer_search_bar.dart         # Search bar powered by search_plus (NovaDrawerSearchBar)
      drawer_stats_card.dart         # User stats card (NovaDrawerStatsCard)
      drawer_shortcuts_grid.dart     # Shortcuts grid (NovaDrawerShortcutsGrid)
      drawer_recent_items.dart       # Recent items list (NovaDrawerRecentItems)
      drawer_filter_chips.dart       # Filter chips row (NovaDrawerFilterChipsWidget)
      drawer_app_status.dart         # App status footer (NovaDrawerAppStatusWidget)
      drawer_workspace_switcher.dart # Workspace/account switcher (NovaDrawerWorkspaceSwitcher)
    animations/
      animation_config.dart          # Animation configuration
      animation_wrapper.dart         # Unified animation wrapper
      slide_animation.dart           # Slide transitions
      fade_animation.dart            # Fade transitions
      scale_animation.dart           # Scale transitions
      rotate_animation.dart          # Rotation transitions
      morph_animation.dart           # Shape morphing
      elastic_animation.dart         # Elastic bounce
      spring_animation.dart          # Spring physics
      shimmer_animation.dart         # Shimmer effect
      blur_animation.dart            # Blur transitions
      gradient_animation.dart        # Gradient transitions
      floating_animation.dart        # Floating overlay
      floating_bounce_animation.dart # Floating bounce
      floating_reveal_animation.dart # Floating reveal
      wave_animation.dart            # Wave distortion
      parallax_animation.dart        # Parallax depth
      curtain_animation.dart         # Curtain open/close
    utils/
      responsive_utils.dart          # Responsive breakpoints (NovaResponsiveUtils)
      accessibility_utils.dart       # Accessibility helpers (NovaAccessibilityUtils)
    backgrounds/
      gradient_background.dart       # Animated gradient (NovaGradientBackground)
      particle_background.dart       # Particle effects (NovaParticleBackground)
    deprecated_aliases.dart          # Backward-compatible typedefs for old names
example/
  lib/
    main.dart                        # Full demo app
    screens/
      header_showcase_screen.dart    # All 10 header variants
      surface_showcase_screen.dart   # All 10 surface styles
      content_showcase_screen.dart   # Content widgets demo
      animation_showcase_screen.dart # Animation types demo
test/
  widget_test.dart                   # Comprehensive tests
```

---

## 🔧 API Reference

### NovaDrawerController

| Method | Description |
|--------|-------------|
| `open()` | Opens the drawer |
| `close()` | Closes the drawer |
| `toggle()` | Toggles open/close |
| `pin()` / `unpin()` | Pin/unpin drawer |
| `toMini()` / `fromMini()` | Mini mode control |
| `selectItem(id)` | Select an item |
| `selectByRoute(path)` | Select by route path |
| `expandItem(id)` | Expand nested item |
| `collapseItem(id)` | Collapse nested item |
| `loadItems(loader)` | Dynamic data loading |
| `disableItem(id)` | Disable an item |
| `hideItem(id)` | Hide an item |

### NovaHeaderConfig

| Property | Type | Description |
|----------|------|-------------|
| `variant` | `NovaHeaderVariant` | Header visual style |
| `profile` | `NovaHeaderUserProfile?` | User profile data |
| `actions` | `List<NovaHeaderAction>` | Action buttons |
| `showCloseButton` | `bool` | Show close button |
| `showPinButton` | `bool` | Show pin button |
| `isLoading` | `bool` | Show skeleton |
| `isCollapsed` | `bool` | Collapsed state |
| `accounts` | `List<NovaHeaderUserProfile>` | For avatar stack |
| `customHeaderBuilder` | `Function?` | Custom header |

### NovaHeaderVariant

`classic` · `glassmorphism` · `compact` · `hero` · `expanded` · `animatedGradient` · `avatarStack` · `multiAction` · `statusAware` · `collapsible`

### NovaDrawerSurfaceStyle

`plain` · `elevated` · `glassmorphism` · `blurred` · `gradient` · `premiumShadow` · `outlinedMinimal` · `neumorphic` · `imageBacked` · `animatedMeshGradient`

### NovaDrawerItem

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier |
| `title` | `String` | Display title |
| `icon` | `IconData?` | Icon |
| `selectedIcon` | `IconData?` | Icon when selected |
| `children` | `List<NovaDrawerItem>` | Nested items |
| `badge` | `NovaDrawerItemBadge?` | Notification badge |
| `route` | `String?` | Route path |
| `subtitle` | `String?` | Subtitle text |
| `onTap` | `VoidCallback?` | Tap callback |

### NovaDrawerAnimationType

`slide` · `fade` · `scale` · `rotate` · `morph` · `elastic` · `spring` · `shimmer` · `blur` · `gradient` · `floating` · `floatingBounce` · `floatingReveal` · `wave` · `parallax` · `curtain`

### NovaDrawerDisplayMode

`auto` · `overlay` · `push` · `side` · `mini`

---

## 🔄 Migration Guide

All public APIs have been renamed from the old `Drawer*` / `Advanced*` prefix convention to the new unified `Nova*` prefix. The old names are still available as **deprecated typedefs** in `deprecated_aliases.dart` for backward compatibility, but will be removed in a future release.

### Naming changes

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
| `DrawerSearchBar` | `NovaDrawerSearchBar` |
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

### Using deprecated aliases

If you are migrating from an older version, the old names still work thanks to `deprecated_aliases.dart`. Simply import the package as usual and you will see deprecation warnings guiding you to the new names:

```dart
// Old code still compiles but shows deprecation warnings
final controller = AdvancedDrawerController(); // ⚠️ Deprecated — use NovaDrawerController

// Updated code
final controller = NovaDrawerController();
```

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
