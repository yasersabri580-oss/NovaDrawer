# Changelog

## 1.1.0

### New Features

- **Inline body routing via `NovaDrawerBodyRouter`**: A new `body` widget for
  `NovaDrawerScaffold` that hosts drawer navigation pages inside the scaffold
  body using an `IndexedStack`, so the `AppBar`, `bottomNavigationBar` (e.g. a
  `MotionTabBar`), and any other scaffold-level widget stay visible no matter
  which drawer page is active.

  The classic `Navigator.push` / `GoRouter.go` pattern replaces the entire
  scaffold — wiping out bottom bars and app bars. `NovaDrawerBodyRouter`
  eliminates this problem by keeping the outer scaffold fixed and swapping only
  the content area:

  ```dart
  // MotionTabBar lives HERE → always visible, even on drawer pages
  bottomNavigationBar: MotionTabBar(..., onTabItemSelected: (i) {
    setState(() {
      _tabIndex = i;
      _drawerController.clearSelection(); // return to fallback
    });
  }),

  // Body swaps between tab content and drawer pages
  body: NovaDrawerBodyRouter(
    controller: _drawerController,
    pages: _inlinePages,
    fallback: IndexedStack(index: _tabIndex, children: tabWidgets),
  ),
  ```

- **`NovaDrawerPage` model**: Maps a `NovaDrawerItem.id` to a lazily-built
  `WidgetBuilder`. Pages that the user never visits are never constructed.

  | Field | Type | Default | Purpose |
  |---|---|---|---|
  | `id` | `String` | – | **Required.** Must match `NovaDrawerItem.id`. |
  | `route` | `String?` | `null` | Optional route; used by `novaDrawerBodyNavigate` to suppress double-navigation. |
  | `builder` | `WidgetBuilder` | – | **Required.** Lazily called on first activation. |
  | `keepAlive` | `bool` | `true` | When `true`, widget state is preserved while the page is hidden. When `false`, the subtree is rebuilt fresh on every visit. |

- **`novaDrawerBodyNavigate` navigation helper**: Produces an `onNavigate`
  callback for `NovaAppDrawer` that intercepts routes handled inline by
  `NovaDrawerBodyRouter` (preventing double-navigation) and forwards everything
  else to your external router:

  ```dart
  NovaAppDrawer(
    onNavigate: novaDrawerBodyNavigate(
      pages: _inlinePages,
      external: (ctx, route) => GoRouter.of(ctx).go(route),
    ),
    ...
  )
  ```

- **Lazy page construction + per-page `keepAlive`**: Pages are built on first
  activation only, keeping startup fast regardless of how many pages are
  registered. Setting `keepAlive: false` on any page discards its widget
  subtree when the user navigates away, so it rebuilds from scratch on the
  next visit — useful for pages that must always show fresh server data.

---

## 1.0.9

### New Features

- **Router-agnostic navigation via `onNavigate`** (`NovaAppDrawer.onNavigate`):
  A new optional `void Function(BuildContext context, String route)` callback
  lets you plug in **any** navigation system — GoRouter, auto_route, Navigator
  2.0, or your own custom router — without having to bridge through `onItemTap`.

  When `onNavigate` is provided and an item's `route` field is non-null, the
  drawer calls `onNavigate(context, route)` on tap instead of the default
  `Navigator.pushNamed` fallback, making GoRouter usage trivial:

  ```dart
  NovaAppDrawer(
    onNavigate: (context, route) => context.go(route), // GoRouter
    items: [
      NovaDrawerItem(id: 'units', title: 'Units', icon: Icons.straighten_outlined,
                     route: '/settings/units'),
      NovaDrawerItem(id: 'currencies', title: 'Currencies', icon: Icons.currency_exchange,
                     route: '/settings/currencies'),
    ],
    ...
  )
  ```

  **Backward-compatible**: if `onNavigate` is not set, the drawer falls back to
  `Navigator.of(context).pushNamed(route)` exactly as before.

  The callback is automatically threaded through all internal widgets:
  `NovaDrawerSectionWidget`, `NovaNestedMenuItem` (full-drawer and mini popup
  mode), and `NovaMiniDrawer`.

