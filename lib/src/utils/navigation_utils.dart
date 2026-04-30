// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Navigation utilities for NovaDrawer.
///
/// Provides a router-agnostic helper for triggering route navigation
/// from drawer item tap handlers.
library;

import 'package:flutter/widgets.dart';

import '../models/body_router_page.dart';
import '../models/drawer_item.dart';

/// Creates an [NovaAppDrawer.onNavigate] callback that works together with
/// [NovaDrawerBodyRouter].
///
/// Routes that belong to a registered [NovaDrawerPage] (i.e. pages with a
/// non-null [NovaDrawerPage.route] that matches the tapped item's route) are
/// *not* forwarded to the [external] router, because [NovaDrawerBodyRouter]
/// already shows them inline.  Every other route is delegated to [external].
///
/// Pass the returned callback to [NovaAppDrawer.onNavigate] and supply the
/// same [pages] list to [NovaDrawerBodyRouter] so both sides agree on which
/// routes are handled inline.
///
/// Returns `null` when [pages] has no routes and [external] is `null` (i.e.
/// nothing to do), to avoid allocating an empty closure.
///
/// Example:
/// ```dart
/// final _pages = [
///   NovaDrawerPage(id: 'home', route: '/home', builder: (_) => const HomePage()),
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
  // Collect all routes that are handled inline by NovaDrawerBodyRouter.
  final inlineRoutes = <String>{
    for (final p in pages)
      if (p.route != null) p.route!,
  };

  if (inlineRoutes.isEmpty) {
    // No inline routes to intercept – just return the external callback as-is.
    return external;
  }

  return (BuildContext context, String route) {
    // Only delegate to the external router for routes not handled inline.
    if (!inlineRoutes.contains(route)) {
      external?.call(context, route);
    }
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
