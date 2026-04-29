// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Navigation utilities for NovaDrawer.
///
/// Provides a router-agnostic helper for triggering route navigation
/// from drawer item tap handlers.
library;

import 'package:flutter/widgets.dart';

import '../models/drawer_item.dart';

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
