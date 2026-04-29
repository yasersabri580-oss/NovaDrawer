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

## Overview

NovaDrawer is a complete **drawer navigation system** — not just a styled container. It ships as a full system comprising a state controller, responsive layout management, 10 header variants, 10 surface styles, 16 animation types, and a set of in-drawer content widgets (workspace switcher, shortcuts grid, stats card, recent items, filter chips, and app status bar).

Think of it as a drop-in replacement for Flutter's built-in `Drawer` that automatically handles:

- **Responsive layout switching** — overlay on mobile, push on tablet, persistent sidebar on desktop, with mini/icon-only mode in between
- **Drawer state management** — open/close, pinned, mini, selection, loading, error — all in one controller object
- **Header theming** — 10 ready-made profile header layouts that go far beyond a simple user tile
- **In-drawer UI blocks** — workspace switcher, quick-action grid, stats card, recents list, filter chips, and app status bar as plug-in widgets

**Quick orientation map:**

| If you want to... | Use... |
|---|---|
| Drop a drawer into a `Scaffold` | `NovaAppDrawer` |
| Get auto-responsive layout management | `NovaDrawerScaffold` |
| Control drawer state from code | `NovaDrawerController` |
| Define menu items | `NovaDrawerItem`, `NovaDrawerSectionData` |
| Interleave items and sections in any order | `NovaAppDrawer.entries` with `NovaDrawerItemEntry` / `NovaDrawerSectionEntry` |
| Customize the header | `NovaDrawerHeader` + `NovaHeaderConfig` |
| Simple custom header without variants | `NovaDrawerHeaderWidget` |
| Collapse to icons-only on desktop | `NovaMiniDrawer` |
| Render a workspace/org switcher | `NovaDrawerWorkspaceSwitcher` |
| Render a quick-actions grid | `NovaDrawerShortcutsGrid` |
| Show user stats inside the drawer | `NovaDrawerStatsCard` |
| Show recently opened items | `NovaDrawerRecentItems` |
| Show filter chip tabs inside the drawer | `NovaDrawerFilterChipsWidget` |
| Show connectivity/version in the drawer footer | `NovaDrawerAppStatusWidget` |
| Control the drawer's visual surface style | `NovaDrawerSurface` + `NovaDrawerSurfaceConfig` |
| Swap all rendering with your own widgets | `NovaDrawerBuilders` |

---

## Installation

```yaml
dependencies:
  nova_drawer: ^1.0.8
```

```dart
import 'package:nova_drawer/nova_drawer.dart';
```

---

## Table of Contents

