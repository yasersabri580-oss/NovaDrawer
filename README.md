# AdvancedAppDrawer

A **modern, fully dynamic, and highly responsive** app drawer component for Flutter. Supports **mobile, tablet, and desktop** with 10+ animation types, nested menus, RTL support, theming, accessibility, and much more.

---

## ✨ Features

### Core
- **Fully responsive** layout that adapts seamlessly across mobile, tablet, and desktop
- **LTR and RTL** language support
- **Expandable and collapsible sections** with smooth transitions
- **Nested menu items** with animated expansion (multi-level)
- Dynamic width adjustment depending on screen size

### Animations (10+ types)
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

All animations are smooth and performant. Developers can customize **duration, curve, and style**.

### Customizability
- Themeable colors, text styles, icons, shadows, and borders
- Inject **custom widgets** inside drawer sections
- **Gesture controls** (swipe to open/close)
- **Pin drawer** open on desktop/tablet
- Light and dark theme support

### Advanced Features
- **Dynamic data loading** (menu items fetched from API)
- **Active route highlighting**
- Built-in **accessibility support** (screen readers, focus order, scalable fonts)
- **Mini-drawer mode** for tablet/desktop
- **Custom backgrounds** (animated gradient, particle effects)
- **Auto-hide on scroll** support

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
final controller = AdvancedDrawerController(
  initialSelectedItemId: 'home',
);
```

### 3. Define your menu structure

```dart
final sections = [
  DrawerSectionData(
    id: 'main',
    title: 'Navigation',
    items: [
      DrawerItem(
        id: 'home',
        title: 'Home',
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        route: '/home',
      ),
      DrawerItem(
        id: 'dashboard',
        title: 'Dashboard',
        icon: Icons.dashboard_outlined,
        badge: DrawerItemBadge(count: 3),
      ),
      DrawerItem(
        id: 'settings',
        title: 'Settings',
        icon: Icons.settings_outlined,
        children: [
          DrawerItem(id: 'account', title: 'Account', icon: Icons.person),
          DrawerItem(id: 'privacy', title: 'Privacy', icon: Icons.lock),
        ],
      ),
    ],
  ),
];
```

### 4. Build the drawer

```dart
DrawerScaffoldWidget(
  controller: controller,
  drawer: AdvancedAppDrawer(
    controller: controller,
    sections: sections,
    header: DrawerHeaderWidget(
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

## 🎨 Theming

### Light/Dark themes

```dart
AdvancedAppDrawer(
  theme: AdvancedDrawerTheme.light(), // or .dark()
  // ...
)
```

### Custom theme

```dart
AdvancedAppDrawer(
  theme: AdvancedDrawerTheme(
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
DrawerConfig(
  animationType: DrawerAnimationType.elastic,
  animationConfig: DrawerAnimationConfig(
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
DrawerAnimationConfig(
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
DrawerConfig(
  breakpoints: DrawerBreakpoints(
    mobile: 500,
    tablet: 900,
  ),
)
```

### Force a display mode

```dart
DrawerConfig(
  displayMode: DrawerDisplayMode.side, // Always side-by-side
)
```

---

## 🔗 Dynamic Data Loading

```dart
// Load items from API
await controller.loadItems(() async {
  final response = await http.get(Uri.parse('/api/menu'));
  final data = json.decode(response.body) as List;
  return data.map((item) => DrawerItem(
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
DrawerConfig(
  accessibilityConfig: DrawerAccessibilityConfig(
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
DrawerConfig(
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
DrawerConfig(
  gestureConfig: DrawerGestureConfig(
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
DrawerHeaderWidget(
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
AdvancedAppDrawer(
  enableGradientBackground: true,
  gradientColors: [Colors.blue.shade900, Colors.purple.shade900],
)
```

### Particle effects

```dart
AdvancedAppDrawer(
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
  child: DrawerScaffoldWidget(/* ... */),
)
```

---

## 📁 Package Structure

```
lib/
  main.dart                          # Barrel export file
  src/
    models/
      drawer_item.dart               # DrawerItem, DrawerSectionData, Badge
      drawer_theme.dart              # AdvancedDrawerTheme
      drawer_config.dart             # DrawerConfig, enums, sub-configs
    controllers/
      drawer_controller.dart         # AdvancedDrawerController
    widgets/
      advanced_app_drawer.dart       # Main drawer widget
      drawer_header.dart             # Header widget
      drawer_item_widget.dart        # Individual item widget
      drawer_section.dart            # Collapsible section widget
      nested_menu_item.dart          # Nested expandable items
      mini_drawer.dart               # Mini/collapsed drawer
      drawer_scaffold.dart           # Responsive scaffold
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
    utils/
      responsive_utils.dart          # Responsive breakpoints
      accessibility_utils.dart       # Accessibility helpers
    backgrounds/
      gradient_background.dart       # Animated gradient
      particle_background.dart       # Particle effects
example/
  lib/
    main.dart                        # Full demo app
test/
  widget_test.dart                   # Comprehensive tests
```

---

## 🔧 API Reference

### AdvancedDrawerController

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

### DrawerItem

| Property | Type | Description |
|----------|------|-------------|
| `id` | `String` | Unique identifier |
| `title` | `String` | Display title |
| `icon` | `IconData?` | Icon |
| `selectedIcon` | `IconData?` | Icon when selected |
| `children` | `List<DrawerItem>` | Nested items |
| `badge` | `DrawerItemBadge?` | Notification badge |
| `route` | `String?` | Route path |
| `subtitle` | `String?` | Subtitle text |
| `onTap` | `VoidCallback?` | Tap callback |

### DrawerAnimationType

`slide` · `fade` · `scale` · `rotate` · `morph` · `elastic` · `spring` · `shimmer` · `blur` · `gradient`

### DrawerDisplayMode

`auto` · `overlay` · `push` · `side` · `mini`

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.
