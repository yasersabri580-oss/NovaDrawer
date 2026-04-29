# Changelog

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