- [NovaDrawerScaffold](#novadrawerscaffold)
- [NovaAppDrawer](#novaappdrawer)
- [NovaDrawerController](#novadrawercontroller)
- [NovaDrawerItem](#novadraweritem)
- [NovaDrawerSectionData](#novadrawersectiondata)
- [NovaDrawerEntry](#novadrawerentry)
- [NovaDrawerHeaderWidget](#novadrawerheaderwidget)
- [NovaDrawerHeader (Variant System)](#novadrawerheader-variant-system)
  - [NovaProfileHeaderClassic](#novaprofileheaderclassic)
  - [NovaProfileHeaderGlassmorphism](#novaprofileheaderglassmorphism)
  - [NovaProfileHeaderCompact](#novaprofileheadercompact)
  - [NovaProfileHeaderHero](#novaprofileheaderhero)
  - [NovaProfileHeaderExpanded](#novaprofileheaderexpanded)
  - [NovaProfileHeaderAnimatedGradient](#novaprofileheaderanimatedgradient)
  - [NovaProfileHeaderAvatarStack](#novaprofileheaderavatarstack)
  - [NovaProfileHeaderMultiAction](#novaprofileheadermultiaction)
  - [NovaProfileHeaderStatusAware](#novaprofileheaderstatusaware)
  - [NovaProfileHeaderCollapsible](#novaprofileheadercollapsible)
- [NovaMiniDrawer](#novaminidrawer)
- [NovaDrawerSectionWidget](#novadrawersectionwidget)
- [NovaNestedMenuItem](#novanestedmenuitem)
- [NovaDrawerItemWidget](#novadraweritemwidget)
- [NovaDrawerWorkspaceSwitcher](#novadrawerworkspaceswitcher)
- [NovaDrawerShortcutsGrid](#novadrawershortcutsgrid)
- [NovaDrawerStatsCard](#novadrawerstatscard)
- [NovaDrawerRecentItems](#novadrawerrecentitems)
- [NovaDrawerFilterChipsWidget](#novadrawerfilterchipswidget)
- [NovaDrawerAppStatusWidget](#novadrawerappstatuswidget)
- [NovaDrawerSurface](#novadrawersurface)
- [NovaDrawerBuilders](#novadrawerbuilders)
- [Configuration Objects](#configuration-objects)
  - [NovaDrawerConfig](#novadrawerconfig)
  - [NovaDrawerTheme](#novadrawertheme)
  - [NovaDrawerAnimationConfig](#novadraweranimationconfig)
  - [NovaHeaderConfig](#novaheaderconfig)
- [Config Priority: NovaDrawerScaffold vs NovaAppDrawer](#config-priority-novadrawerscaffold-vs-novaappdrawer)
- [Particles](#particles)
- [Animations](#animations)
- [Migration Guide](#migration-guide)

---

## NovaDrawerScaffold

### What it actually is

A **responsive layout orchestrator** for your entire app screen. It is the top-level host widget that decides *how* the drawer appears based on screen size — sliding overlay on mobile, content-pushing panel on tablet, or a persistent sidebar on desktop — and switches between those modes automatically when the window resizes.

### Problem it solves

Writing responsive drawer behavior by hand means tracking screen size breakpoints, switching between `Scaffold.drawer` and a custom `Row` layout, and syncing animations manually. `NovaDrawerScaffold` encapsulates all of that. You declare the drawer once; it handles the rest.

### When to use it

**Use when:** You want the drawer to automatically adapt its layout mode across screen sizes without writing any responsive logic yourself.

**Avoid when:** You need a fully custom layout where the drawer position is non-standard (e.g., a bottom sheet pattern). In that case, use `NovaAppDrawer` directly inside your own layout.

### Mental model

Think of `NovaDrawerScaffold` as a smarter `Scaffold`. Drop it in place of `Scaffold`, give it a `drawer` and a `body`, and the layout decisions are handled for you.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `controller` | `NovaDrawerController` | Required. The shared state object that connects the scaffold to the drawer. |
| `drawer` | `NovaAppDrawer` | Required. The full-width drawer widget rendered in expanded mode. |
| `body` | `Widget` | Required. The main page content. |
| `config` | `NovaDrawerConfig` | Controls breakpoints, display mode, pinning, overlay opacity, gestures, etc. |
| `appBar` | `PreferredSizeWidget?` | Standard app bar wired into the scaffold. |
| `miniDrawerItems` / `miniDrawerSections` | `List?` | Items shown in mini mode; defaults to the full drawer's items. |
| `miniDrawerHeader` / `miniDrawerFooter` | `Widget?` | Optional header/footer for the mini drawer. |
| `onItemTap` | `void Function(NovaDrawerItem)?` | Central tap handler wired to both full and mini drawer. Falls back to `NovaAppDrawer.onItemTap` if not set. |
| `onMiniDrawerExpandRequest` | `VoidCallback?` | Called when the mini drawer's expand button is tapped or hover-expand fires. Overrides the default `controller.open()`. |

### Display modes (set via `NovaDrawerConfig.displayMode`)

| Mode | Behaviour |
|---|---|
| `auto` | Default. Overlay on mobile, push on tablet, side on desktop. |
| `overlay` | Drawer slides over content with a scrim behind it. |
| `push` | Drawer pushes content horizontally to the side. |
| `side` | Drawer sits statically alongside content (no animation). |
| `mini` | Always shows the collapsed icon rail; expands on tap. |

### Example

```dart
final controller = NovaDrawerController(initialSelectedItemId: 'home');

@override
Widget build(BuildContext context) {
  return NovaDrawerScaffold(
    controller: controller,
    config: const NovaDrawerConfig(
      displayMode: NovaDrawerDisplayMode.auto, // switches per screen size
      isPinnedByDefault: false,
    ),
    drawer: NovaAppDrawer(
      controller: controller,
      sections: myNavSections,
      header: NovaDrawerHeader(
        config: NovaHeaderConfig(
          variant: NovaHeaderVariant.classic,
          profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
        ),
      ),
      onItemTap: (item) => Navigator.pushNamed(context, item.route ?? '/'),
    ),
    appBar: AppBar(
      title: const Text('My App'),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: controller.toggle,
      ),
    ),
    body: const MyPageContent(),
  );
}
```

What is happening: The scaffold reads the current screen width, resolves the display mode (overlay / push / side), and wires the controller's `open()` / `close()` calls to the correct mechanism — `Scaffold.openDrawer()` on mobile, or an animated `Row` with `AnimatedContainer` on tablet/desktop.

---

## NovaAppDrawer

### What it actually is

The **main drawer widget**. It assembles the full drawer experience — header, scrollable item list, footer, background effects, entrance animation, loading skeleton, and error state — into a single `StatefulWidget` you drop into a `Scaffold.drawer` or hand to `NovaDrawerScaffold`.

### Problem it solves

Flutter's built-in `Drawer` is just a `Material` widget with no built-in state, no animation system, no responsive width, and no loading/error states. `NovaAppDrawer` fills all those gaps. You give it items and a controller; it handles the rest.

### When to use it

**Use when:** You are building a navigation drawer and want to use `NovaDrawerScaffold` or use it directly as `Scaffold.drawer`.

**Avoid when:** You only need a simple list with no theming, animation, or responsive requirements. In that case, the overhead is unnecessary.

### Mental model

Think of `NovaAppDrawer` as the drawer's *view layer*, and `NovaDrawerController` as its *state layer*. They are separate deliberately so you can control the drawer from anywhere in your widget tree.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `controller` | `NovaDrawerController` | Required. Connects the drawer to shared open/close/selection state. |
| `entries` | `List<NovaDrawerEntry>` | Ordered mix of items and sections. When non-empty, takes precedence over `sections` and `items`. Use `NovaDrawerItemEntry` or `NovaDrawerSectionEntry`. |
| `sections` | `List<NovaDrawerSectionData>` | Grouped navigation structure (preferred when you have section headers). |
| `items` | `List<NovaDrawerItem>` | Flat list of items (used when no sections are provided). |
| `header` | `Widget?` | Any widget placed at the top of the drawer — typically a `NovaDrawerHeader`. |
| `footer` | `Widget?` | Any widget pinned to the bottom — typically an `NovaDrawerAppStatusWidget`. |
| `onItemTap` | `void Function(NovaDrawerItem)?` | Called when any item is tapped. Use for navigation. |
| `theme` | `NovaDrawerTheme?` | Visual overrides for colors, text styles, dimensions. |
| `config` | `NovaDrawerConfig` | Behavior: animation type, gesture config, accessibility, etc. |
| `width` | `double?` | Override the responsive width calculation. |
| `backgroundWidget` | `Widget?` | Custom widget rendered behind all content. |
| `enableGradientBackground` | `bool` | Enables the animated gradient background layer. |
| `gradientColors` | `List<Color>?` | Colors for the gradient background. |
| `enableParticleBackground` | `bool` | Enables the floating particle effect background. |
| `particleColor` | `Color?` | Color of particles. |
| `particleCount` | `int` | Number of particles (default: 20). |

### Example

```dart
NovaAppDrawer(
  controller: controller,
  sections: [
    NovaDrawerSectionData(
      id: 'main',
      title: 'Main Navigation',
      items: [
        NovaDrawerItem(id: 'home', title: 'Home', icon: Icons.home_outlined, selectedIcon: Icons.home, route: '/home'),
        NovaDrawerItem(id: 'explore', title: 'Explore', icon: Icons.explore_outlined, route: '/explore'),
        NovaDrawerItem(
          id: 'settings',
          title: 'Settings',
          icon: Icons.settings_outlined,
          children: [
            NovaDrawerItem(id: 'account', title: 'Account', icon: Icons.person_outline),
            NovaDrawerItem(id: 'privacy', title: 'Privacy', icon: Icons.lock_outline),
          ],
        ),
      ],
    ),
  ],
  header: NovaDrawerHeader(
    config: NovaHeaderConfig(
      variant: NovaHeaderVariant.classic,
      profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
    ),
  ),
  footer: NovaDrawerAppStatusWidget(
    status: NovaDrawerAppStatus(isOnline: true, version: '2.1.0'),
  ),
  onItemTap: (item) => Navigator.pushNamed(context, item.route ?? '/'),
  config: const NovaDrawerConfig(
    animationType: NovaDrawerAnimationType.slide,
    closeOnItemTap: true,
  ),
  enableGradientBackground: false,
)
```

The drawer assembles header → scrollable sections/items → footer. If `controller.isLoading` is `true`, it shows a shimmer skeleton instead of items. If `controller.errorMessage` is set, it shows an error UI with a Retry button. The entrance animation plays once on mount.

---

## NovaDrawerController

### What it actually is

A **`ChangeNotifier`-based state machine** for the drawer. It owns the open/close state, pinned state, mini mode, currently selected item, expanded sections, expanded nested items, hidden/disabled items, and data loading state.

### Problem it solves

Without a controller, you would need `GlobalKey<ScaffoldState>` to open a drawer, scattered `setState` calls to track selection, and no shared state between the drawer and your AppBar hamburger button. `NovaDrawerController` centralises all of that and can be accessed anywhere via `NovaDrawerControllerProvider.of(context)`.

### When to use it

**Always.** `NovaAppDrawer` and `NovaDrawerScaffold` both require it. Create it in `initState` or with a state management solution you prefer, and dispose it in `dispose`.

### Mental model

Think of `NovaDrawerController` as the drawer's ViewModel. The drawer observes it; your app code mutates it. They never need to reference each other directly.

### Key API

```dart
// Lifecycle
controller.open();            // opens the drawer
controller.close();           // closes (no-op if pinned)
controller.toggle();          // flip open/close
controller.pin();             // lock open on tablet/desktop
controller.unpin();
controller.togglePin();

// Mini mode
controller.toMini();          // collapse to icon rail
controller.fromMini();        // expand back to full
controller.toggleMini();

// Selection
controller.selectItem('home');
controller.clearSelection();
controller.selectByRoute('/home'); // auto-selects matching item, expands parents

// Section collapse
controller.expandSection('main');
controller.collapseSection('main');
controller.toggleSection('main');

// Nested item expand
controller.expandItem('settings');
controller.collapseItem('settings');

// Visibility / enable
controller.hideItem('beta-feature');
controller.showItem('beta-feature');
controller.disableItem('locked-item');
controller.enableItem('locked-item');

// Dynamic data loading
await controller.loadItems(() async {
  return await myApi.fetchNavItems();
});
await controller.loadSections(() async {
  return await myApi.fetchNavSections();
});

// Read state
controller.isOpen;
controller.isPinned;
controller.isMini;
controller.selectedItemId;
controller.isLoading;
controller.errorMessage;
controller.deviceType; // NovaDeviceType.mobile / tablet / desktop
```

### Example

```dart
class _MyPageState extends State<MyPage> {
  late final NovaDrawerController _drawerController;

  @override
  void initState() {
    super.initState();
    _drawerController = NovaDrawerController(
      initialSelectedItemId: 'home',
      initiallyOpen: false,
    );
    // Load menu items from your backend
    _drawerController.loadSections(() => myApi.fetchNav());
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NovaDrawerScaffold(
      controller: _drawerController,
      // ...
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: _drawerController.toggle, // works from anywhere
        ),
      ),
    );
  }
}
```

---

## NovaDrawerItem

### What it actually is

The **data model for a single navigation entry**. It is a pure data class — no rendering logic. It describes everything about one menu item: its icon, title, children (for nesting), badge, tap callback, visibility, enabled state, and arbitrary metadata.

### Problem it solves

Avoids the need to mix navigation logic into widget trees. Items are defined as immutable data, passed into the drawer, and rendered by `NovaDrawerItemWidget`. The controller tracks which item is selected by `id`, not by widget reference.

### When to use it

Every time you need a menu entry. Use `children` for any item that should expand into sub-items. Use `badge` for notification counts or status labels.

### Mental model

Think of `NovaDrawerItem` as a serialisable nav config object, not a widget. The same item data can be shared between the full drawer and the mini drawer without duplication.

### Key Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `id` | `String` | **Required.** Unique identifier used by the controller to track selection/expansion. |
| `title` | `String` | **Required.** Display text. |
| `icon` | `IconData?` | Icon shown in normal/unselected state. |
| `selectedIcon` | `IconData?` | Icon shown when selected. Falls back to `icon` if not set. |
| `children` | `List<NovaDrawerItem>` | Child items — makes this item an expandable parent. |
| `onTap` | `VoidCallback?` | Direct tap callback. Also fires via `NovaAppDrawer.onItemTap`. |
| `badge` | `NovaDrawerItemBadge?` | Badge with count, label, or custom widget. |
| `route` | `String?` | Route path used by `controller.selectByRoute()` for auto-highlighting. |
| `isEnabled` | `bool` | When `false`, item is rendered dimmed and not tappable. |
| `isVisible` | `bool` | When `false`, item is not rendered at all. |
| `subtitle` | `String?` | Secondary text under the title. |
| `leading` | `Widget?` | Custom leading widget (overrides `icon`). |
| `trailing` | `Widget?` | Custom trailing widget (overrides expand chevron). |
| `customWidget` | `Widget?` | Completely replaces the default item layout with your own widget. |
| `metadata` | `Map<String, dynamic>?` | Arbitrary data bag — useful for feature flags, analytics, role-based access. |
| `initiallyExpanded` | `bool` | Whether nested children start expanded. |

### Example

```dart
NovaDrawerItem(
  id: 'reports',
  title: 'Reports',
  icon: Icons.bar_chart_outlined,
  selectedIcon: Icons.bar_chart,
  route: '/reports',
  badge: const NovaDrawerItemBadge(count: 3),
  children: [
    NovaDrawerItem(id: 'weekly', title: 'Weekly', icon: Icons.calendar_view_week),
    NovaDrawerItem(id: 'monthly', title: 'Monthly', icon: Icons.calendar_month),
    NovaDrawerItem(
      id: 'annual',
      title: 'Annual',
      icon: Icons.calendar_today,
      isEnabled: false, // greyed out — user lacks permission
    ),
  ],
)
```

---

## NovaDrawerSectionData

### What it actually is

A **collapsible group of `NovaDrawerItem`s**. Sections add a labelled header above a set of related items, with optional collapse/expand behaviour. They are the recommended way to organise drawers that contain more than ~5 items.

### Problem it solves

Large flat item lists are hard to scan. Sections add structure and allow users to collapse less-used groups to reduce visual clutter.

### When to use it

**Use when:** You have logically distinct groups (e.g., "Main", "Admin", "Account"). 

**Avoid when:** You only have 3–5 items total — a flat list via `NovaAppDrawer.items` is simpler.

### Mental model

Think of `NovaDrawerSectionData` as a `ExpansionPanelList` entry, but integrated into the drawer's controller-driven state machine. Section collapse state is tracked in `NovaDrawerController._expandedSections`, not in widget-local state.

### Key Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `id` | `String` | **Required.** Unique identifier for controller state tracking. |
| `items` | `List<NovaDrawerItem>` | **Required.** Items in this section. |
| `title` | `String?` | Label shown above the items (rendered uppercase). |
| `isCollapsible` | `bool` | Whether tapping the header collapses items. Default `true`. |
| `initiallyExpanded` | `bool` | Whether the section starts expanded. Default `true`. |
| `headerWidget` | `Widget?` | Replaces the default text header with a custom widget. |
| `footerWidget` | `Widget?` | Widget rendered below all items in the section. |
| `dividerAbove` / `dividerBelow` | `bool` | Whether to render a `Divider` above/below the section. |
| `icon` | `IconData?` | Icon shown next to the section title. |
| `padding` | `EdgeInsetsGeometry?` | Custom padding around the section contents. |

### Example

```dart
NovaDrawerSectionData(
  id: 'admin',
  title: 'Administration',
  icon: Icons.admin_panel_settings,
  isCollapsible: true,
  initiallyExpanded: false, // collapsed by default — power users only
  items: [
    NovaDrawerItem(id: 'users', title: 'Users', icon: Icons.group),
    NovaDrawerItem(id: 'roles', title: 'Roles', icon: Icons.shield_outlined),
    NovaDrawerItem(id: 'audit', title: 'Audit Log', icon: Icons.history),
  ],
)
```

---

## NovaDrawerEntry

### What it actually is

A **sealed base class** with two concrete subtypes that let you express arbitrary ordering of drawer content — interleaving standalone items and full sections in any position.

| Subtype | Wraps | Purpose |
|---|---|---|
| `NovaDrawerItemEntry` | `NovaDrawerItem` | Renders a single item directly in the content area. |
| `NovaDrawerSectionEntry` | `NovaDrawerSectionData` | Renders a full collapsible section group. |

### Problem it solves

Previously `NovaAppDrawer` rendered either a flat `items` list *or* a `sections` list — never both interleaved. With `entries` you can pin items above and below sections, separate admin shortcuts from a navigation group, or place a logout button at the very bottom regardless of section structure.

### When to use it

**Use when:** You need items and sections side-by-side in a specific order (e.g., a top-level "Home" before a collapsible "Tools" group, followed by a "Logout" at the bottom).

**Avoid when:** Your drawer content is uniformly structured as either a flat list or a consistent set of sections — use `items` or `sections` directly for simplicity.

### Mental model

Think of `entries` as a playlist. Each entry is either a standalone track (`NovaDrawerItemEntry`) or an album (`NovaDrawerSectionEntry`). You control the exact order.

### Priority

When `entries` is non-empty it takes full precedence over `sections` and `items`, keeping existing usages backward-compatible.

### Example

```dart
NovaAppDrawer(
  controller: controller,
  entries: [
    NovaDrawerItemEntry(
      NovaDrawerItem(id: 'home', title: 'Home', icon: Icons.home),
    ),
    NovaDrawerItemEntry(
      NovaDrawerItem(id: 'profile', title: 'Profile', icon: Icons.person),
    ),
    NovaDrawerSectionEntry(
      NovaDrawerSectionData(
        id: 'tools',
        title: 'Tools',
        items: [
          NovaDrawerItem(id: 'search',   title: 'Search',   icon: Icons.search),
          NovaDrawerItem(id: 'settings', title: 'Settings', icon: Icons.settings),
          NovaDrawerItem(id: 'help',     title: 'Help',     icon: Icons.help_outline),
        ],
      ),
    ),
    NovaDrawerItemEntry(
      NovaDrawerItem(id: 'logout', title: 'Logout', icon: Icons.logout),
    ),
  ],
)
```

---

## NovaDrawerHeaderWidget

### What it actually is

A **simple, directly composable header widget** for the top of the drawer. It displays a background area, an avatar, a title, and a subtitle in a fixed-height container, with optional close and pin buttons.

### Problem it solves

Not every app needs the full 10-variant header system. `NovaDrawerHeaderWidget` is the lightweight option: set `title`, `subtitle`, and `avatar` and you're done.

### When to use it

**Use when:** You want a simple, one-size-fits-all header without variant selection or `NovaHeaderConfig`.

**Avoid when:** You need glassmorphism, animated gradients, multi-account avatar stacks, collapsible behaviour, or any other advanced layout. Use `NovaDrawerHeader` instead.

### Mental model

Think of it as the drawer's equivalent of `UserAccountsDrawerHeader` from the Material package, but with more customisation hooks and theming integration.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `title` | `String?` | User name or app title. |
| `subtitle` | `String?` | Email, role, or tagline. |
| `avatar` | `Widget?` | Avatar or logo widget (e.g., `CircleAvatar`). |
| `backgroundWidget` | `Widget?` | Widget stacked behind the text content — use for images or gradients. |
| `trailing` | `Widget?` | Widget placed at the trailing edge of the subtitle row. |
| `onTap` | `VoidCallback?` | Makes the whole header tappable — e.g., navigate to profile page. |
| `showCloseButton` | `bool` | Adds a close icon that calls `controller.close()`. |
| `showPinButton` | `bool` | Adds a pin icon that calls `controller.togglePin()`. |
| `height` | `double?` | Override header height (default: 180 from theme). |
| `decoration` | `BoxDecoration?` | Full decoration override. |
| `customWidget` | `Widget?` | Completely replaces default layout. |

### Example

```dart
NovaDrawerHeaderWidget(
  title: 'Alice Johnson',
  subtitle: 'alice@acme.com',
  avatar: const CircleAvatar(
    radius: 28,
    backgroundImage: NetworkImage('https://example.com/alice.jpg'),
  ),
  showCloseButton: true,
  showPinButton: true,
  onTap: () => Navigator.pushNamed(context, '/profile'),
  backgroundWidget: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
)
```

---

## NovaDrawerHeader (Variant System)

### What it actually is

A **header factory widget** that renders one of 10 built-in profile header layouts based on `NovaHeaderConfig.variant`. It is the single entry point for the entire header subsystem. Pass it a `NovaHeaderConfig`, set the variant, and it delegates to the correct implementation.

### Problem it solves

Building a polished, themed drawer header from scratch — with a cover image, avatar, status dot, action buttons, collapse animation, loading skeleton, RTL flip — takes significant work. `NovaDrawerHeader` gives you 10 battle-tested layouts you can switch between with one enum value.

### When to use it

**Use when:** You need any header more sophisticated than avatar + name + email.

**Avoid when:** You have a completely custom header design that shares nothing with these layouts. In that case, write a plain widget and pass it as `NovaAppDrawer.header`.

### Mental model

Think of `NovaDrawerHeader` as a **theme-aware layout engine** for your drawer header. The variants are not separate widgets you compose — they are rendering strategies the engine selects from.

### Core configuration object: `NovaHeaderConfig`

All variants are driven by this single config. Key parameters:

| Parameter | Type | Purpose |
|---|---|---|
| `variant` | `NovaHeaderVariant` | Which layout to render. |
| `profile` | `NovaHeaderUserProfile?` | User data: name, email, role, avatarUrl, coverUrl, status, notificationCount. |
| `actions` | `List<NovaHeaderAction>` | Action buttons rendered in the header (e.g., Settings, Edit). |
| `showCloseButton` | `bool` | Whether to show an X button to close the drawer. |
| `showPinButton` | `bool` | Whether to show a pin button. |
| `showStatusIndicator` | `bool` | Whether to show the online/offline/busy dot. |
| `showNotificationBadge` | `bool` | Whether to show an unread count badge on the avatar. |
| `enableCollapseExpand` | `bool` | Whether the header supports toggle collapse (for `collapsible` variant). |
| `isLoading` | `bool` | Show a shimmer skeleton instead of real content. |
| `onProfileTap` | `VoidCallback?` | Tap on the profile area. |
| `onEditProfile` | `VoidCallback?` | Tap on edit profile shortcut. |
| `onSwitchAccount` | `VoidCallback?` | Tap on switch account. |
| `accounts` | `List<NovaHeaderUserProfile>` | Additional accounts for avatar stack variant. |
| `gradientColors` | `List<Color>?` | Colors for gradient-based variants. |
| `coverHeight` | `double?` | Height of the cover/banner area. |
| `customHeaderBuilder` | `Widget Function(BuildContext, NovaHeaderConfig)?` | Full override — skips all variants. |

---

### NovaProfileHeaderClassic

**Conceptual role:** Standard profile card — cover image strip with an avatar overlapping the edge, name, and email below.

**Use when:** Most general-purpose apps. This is the safe default.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.classic,
    profile: NovaHeaderUserProfile(
      name: 'Alice Johnson',
      email: 'alice@acme.com',
      role: 'Product Manager',
      avatarUrl: 'https://example.com/alice.jpg',
      coverUrl: 'https://example.com/cover.jpg',
      status: NovaUserStatus.online,
    ),
    showCloseButton: true,
    showStatusIndicator: true,
    onProfileTap: () => Navigator.pushNamed(context, '/profile'),
  ),
)
```

---

### NovaProfileHeaderGlassmorphism

**Conceptual role:** A frosted-glass header where the background blurs through the drawer surface.

**Use when:** Apps with image or gradient drawer backgrounds (`enableGradientBackground: true`) where you want the header to feel visually integrated.

**Avoid when:** Plain solid-color drawer backgrounds — the blur effect has no source image to blur.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.glassmorphism,
    profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
  ),
)
```

---

### NovaProfileHeaderCompact

**Conceptual role:** A single-row header — small avatar + name + subtitle on one line.

**Use when:** Space-constrained drawers, or when the header should be minimal so the navigation items get more vertical space. Good for productivity tools.

**Avoid when:** You need action buttons, a cover image, or a status indicator.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.compact,
    profile: NovaHeaderUserProfile(
      name: 'Alice Johnson',
      email: 'alice@acme.com',
    ),
    showCloseButton: true,
  ),
)
```

---

### NovaProfileHeaderHero

**Conceptual role:** A magazine-style dramatic header — large full-bleed cover image, prominent avatar.

**Use when:** Creative, media, or social apps where visual identity is important.

**Avoid when:** Enterprise/productivity apps where you need to maximise navigation real estate.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.hero,
    profile: NovaHeaderUserProfile(
      name: 'Alice Johnson',
      avatarUrl: 'https://example.com/alice.jpg',
      coverUrl: 'https://example.com/hero-cover.jpg',
    ),
    coverHeight: 160,
  ),
)
```

---

### NovaProfileHeaderExpanded

**Conceptual role:** A rich detail header — shows name, email, role, phone, and action buttons in an expanded layout.

**Use when:** CRM, ERP, or admin apps where seeing the full user context in the drawer matters.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.expanded,
    profile: NovaHeaderUserProfile(
      name: 'Alice Johnson',
      email: 'alice@acme.com',
      role: 'Product Manager',
      phone: '+1 555 0100',
    ),
    actions: [
      NovaHeaderAction(id: 'edit', icon: Icons.edit_outlined, tooltip: 'Edit profile', onTap: () {}),
      NovaHeaderAction(id: 'logout', icon: Icons.logout, tooltip: 'Logout', isDestructive: true, onTap: () {}),
    ],
    showEditProfileButton: true,
  ),
)
```

---

### NovaProfileHeaderAnimatedGradient

**Conceptual role:** A header whose background cycles through a gradient animation — a subtle "living" visual effect.

**Use when:** Onboarding flows, dashboards, or any context where you want the drawer to feel dynamic.

**Avoid when:** Users report motion sensitivity concerns or you have strict performance requirements.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.animatedGradient,
    profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
    gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
  ),
)
```

---

### NovaProfileHeaderAvatarStack

**Conceptual role:** A multi-account switcher header — shows overlapping avatar circles for each linked account.

**Use when:** Apps with multiple accounts (Google-style account switching) or multi-user household apps.

**Avoid when:** Single-account apps. Using this with one account adds complexity without value.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.avatarStack,
    profile: NovaHeaderUserProfile(name: 'Alice', avatarUrl: 'https://example.com/alice.jpg'),
    accounts: [
      NovaHeaderUserProfile(name: 'Bob', avatarUrl: 'https://example.com/bob.jpg'),
      NovaHeaderUserProfile(name: 'Carol', avatarUrl: 'https://example.com/carol.jpg'),
    ],
    onSwitchAccount: () => showAccountSwitcher(context),
  ),
)
```

---

### NovaProfileHeaderMultiAction

**Conceptual role:** A header with a prominent row of action buttons — the header area doubles as a quick-action toolbar.

**Use when:** Apps where users frequently trigger actions from the drawer (compose, search, notifications). Slack-like or dashboard apps.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.multiAction,
    profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
    actions: [
      NovaHeaderAction(id: 'compose', icon: Icons.edit, label: 'Compose', onTap: () {}),
      NovaHeaderAction(id: 'search', icon: Icons.search, label: 'Search', onTap: () {}),
      NovaHeaderAction(id: 'notifications', icon: Icons.notifications_outlined, label: 'Alerts', badge: 5, onTap: () {}),
    ],
  ),
)
```

---

### NovaProfileHeaderStatusAware

**Conceptual role:** A header that puts the user's presence status front-and-centre — large status dot, breathing animation when online, status message.

**Use when:** Collaboration or communication apps (chat, video conferencing) where knowing someone's availability matters.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.statusAware,
    profile: NovaHeaderUserProfile(
      name: 'Alice Johnson',
      email: 'alice@acme.com',
      status: NovaUserStatus.busy,
    ),
    showStatusIndicator: true,
  ),
)
```

---

### NovaProfileHeaderCollapsible

**Conceptual role:** A header that can toggle between a full expanded layout and a compact single-row layout, with a smooth animated transition.

**Use when:** You want users to control how much vertical space the header occupies — useful for power users who prefer more navigation items visible.

```dart
NovaDrawerHeader(
  config: NovaHeaderConfig(
    variant: NovaHeaderVariant.collapsible,
    profile: NovaHeaderUserProfile(name: 'Alice', email: 'alice@acme.com'),
    enableCollapseExpand: true,
    isCollapsed: false, // start expanded
  ),
)
```

---

## NovaMiniDrawer

### What it actually is

A **collapsed, icon-only drawer rail** — the narrow strip that remains visible on tablet/desktop when the full drawer is closed. It shows item icons with tooltips and a hamburger menu button to re-expand.

### Problem it solves

On desktop, completely hiding the drawer when it is closed loses the navigation context for the user. A mini drawer keeps navigation accessible as a persistent icon rail, consistent with patterns like VS Code's activity bar or Google Drive's collapsed sidebar.

### When to use it

**Use when:** Tablet/desktop layouts where you want persistent navigation without consuming full drawer width when collapsed. Enable via `NovaDrawerConfig.showMiniOnCollapse: true` (the scaffold handles rendering it automatically).

**Avoid when:** Mobile — on mobile, the overlay pattern (slide-in/out) is universally expected. Never show a mini drawer on a 360dp phone screen.

**Note:** You rarely instantiate `NovaMiniDrawer` directly. `NovaDrawerScaffold` creates and manages it automatically based on `NovaDrawerConfig.showMiniOnCollapse`.

### Mental model

Think of `NovaMiniDrawer` as the "icon rail" state of the drawer. When `displayMode` is `side` and the drawer is closed, the scaffold swaps the full `NovaAppDrawer` for `NovaMiniDrawer` instead of showing nothing.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `items` | `List<NovaDrawerItem>` | **Required.** Items to render as icon buttons. |
| `sections` | `List<NovaDrawerSectionData>?` | If provided, items are flattened from all sections. |
| `header` | `Widget?` | Optional widget at the top (e.g., app logo). Centered in a 64px area. |
| `footer` | `Widget?` | Optional widget at the bottom. |
| `onItemTap` | `void Function(NovaDrawerItem)?` | Called when an icon is tapped. |
| `onExpandRequest` | `VoidCallback?` | Called when the hamburger toggle is tapped or hover-expand fires. |
| `config` | `NovaDrawerConfig?` | Controls `enableHoverExpand` and `hoverExpandDelay` for this rail. |
| `width` | `double?` | Override width (default: 72 from theme). |

### Hover expansion (desktop)

When `NovaDrawerConfig.enableHoverExpand: true` is set on the **drawer's** config
(i.e., `NovaAppDrawer.config`), hovering over the mini drawer for
`hoverExpandDelay` milliseconds triggers `onExpandRequest`.

When using `NovaDrawerScaffold`, you can customise the expand behaviour via
`onMiniDrawerExpandRequest`. If not provided, the default is `controller.open()`.

```dart
// Enable hover expand:
NovaAppDrawer(
  config: const NovaDrawerConfig(
    enableHoverExpand: true,
    hoverExpandDelay: Duration(milliseconds: 400),
  ),
  ...
)

// Custom expand behaviour on the scaffold:
NovaDrawerScaffold(
  onMiniDrawerExpandRequest: () {
    // Do something custom, then expand:
    controller.open();
  },
  ...
)
```

> **Config priority note:** `enableHoverExpand` and `hoverExpandDelay` must be
> set on `NovaAppDrawer.config` (not `NovaDrawerScaffold.config`) because the
> scaffold passes the drawer's config to the mini drawer. See the
> [Config Priority](#config-priority-novadrawerscaffold-vs-novaappdrawer) section
> for a full explanation.

### Example (direct use)

```dart
NovaMiniDrawer(
  items: myNavItems,
  header: const FlutterLogo(size: 32),
  onItemTap: (item) => Navigator.pushNamed(context, item.route ?? '/'),
  onExpandRequest: () => drawerController.open(),
)
```

---

## NovaDrawerSectionWidget

### What it actually is

The **rendering widget for a `NovaDrawerSectionData`**. It renders a section header label, a collapsible items list, optional header/footer custom widgets, and dividers — all animated via `SizeTransition`.

### When to use it

You normally do not use this directly. `NovaAppDrawer` renders `NovaDrawerSectionWidget` for each section in `sections`. Use it directly only if you are building a custom drawer layout from scratch.

### Mental model

Think of it as the view layer for `NovaDrawerSectionData`. It reads collapse state from `NovaDrawerController` and animates accordingly.

---

## NovaNestedMenuItem

### What it actually is

An **expandable parent item with animated child reveal**. When the parent is tapped, it toggles between expanded (children visible) and collapsed (children hidden), using `SizeTransition` + `FadeTransition`.

### Problem it solves

Multi-level navigation hierarchies need expand/collapse mechanics. Flutter has no built-in drawer-specific nested menu. `NovaNestedMenuItem` handles arbitrary depth nesting, with the controller tracking each item's expanded state.

### When to use it

You normally do not use this directly either — `NovaDrawerSectionWidget` and `NovaAppDrawer` create `NovaNestedMenuItem` automatically for any `NovaDrawerItem` that has `children`. Use it directly only in custom layouts.

### Mini mode behaviour

In mini mode (`isMiniMode: true`), `NovaNestedMenuItem` switches from an inline expandable to a `PopupMenuButton` — tapping the icon opens a popup listing all children.

---

## NovaDrawerItemWidget

### What it actually is

The **renderer for a single `NovaDrawerItem`**. It handles normal, selected, hovered, disabled, and mini-mode rendering states, plus badge rendering, trailing widgets, and accessibility semantics.

### When to use it

Normally created automatically by `NovaDrawerSectionWidget` and `NovaNestedMenuItem`. Use directly when building a fully custom item layout outside the section system.

### Mini mode

When `isMiniMode: true`, renders a centered icon with a `Tooltip` showing the item title. All text is hidden.

---

## NovaDrawerWorkspaceSwitcher

### What it actually is

A **workspace/organization/account context switcher** embedded inside the drawer. It shows the currently active workspace in a tappable chip, and drops down an inline list of all available workspaces when tapped.

### Problem it solves

Multi-tenant apps (Slack, Notion, Linear) need users to switch context without leaving the current screen. Putting this in the drawer means users access it naturally without a separate screen navigation.

### When to use it

**Use when:** Your app supports multiple orgs, teams, workspaces, or accounts, and users need to switch between them frequently.

**Avoid when:** Single-tenant or single-account apps. Adding a switcher with only one entry is misleading.

### Mental model

Think of this as a lightweight org/context switcher, not a full navigation system. It surfaces the currently active workspace and lets users switch with one tap. It does **not** handle the switching logic — you handle that in `onSelect`.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `workspaces` | `List<NovaDrawerWorkspace>` | **Required.** All available workspaces. |
| `padding` | `EdgeInsetsGeometry` | Outer padding around the widget. |

**`NovaDrawerWorkspace` fields:**

| Field | Purpose |
|---|---|
| `id` | Unique identifier. |
| `name` | Display name. |
| `icon` | Optional icon (shown if no `avatarUrl`). |
| `avatarUrl` | Optional avatar image URL. |
| `isActive` | Marks this as the currently active workspace (shows checkmark). |
| `onSelect` | Called when the user selects this workspace. Wire to your context-switching logic. |

### Example

```dart
NovaDrawerWorkspaceSwitcher(
  workspaces: [
    NovaDrawerWorkspace(
      id: 'personal',
      name: 'Personal',
      icon: Icons.person_outline,
      isActive: true,
      onSelect: () => switchWorkspace('personal'),
    ),
    NovaDrawerWorkspace(
      id: 'acme-corp',
      name: 'Acme Corp',
      avatarUrl: 'https://example.com/acme-logo.png',
      isActive: false,
      onSelect: () => switchWorkspace('acme-corp'),
    ),
    NovaDrawerWorkspace(
      id: 'startup-co',
      name: 'Startup Co',
      icon: Icons.rocket_launch_outlined,
      isActive: false,
      onSelect: () => switchWorkspace('startup-co'),
    ),
  ],
)
```

The active workspace is shown collapsed. Tapping it reveals a dropdown list with a checkmark on the active entry. Selecting another entry calls `onSelect` and collapses the dropdown.

---

## NovaDrawerShortcutsGrid

### What it actually is

A **quick-access action grid** inside the drawer — a `Wrap` of icon + label tiles arranged in N columns. Think of app shortcuts on an Android home screen, but inside your drawer.

### Problem it solves

Users have frequently performed actions that are buried in the navigation hierarchy. Instead of navigating through 3 levels of menu, a shortcuts grid in the drawer surface lets them jump directly to "New Document", "Upload File", "Scan QR", etc.

### When to use it

**Use when:** You have 2–8 frequently used actions that are distinct from the main navigation items (create, search, scan, share, etc.). Dashboard apps, productivity tools, file managers.

**Avoid when:** All your shortcuts are already top-level navigation items — doubling them adds clutter.

### Mental model

Think of this as a **dashboard quick-actions panel** embedded in the drawer, not as a navigation replacement. Items trigger actions, not navigation (though they can do either).

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `shortcuts` | `List<NovaDrawerShortcut>` | **Required.** Shortcuts to display. |
| `crossAxisCount` | `int` | Number of columns (default: 4). |
| `padding` | `EdgeInsetsGeometry` | Outer padding. |

**`NovaDrawerShortcut` fields:**

| Field | Purpose |
|---|---|
| `id` | Unique identifier. |
| `label` | Short label below the icon. |
| `icon` | Icon displayed. |
| `onTap` | Action triggered on tap. |
| `color` | Optional accent color for the icon and background tint. |
| `badge` | Optional unread count badge on the icon. |

### Example

```dart
NovaDrawerShortcutsGrid(
  crossAxisCount: 4,
  shortcuts: [
    NovaDrawerShortcut(
      id: 'new-doc',
      label: 'New Doc',
      icon: Icons.note_add_outlined,
      color: Colors.blue,
      onTap: () => createDocument(context),
    ),
    NovaDrawerShortcut(
      id: 'upload',
      label: 'Upload',
      icon: Icons.upload_outlined,
      color: Colors.green,
      onTap: () => uploadFile(context),
    ),
    NovaDrawerShortcut(
      id: 'scan',
      label: 'Scan',
      icon: Icons.qr_code_scanner,
      color: Colors.orange,
      onTap: () => scanQR(context),
    ),
    NovaDrawerShortcut(
      id: 'inbox',
      label: 'Inbox',
      icon: Icons.inbox_outlined,
      color: Colors.purple,
      badge: 7, // 7 unread items
      onTap: () => openInbox(context),
    ),
  ],
)
```

Each shortcut renders as an icon above a label, inside a rounded container with a light accent color tint. Badges appear as an error-colored counter on the icon.

---

## NovaDrawerStatsCard

### What it actually is

A **horizontal stats summary card** — a row of 2–4 metric boxes (value + label) separated by vertical dividers, rendered inside a rounded card container.

### Problem it solves

Showing user context at a glance inside the drawer — "you have 12 projects, 48 tasks, 3 alerts" — helps users understand their state without navigating to a separate dashboard screen.

### When to use it

**Use when:** You have 2–4 key metrics tied to the current user/workspace that are meaningful at a glance (tasks due, unread, projects, followers, storage used).

**Avoid when:** You have only 1 metric (use a `NovaDrawerAppStatusWidget` instead), or more than 4 (the card becomes too crowded to read).

### Mental model

Think of this as a **user-context summary panel**, not a full analytics widget. The numbers give context; detailed data lives elsewhere.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `items` | `List<NovaDrawerStatItem>` | **Required.** 2–4 stat entries. |
| `padding` | `EdgeInsetsGeometry` | Outer padding. |

**`NovaDrawerStatItem` fields:**

| Field | Purpose |
|---|---|
| `label` | Descriptor below the value (e.g., "Projects"). |
| `value` | The metric to display (e.g., "12" or "2.3k"). |
| `icon` | Optional small icon above the value. |
| `onTap` | Optional — makes this stat tappable to drill down. |

### Example

```dart
NovaDrawerStatsCard(
  items: [
    NovaDrawerStatItem(
      label: 'Projects',
      value: '12',
      icon: Icons.folder_outlined,
      onTap: () => Navigator.pushNamed(context, '/projects'),
    ),
    NovaDrawerStatItem(label: 'Tasks', value: '48'),
    NovaDrawerStatItem(label: 'Done', value: '91%'),
  ],
)
```

---

## NovaDrawerRecentItems

### What it actually is

A **chronological list of recently accessed items** — a "jump back in" panel showing icon + title + subtitle + relative timestamp for each recent entry.

### Problem it solves

Users frequently return to the same documents, projects, or conversations. Surfacing recents directly in the drawer eliminates the need to search or navigate to find something they were just working on.

### When to use it

**Use when:** Your app has content that users repeatedly revisit — documents, files, conversations, projects, orders.

**Avoid when:** Your app is highly transactional with no persistent content (e.g., a calculator, a simple form wizard).

### Mental model

Think of this as the **"Recently opened" section** from macOS Finder or VS Code's recent files, embedded in the drawer. It is a display widget — you supply the data from your app state.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `items` | `List<NovaDrawerRecentItem>` | **Required.** Items to display, ordered most-recent first. |
| `headerText` | `String` | Label above the list (default: `'Recent'`). |
| `padding` | `EdgeInsetsGeometry` | Outer padding. |

**`NovaDrawerRecentItem` fields:**

| Field | Purpose |
|---|---|
| `id` | Unique identifier. |
| `title` | Main text (file name, document name, etc.). |
| `subtitle` | Secondary text (folder path, last action, etc.). |
| `icon` | Icon for the item type. Defaults to `Icons.history`. |
| `timestamp` | `DateTime` of last access — auto-formatted as "5m ago", "2h ago", "3d ago". |
| `onTap` | Opens the item when tapped. |

### Example

```dart
NovaDrawerRecentItems(
  headerText: 'Recent',
  items: [
    NovaDrawerRecentItem(
      id: 'doc-1',
      title: 'Q4 Strategy.pdf',
      subtitle: '/documents/strategy/',
      icon: Icons.picture_as_pdf,
      timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
      onTap: () => openDocument('doc-1'),
    ),
    NovaDrawerRecentItem(
      id: 'proj-3',
      title: 'Nova Redesign',
      subtitle: 'Updated colors and layout',
      icon: Icons.palette_outlined,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      onTap: () => openProject('proj-3'),
    ),
  ],
)
```

Timestamps are automatically formatted relative to `DateTime.now()`: "just now", "5m ago", "3h ago", "2d ago", "1w ago".

---

## NovaDrawerFilterChipsWidget

### What it actually is

A **horizontally scrollable row of `FilterChip`s** inside the drawer. Each chip is a selectable filter category with an optional icon and accent color. Tapping a chip triggers `onSelected`.

### Problem it solves

Apps with large content libraries (files, tasks, contacts) benefit from quick filter toggles accessible from the drawer. This avoids cluttering the main screen UI with permanent filter controls.

### When to use it

**Use when:** Your drawer acts as a navigation + filter panel — the user picks a section, then filters that section's content without leaving the drawer. Document managers, task managers, inbox apps.

**Avoid when:** Your filters are complex enough to deserve a dedicated filter screen, or the drawer is purely navigation-only. Also avoid when the filter state is not immediately reflected in the main content area.

### Mental model

Think of this as a **contextual content filter** embedded in the drawer, not a search widget. The chips narrow what is shown in `body`, and your app state holds which chips are selected.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `chips` | `List<NovaDrawerFilterChip>` | **Required.** Filter options. |
| `padding` | `EdgeInsetsGeometry` | Outer padding. |

**`NovaDrawerFilterChip` fields:**

| Field | Purpose |
|---|---|
| `id` | Unique identifier. |
| `label` | Chip label text. |
| `isSelected` | Whether this chip is currently selected (controls visual state). |
| `onSelected` | `ValueChanged<bool>` — called when selection changes. |
| `icon` | Optional leading icon. |
| `color` | Optional accent color for the selected state. |

### Example

```dart
// In your state class:
final chips = [
  NovaDrawerFilterChip(
    id: 'all',
    label: 'All',
    isSelected: _activeFilter == 'all',
    onSelected: (_) => setState(() => _activeFilter = 'all'),
  ),
  NovaDrawerFilterChip(
    id: 'docs',
    label: 'Docs',
    icon: Icons.article_outlined,
    isSelected: _activeFilter == 'docs',
    onSelected: (_) => setState(() => _activeFilter = 'docs'),
  ),
  NovaDrawerFilterChip(
    id: 'images',
    label: 'Images',
    icon: Icons.image_outlined,
    isSelected: _activeFilter == 'images',
    onSelected: (_) => setState(() => _activeFilter = 'images'),
  ),
];

// In build:
NovaDrawerFilterChipsWidget(chips: chips)
```

**Important:** `NovaDrawerFilterChipsWidget` does not manage selection state. You own the state and rebuild the chips list with updated `isSelected` values.

---

## NovaDrawerAppStatusWidget

### What it actually is

A **compact footer status bar** showing app connectivity status (online/offline dot), an optional status message, and app version/build number — all in a single row.

### Problem it solves

In enterprise and B2B apps, users need to know whether the app is connected to the server. Surfacing this in the drawer footer is unobtrusive but always accessible. Version info is useful for support calls ("what version are you on?").

### When to use it

**Use when:** Your app has meaningful online/offline states (sync-based apps, real-time apps, apps with pending local changes). Also useful in any app where support teams need users to report version numbers.

**Avoid when:** Your app is always online with no offline mode, and version number is irrelevant to users (consumer apps with auto-update).

### Mental model

Think of this as a **persistent system tray** for the drawer — minimal footprint, informative, never intrusive. Place it as the `footer` of `NovaAppDrawer`.

### Parameters

| Parameter | Type | Purpose |
|---|---|---|
| `status` | `NovaDrawerAppStatus` | **Required.** Status data. |
| `padding` | `EdgeInsetsGeometry` | Outer padding. |

**`NovaDrawerAppStatus` fields:**

| Field | Purpose |
|---|---|
| `isOnline` | Controls the green (online) / red (offline) dot color. |
| `statusMessage` | Custom message ("Syncing…", "All changes saved"). Falls back to "Online" / "Offline". |
| `version` | App version string (e.g., `"2.1.0"`). |
| `buildNumber` | Build number appended to version as `"v2.1.0 (42)"`. |
| `customWidget` | Completely replaces the default layout. |

### Example

```dart
NovaDrawerAppStatusWidget(
  status: NovaDrawerAppStatus(
    isOnline: connectivityService.isConnected,
    statusMessage: connectivityService.isConnected ? 'Connected' : 'Working offline',
    version: packageInfo.version,
    buildNumber: packageInfo.buildNumber,
  ),
)
```

---

## NovaDrawerSurface

### What it actually is

A **surface style renderer** — a container widget that applies one of 10 visual styles to whatever content is placed inside it. It does not affect the drawer's layout, only its visual panel appearance.

### Problem it solves

Applying effects like glassmorphism, neumorphism, or animated mesh gradients to a container widget involves boilerplate `BackdropFilter`, `BoxDecoration`, and animation code. `NovaDrawerSurface` encapsulates all of that behind a simple config enum.

### When to use it

**Use when:** You want to apply advanced visual effects to the drawer panel itself, or to content blocks inside the drawer.

**Note:** `NovaAppDrawer`'s visual style is controlled via `NovaDrawerTheme.gradient`, `NovaDrawerTheme.backgroundImage`, `backgroundWidget`, `enableGradientBackground`, and `enableParticleBackground`. `NovaDrawerSurface` is a standalone widget useful when you want to apply a surface effect to a specific sub-section of the drawer, not the whole panel.

### Surface styles (`NovaDrawerSurfaceStyle` enum)

| Style | What it looks like |
|---|---|
| `plain` | Flat background color |
| `elevated` | Shadow below the surface |
| `glassmorphism` | Frosted glass with `BackdropFilter` blur |
| `blurred` | Background blurred with dark overlay |
| `gradient` | Linear gradient fill |
| `premiumShadow` | Multi-layer deep shadow (dramatic) |
| `outlinedMinimal` | Thin border, flat interior |
| `neumorphic` | Soft raised/inset shadow effect |
| `imageBacked` | Image fills the container |
| `animatedMeshGradient` | Looping animated gradient shift |

### Example

```dart
NovaDrawerSurface(
  config: NovaDrawerSurfaceConfig(
    style: NovaDrawerSurfaceStyle.glassmorphism,
    blurSigma: 12.0,
    borderRadius: BorderRadius.circular(16),
    opacity: 0.85,
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: myDrawerContent,
  ),
)
```

---

## NovaDrawerBuilders

### What it actually is

A **slot-based builder override system** — a collection of optional builder callbacks, one for each renderable part of the drawer. If you provide a builder, it replaces the default rendering for that slot. If you leave it `null`, the default is used.

### Problem it solves

No matter how many built-in variants a package offers, there will always be apps with bespoke design requirements. `NovaDrawerBuilders` lets you incrementally override specific parts without rewriting the whole drawer.

### When to use it

**Use when:** You have a specific design for, say, item rendering that differs from the default, but you still want the scaffold, controller, responsive behavior, and header system to work as-is.

**Avoid when:** You are overriding everything — at that point, you might as well build a custom drawer. The value of `NovaDrawerBuilders` is *selective* overriding.

### Mental model

Think of this as a **dependency injection system** for the drawer's rendering. The drawer engine calls your builder callback instead of its own default when one is provided.

### Available builder slots

| Slot | Signature | Replaces |
|---|---|---|
| `headerBuilder` | `(context, NovaHeaderConfig) → Widget` | The entire drawer header |
| `itemBuilder` | `(context, NovaDrawerItem, isSelected) → Widget` | Each individual item tile |
| `sectionBuilder` | `(context, NovaDrawerSectionData) → Widget` | Each section container |
| `backgroundBuilder` | `(context, child) → Widget` | The drawer background layer |
| `footerBuilder` | `(context) → Widget` | The drawer footer |
| `emptyStateBuilder` | `(context) → Widget` | Shown when items list is empty |
| `loadingBuilder` | `(context) → Widget` | Shown while `controller.isLoading` |
| `errorBuilder` | `(context, message, onRetry) → Widget` | Shown when `controller.errorMessage` is set |
| `searchBarBuilder` | `(context, controller, onChanged) → Widget` | The search bar |
| `filterChipBuilder` | `(context, NovaDrawerFilterChip) → Widget` | Each filter chip |
| `statsCardBuilder` | `(context, List<NovaDrawerStatItem>) → Widget` | The stats card |
| `shortcutGridBuilder` | `(context, List<NovaDrawerShortcut>) → Widget` | The shortcuts grid |
| `recentItemBuilder` | `(context, NovaDrawerRecentItem) → Widget` | Each recent item row |
| `workspaceSwitcherBuilder` | `(context, List<NovaDrawerWorkspace>) → Widget` | The workspace switcher |
| `appStatusBuilder` | `(context, NovaDrawerAppStatus) → Widget` | The app status bar |
| `separatorBuilder` | `(context) → Widget` | Dividers between items |
| `accessibilityLabelBuilder` | `(NovaDrawerItem, isSelected) → String` | Semantic labels for items |

### Example

```dart
NovaDrawerBuilders(
  // Custom item layout with a leading colored bar for selected items
  itemBuilder: (context, item, isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: isSelected
          ? BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
              border: Border(left: BorderSide(color: Theme.of(context).colorScheme.primary, width: 3)),
            )
          : null,
      child: ListTile(
        leading: Icon(item.icon, color: isSelected ? Theme.of(context).colorScheme.primary : null),
        title: Text(item.title),
        selected: isSelected,
        onTap: () => item.onTap?.call(),
      ),
    );
  },
  // Custom error state
  errorBuilder: (context, message, onRetry) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Could not load navigation: $message'),
          TextButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  },
)
```

---

## Configuration Objects

### NovaDrawerConfig

The **central behavior configuration** for the drawer. Controls layout mode, animation style, gesture sensitivity, pinning, overlay, and accessibility.

```dart
NovaDrawerConfig(
  displayMode: NovaDrawerDisplayMode.auto,   // auto-responsive layout
  animationType: NovaDrawerAnimationType.slide,
  animationConfig: const NovaDrawerAnimationConfig(
    duration: Duration(milliseconds: 300),
    curve: Curves.easeOutCubic,
  ),
  breakpoints: const NovaDrawerBreakpoints(
    mobile: 600,   // < 600px → mobile
    tablet: 1024,  // 600–1024px → tablet, > 1024px → desktop
  ),
  gestureConfig: const NovaDrawerGestureConfig(
    enableSwipeToOpen: true,
    swipeSensitivity: 0.5,  // 0.0 (sluggish) → 1.0 (hyper-sensitive)
  ),
  accessibilityConfig: const NovaDrawerAccessibilityConfig(
    drawerLabel: 'Navigation drawer',
    closeButtonLabel: 'Close navigation drawer',
  ),
  isPinnable: true,
  isPinnedByDefault: false,
  showMiniOnCollapse: true,    // show icon rail when drawer is closed on desktop
  enableHoverExpand: true,     // mini drawer expands on mouse hover (desktop)
  hoverExpandDelay: Duration(milliseconds: 500),
  closeOnItemTap: true,        // auto-close on mobile when item is tapped
  closeOnOutsideTap: true,
  showOverlay: true,
  overlayOpacity: 0.5,
)
```

---

### NovaDrawerTheme

The **visual design token set** for the entire drawer. All properties are optional and fall back to Material 3 `ColorScheme` defaults.

Key properties worth calling out:

| Property | Purpose |
|---|---|
| `backgroundColor` | Drawer panel fill color. |
| `selectedItemColor` | Color of text/icon for active item. |
| `selectedItemBackgroundColor` | Background highlight behind the active item. |
| `gradient` | Background `Gradient` — overrides `backgroundColor`. |
| `borderRadius` | Rounds the drawer panel corners (useful for floating drawer effects). |
| `miniDrawerWidth` | Width of the icon rail in mini mode (default: 72). |
| `expandedDrawerWidth` | Full drawer width on mobile (default: 280). |
| `desktopDrawerWidth` | Full drawer width on desktop (default: 300). |
| `backgroundBlur` | Blur the background behind the drawer (glassmorphism). |

```dart
NovaDrawerTheme(
  backgroundColor: const Color(0xFF1E1E2E),
  selectedItemColor: const Color(0xFF89B4FA),
  itemTextStyle: const TextStyle(fontSize: 14),
  elevation: 8.0,
  borderRadius: BorderRadius.circular(16),
)

// Or use a preset:
NovaDrawerTheme.dark()
NovaDrawerTheme.light()
```

---

### NovaDrawerAnimationConfig

**Fine-grained animation timing and physics** for every animated element in the drawer.

```dart
NovaDrawerAnimationConfig(
  duration: const Duration(milliseconds: 300),       // main drawer open/close
  reverseDuration: const Duration(milliseconds: 200), // close is faster than open
  curve: Curves.easeOutCubic,
  itemStaggerDelay: const Duration(milliseconds: 50), // items enter staggered
  sectionAnimationDuration: const Duration(milliseconds: 250),
  nestedExpandDuration: const Duration(milliseconds: 200),
  enableItemAnimations: true,
  enableStaggeredAnimations: true,
  springDamping: 0.7,     // for spring animation type
  springStiffness: 200.0,
  elasticPeriod: 0.4,     // for elastic animation type
  blurSigma: 10.0,        // for blur animation type
)
```

---

### NovaHeaderConfig

The **data + behavior config for any drawer header variant**. Described in detail in the [NovaDrawerHeader](#novadrawerheader-variant-system) section above.

---

## Config Priority: NovaDrawerScaffold vs NovaAppDrawer

Both `NovaDrawerScaffold` and `NovaAppDrawer` accept a `NovaDrawerConfig`. This is
intentional — they have overlapping but distinct responsibilities, and the same
config object can be shared between them.

### What each config controls

| Config setting | Effective in | Reason |
|---|---|---|
| `displayMode` | `NovaDrawerScaffold` | The scaffold decides *how* the drawer is displayed (overlay / push / side / mini). |
| `breakpoints` | `NovaDrawerScaffold` | The scaffold resolves which device type the screen width maps to. |
| `animationConfig` (scaffold-level) | `NovaDrawerScaffold` | Controls the drawer slide-in/slide-out animation managed by the scaffold. |
| `gestureConfig` | `NovaDrawerScaffold` | The scaffold handles swipe gestures on the body. |
| `showMiniOnCollapse` | `NovaDrawerScaffold` | The scaffold decides whether to show `NovaMiniDrawer` when collapsed. |
| `isPinnedByDefault` | `NovaDrawerScaffold` | The scaffold initialises the pinned state on startup. |
| `closeOnOutsideTap` | `NovaDrawerScaffold` | The scaffold handles the overlay scrim tap. |
| `animationType` / `animationConfig` (item-level) | `NovaAppDrawer` | The drawer animates its own content items on mount. |
| `accessibilityConfig` | `NovaAppDrawer` | The drawer applies semantic labels to its content. |
| `closeOnItemTap` | `NovaAppDrawer` / `NovaDrawerSectionWidget` | The drawer/section decides whether to close on mobile after tap. |
| **`enableHoverExpand`** | **`NovaAppDrawer`** | The scaffold passes `drawer.config` to `NovaMiniDrawer`. Set this on the drawer. |
| **`hoverExpandDelay`** | **`NovaAppDrawer`** | Same as above. |

### Which has priority?

There is no conflict resolution — both configs are used simultaneously for the
parts they own. When in doubt, set the option on both.

**Key rule:** Settings that affect the **mini drawer's** behaviour must be on
`NovaAppDrawer.config`, because the scaffold hands that config directly to
`NovaMiniDrawer`. Settings that affect the **scaffold layout** must be on
`NovaDrawerScaffold.config`.

### Simplest pattern (share one config object)

```dart
const myConfig = NovaDrawerConfig(
  displayMode: NovaDrawerDisplayMode.auto,
  showMiniOnCollapse: true,
  enableHoverExpand: true,
  hoverExpandDelay: Duration(milliseconds: 400),
  closeOnItemTap: true,
);

NovaDrawerScaffold(
  config: myConfig,
  drawer: NovaAppDrawer(
    config: myConfig, // same object – both get all settings
    ...
  ),
  ...
)
```

---

## Particles

`NovaParticleBackground` renders floating animated circles over the drawer's
background layer. Each particle is a small filled circle that:

- **Drifts** slowly across the panel using sinusoidal motion
- **Pulses** in opacity for a breathing effect
- **Randomises** size, speed, starting position, and phase per particle

Enable it on `NovaAppDrawer`:

```dart
NovaAppDrawer(
  enableParticleBackground: true,
  particleCount: 25,        // number of particles (default: 20)
  particleColor: Colors.white.withOpacity(0.15),
  ...
)
```

Particles are rendered on a `CustomPaint` layer above the drawer content
background but below the navigation items, so they never block taps.

**When to use:** Apps where you want the drawer to feel "alive" — creative tools,
entertainment apps, onboarding flows. Pair with `enableGradientBackground: true`
for best results.

**Avoid when:** You target users with motion-sensitivity preferences, or the
app's design is strictly minimal/flat.

---

## Animations

NovaDrawer has 16 animation types for the drawer's open/close transition. Set via `NovaDrawerConfig.animationType`:

| Type | Description |
|---|---|
| `slide` | Standard horizontal slide. Default. |
| `fade` | Opacity fade in/out. |
| `scale` | Scales from a point origin. |
| `rotate` | Rotates in/out around an axis. |
| `morph` | Shape-morphing transition. |
| `elastic` | Overshoots then settles (elastic spring). |
| `spring` | Physics-based spring with configurable damping/stiffness. |
| `shimmer` | Shimmer/glint effect during transition. |
| `blur` | Blurs in/out as it opens/closes. |
| `gradient` | Colour transition alongside the slide. |
| `floating` | Drawer appears to float above content with elevation. |
| `floatingBounce` | Floating + elastic overshoot on open. |
| `floatingReveal` | Circular clip reveal from an origin point. |
| `wave` | Wave-like boundary wipe reveal. |
| `parallax` | Multi-layer depth effect — content layers move at different speeds. |
| `curtain` | Split-panel curtain wipe from centre outward. |

---

## Migration Guide

All public classes were renamed in v1.0.0 to use the `Nova` prefix. The old names still compile but emit `@Deprecated` warnings. They will be removed in v2.0.0.

| Old name | New name |
|---|---|
| `AdvancedAppDrawer` | `NovaAppDrawer` |
| `AdvancedDrawerController` | `NovaDrawerController` |
| `AdvancedDrawerTheme` | `NovaDrawerTheme` |
| `DrawerConfig` | `NovaDrawerConfig` |
| `DrawerItem` | `NovaDrawerItem` |
| `DrawerItemBadge` | `NovaDrawerItemBadge` |
| `DrawerSectionData` | `NovaDrawerSectionData` |
| `DrawerHeaderWidget` | `NovaDrawerHeaderWidget` |
| `DrawerItemWidget` | `NovaDrawerItemWidget` |
| `DrawerSectionWidget` | `NovaDrawerSectionWidget` |
| `NestedMenuItem` | `NovaNestedMenuItem` |
| `MiniDrawerWidget` | `NovaMiniDrawer` |
| `DrawerScaffoldWidget` | `NovaDrawerScaffold` |
| `DrawerStatsCard` | `NovaDrawerStatsCard` |
| `DrawerShortcutsGrid` | `NovaDrawerShortcutsGrid` |
| `DrawerRecentItems` | `NovaDrawerRecentItems` |
| `DrawerFilterChips` | `NovaDrawerFilterChipsWidget` |
| `DrawerAppStatusWidget` | `NovaDrawerAppStatusWidget` |
| `DrawerWorkspaceSwitcher` | `NovaDrawerWorkspaceSwitcher` |
| `DrawerSurfaceConfig` | `NovaDrawerSurfaceConfig` |
| `DrawerSurface` | `NovaDrawerSurface` |
| `DrawerBuilders` | `NovaDrawerBuilders` |
| `DrawerAnimationConfig` | `NovaDrawerAnimationConfig` |
| `HeaderUserProfile` | `NovaHeaderUserProfile` |
| `HeaderAction` | `NovaHeaderAction` |

---

## License

MIT — see [LICENSE](LICENSE).