- **`onTap` per item**: Each `NovaDrawerItem` already exposes an
  `onTap: VoidCallback?` field that is fired on every tap regardless of
  whether a `route` is set, giving you a per-item side-effect hook (analytics,
  state updates, etc.) alongside the router-level navigation.

  ```dart
  NovaDrawerItem(
    id: 'units',
    title: 'Units',
    icon: Icons.straighten_outlined,
    route: '/settings/units',
    onTap: () => analytics.log('units_tapped'), // fires in addition to navigation
  )
  ```

---

## 1.0.8

### New Features

- **First-class `entries` API** (`NovaAppDrawer.entries`): A new `entries`
  parameter lets you freely interleave standalone items and grouped sections
  in any order, breaking out of the previous constraint of either a flat item
  list *or* a sections list.

  Two sealed subtypes express each kind of entry:

  - `NovaDrawerItemEntry(NovaDrawerItem)` — a standalone item rendered directly
    in the drawer content area. Respects `isVisible` and `isItemHidden`.
  - `NovaDrawerSectionEntry(NovaDrawerSectionData)` — a full collapsible section
    group that handles its own item filtering as before.

  When `entries` is non-empty it takes priority over `sections` / `items`,
  keeping the change fully backward-compatible.

  ```dart
  NovaAppDrawer(
    controller: controller,
    entries: [
      NovaDrawerItemEntry(NovaDrawerItem(id: 'home',    title: 'Home',    icon: Icons.home)),
      NovaDrawerItemEntry(NovaDrawerItem(id: 'profile', title: 'Profile', icon: Icons.person)),
      NovaDrawerSectionEntry(NovaDrawerSectionData(
        id: 'tools', title: 'Tools',
        items: [
          NovaDrawerItem(id: 'search',   title: 'Search',   icon: Icons.search),
          NovaDrawerItem(id: 'settings', title: 'Settings', icon: Icons.settings),
          NovaDrawerItem(id: 'help',     title: 'Help',     icon: Icons.help_outline),
        ],
      )),
      NovaDrawerItemEntry(NovaDrawerItem(id: 'logout', title: 'Logout', icon: Icons.logout)),
    ],
  )
  ```

---

## 1.0.7

### Bug Fixes

- **Mini mode `onItemTap` not firing**: When `NovaDrawerScaffold` renders the
  mini drawer, it now falls back to `NovaAppDrawer.onItemTap` when the
  scaffold-level `onItemTap` is not set. Previously, a tap callback placed
  only on `NovaAppDrawer` was silently ignored in mini mode.

- **Selected item not highlighted in full drawer (flat items)**: `NovaAppDrawer`
  now listens to the controller and rebuilds when selection or other state
  changes. Previously, only items rendered inside `NovaDrawerSectionWidget`
  would visually update their selected state; items supplied via the flat
  `items` list did not re-render until an unrelated rebuild occurred.

### New Features

- **Custom mini-drawer expand callback** (`NovaDrawerScaffold.onMiniDrawerExpandRequest`):
  A new optional `VoidCallback` on `NovaDrawerScaffold` lets you override the
  default expand-on-toggle / expand-on-hover behaviour. When provided, this
  callback is invoked instead of the built-in `controller.open()`. This gives
  you full control — run analytics, show a modal, or perform additional side
  effects before or instead of expanding.

  ```dart
  NovaDrawerScaffold(
    onMiniDrawerExpandRequest: () {
      analytics.track('mini_drawer_expanded');
      controller.open();
    },
    ...
  )
  ```

  Hover-expand is still gated by `NovaDrawerConfig.enableHoverExpand: true`
  (set on the **drawer's** config). The delay is controlled by
  `NovaDrawerConfig.hoverExpandDelay`.

---

## 1.0.6

- Fixed onClose not working in drawer

## 1.0.5

- Fixed "setState() or markNeedsBuild() called during build" crash that occurred
  when opening the drawer on mobile. The device-type update now runs in a
  post-frame callback instead of directly inside `build()`, preventing
  `notifyListeners()` from being dispatched while the widget tree is building.

## 1.0.3

- Bug fixes

## 1.0.2

- Novadrawer controller now opens that drawer on overlymode
