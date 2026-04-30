// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Navigation utilities for NovaDrawer.
///
/// Provides a router-agnostic helper for triggering route navigation
/// from drawer item tap handlers.
library;

import 'package:flutter/widgets.dart';

import '../controllers/drawer_controller.dart';
import '../models/body_router_page.dart';
import '../models/drawer_item.dart';

/// Creates an [NovaAppDrawer.onNavigate] callback that works together with
/// [NovaDrawerBodyRouter].
///
/// Navigation is suppressed (not forwarded to [external]) when either:
/// - The tapped item's route matches a [NovaDrawerPage.route] in [pages], OR
/// - The drawer controller's currently selected item ID matches a registered
///   [NovaDrawerPage.id] (covers pages that were registered without a route).
///
/// The second check works because [NovaDrawerController.selectItem] is always
/// called *before* [onNavigate], so the selected ID is already up-to-date
/// when the returned callback fires.
///
/// Every other route is delegated to [external].
///
/// Pass the returned callback to [NovaAppDrawer.onNavigate] and supply the
/// same [pages] list to [NovaDrawerBodyRouter] so both sides agree on which
/// routes are handled inline.
///
/// Returns `null` when [pages] is empty and [external] is `null` (i.e.
/// nothing to do), to avoid allocating an empty closure.
///
/// Example:
/// ```dart
/// final _pages = [
///   // With a route – matched by route string.
///   NovaDrawerPage(id: 'home', route: '/home', builder: (_) => const HomePage()),
///   // Without a route – matched by selected item ID.
///   NovaDrawerPage(id: 'units', builder: (_) => const UnitsPage()),
/// ];
///
/// NovaAppDrawer(
///   onNavigate: novaDrawerBodyNavigate(
///     pages: _pages,
///     external: (ctx, route) => GoRouter.of(ctx).go(route),
///   ),
///   ...
/// )
/// ```
void Function(BuildContext, String)? novaDrawerBodyNavigate({
  required List<NovaDrawerPage> pages,
  void Function(BuildContext, String)? external,
}) {
  if (pages.isEmpty) {
    return external;
  }

  // Routes explicitly declared on pages – fast O(1) lookup.
  final inlineRoutes = <String>{
    for (final p in pages)
      if (p.route != null) p.route!,
  };

  // All page IDs – used as fallback when a page has no route.
  final inlineIds = {for (final p in pages) p.id};

  return (BuildContext context, String route) {
    // 1. Suppress if the route is registered on an inline page.
    if (inlineRoutes.contains(route)) return;

    // 2. Suppress if the currently selected item ID belongs to an inline page.
    //    This handles NovaDrawerPage entries that were created without a route.
    //    selectItem() is always called before onNavigate, so the ID is current.
    try {
      final selectedId =
          NovaDrawerControllerProvider.read(context).selectedItemId;
      if (selectedId != null && inlineIds.contains(selectedId)) return;
    } catch (_) {
      // NovaDrawerControllerProvider.read asserts when the provider is not in
      // the widget tree (e.g. custom scaffolds or test environments).  Fall
      // through to external navigation rather than crashing in that edge case.
    }

    external?.call(context, route);
  };
}

/// Navigates to [item]'s route using [onNavigate] if provided, otherwise
/// falls back to [Navigator.pushNamed].
///
/// Does nothing when [item.route] is null.
void novaNavigateForItem(
  BuildContext context,
  NovaDrawerItem item,
  void Function(BuildContext context, String route)? onNavigate,
) {
  final route = item.route;
  if (route == null) return;
  if (onNavigate != null) {
    onNavigate(context, route);
  } else {
    Navigator.of(context).pushNamed(route);
  }
}
