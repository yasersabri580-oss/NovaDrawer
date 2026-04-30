// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

/// Model for pages managed by [NovaDrawerBodyRouter].
///
/// Each [NovaDrawerPage] maps a [NovaDrawerItem.id] to a widget builder,
/// enabling the drawer to display navigation targets inline inside the
/// scaffold body instead of pushing them onto the navigator stack.
library;

import 'package:flutter/widgets.dart';

/// Describes a page that [NovaDrawerBodyRouter] renders inline in the
/// scaffold body when the matching drawer item is selected.
///
/// - [id] **must** match the corresponding [NovaDrawerItem.id] so that
///   [NovaDrawerBodyRouter] can detect when the item is selected.
/// - [route] is optional but recommended when the [NovaDrawerItem] also
///   carries a route string.  Provide it so that [novaDrawerBodyNavigate]
///   can suppress external-router navigation for this page.
/// - [keepAlive] controls whether the page's widget subtree is preserved
///   while another page is active.  `true` (the default) retains the full
///   widget state across switches.  `false` discards the subtree and
///   rebuilds it from scratch the next time the page becomes active.
///
/// Example:
/// ```dart
/// NovaDrawerPage(
///   id: 'accounting_home',
///   route: '/accounting/home',
///   builder: (_) => const AccountingHomePage(),
/// )
/// ```
class NovaDrawerPage {
  /// Creates a [NovaDrawerPage].
  const NovaDrawerPage({
    required this.id,
    this.route,
    required this.builder,
    this.keepAlive = true,
  });

  /// Item identifier – must equal the [NovaDrawerItem.id] of the
  /// corresponding drawer entry.
  final String id;

  /// Optional route string that matches [NovaDrawerItem.route].
  ///
  /// When provided, [novaDrawerBodyNavigate] will intercept navigation
  /// requests for this route and prevent them from being forwarded to the
  /// external router, since the page is already shown inline.
  ///
  /// When omitted, [novaDrawerBodyNavigate] falls back to matching by
  /// [id]: if the drawer controller's currently selected item ID equals
  /// this page's [id], external navigation is still suppressed.  Omitting
  /// [route] is safe as long as the corresponding [NovaDrawerItem.id]
  /// matches this page's [id].
  final String? route;

  /// Builder that produces the page widget.
  final WidgetBuilder builder;

  /// Whether the page's widget subtree is preserved while the page is
  /// not visible.
  ///
  /// - `true` (default): the page widget stays in the tree (via
  ///   [AutomaticKeepAliveClientMixin]) and its state is restored
  ///   instantly when the user returns to it.
  /// - `false`: the widget subtree is removed from the tree when the page
  ///   is deactivated and is rebuilt from scratch the next time it becomes
  ///   active, trading memory for a fresh initial state.
  final bool keepAlive;
}
