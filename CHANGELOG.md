# Changelog

## 1.0.4

- Fixed "setState() or markNeedsBuild() called during build" crash that occurred
  when opening the drawer on mobile. The device-type update now runs in a
  post-frame callback instead of directly inside `build()`, preventing
  `notifyListeners()` from being dispatched while the widget tree is building.

## 1.0.3

- Bug fixes

## 1.0.2

- Novadrawer controller now opens that drawer on overlymode
