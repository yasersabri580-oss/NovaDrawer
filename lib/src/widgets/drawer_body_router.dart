// Copyright (c) 2026 NovaDrawer Contributors
// Licensed under the MIT License.

/// Inline body router widget for [NovaDrawerScaffold].
///
/// Renders drawer navigation targets inside the scaffold body using an
/// [IndexedStack], so the drawer, app bar, and bottom navigation bar
/// remain visible while the content area changes.
library;

import 'package:flutter/widgets.dart';

import '../controllers/drawer_controller.dart';
import '../models/body_router_page.dart';

/// A body widget for [NovaDrawerScaffold] that hosts navigation pages
/// inline – without pushing them onto the navigator stack.
///
/// When the user taps a drawer item whose [NovaDrawerItem.id] matches a
/// registered [NovaDrawerPage], [NovaDrawerBodyRouter] swaps the visible
/// content area to show that page.  The drawer, app bar, and any bottom
/// navigation bar supplied to [NovaDrawerScaffold] remain unchanged.
///
/// Pages with [NovaDrawerPage.keepAlive] set to `true` preserve their
/// widget state across switches (like tabs in a [TabBarView]).  Pages with
/// `keepAlive` set to `false` are rebuilt from scratch each time they
/// become active, discarding the previous state.
///
/// Lazy loading ensures that a page widget is not built until the first
/// time it becomes active, keeping startup fast regardless of how many
/// pages are registered.
///
/// **Pair with [novaDrawerBodyNavigate]** on [NovaAppDrawer.onNavigate] to
/// prevent routes covered by registered pages from also being forwarded to
/// the external router.
///
/// **Dependency injection (flutter_bloc / Provider / get_it)**
///
/// Pages built here are rendered *outside* the GoRouter (or Navigator 2.0)
/// route tree.  A `BlocProvider` or `Provider` that your `GoRoute.builder`
/// normally wraps the page with is **not** an ancestor of the builder passed
/// to [NovaDrawerPage].  Accessing that bloc via `context.read<MyBloc>()`
/// inside the page will throw a `ProviderNotFoundException`.
///
/// Always provide the required blocs/providers directly in the
/// [NovaDrawerPage.builder]:
///
/// ```dart
/// NovaDrawerPage(
///   id: 'accessibility',
///   route: '/admin/accessibility',
///   builder: (context) => BlocProvider(
///     create: (_) => sl<AccessibilityBloc>(),
///     child: const AccessibilityListPage(),
///   ),
/// )
/// ```
///
/// ## Example
///
/// ```dart
/// // 1. Declare pages (reuse the same list in both places).
/// late final _pages = [
///   NovaDrawerPage(
///     id: 'accounting_home',
///     route: '/accounting/home',
///     // ✅ Wrap with the same BlocProvider used in the GoRoute.
///     builder: (_) => BlocProvider(
///       create: (_) => sl<AccountingBloc>(),
///       child: const AccountingHomePage(),
///     ),
///   ),
///   NovaDrawerPage(
///     id: 'settings',
///     route: '/settings',
///     builder: (_) => const SettingsPage(),  // no bloc needed — plain widget
///     keepAlive: false,
///   ),
/// ];
///
/// // 2. In NovaAppDrawer – suppress external navigation for inline pages.
/// NovaAppDrawer(
///   onNavigate: novaDrawerBodyNavigate(
///     pages: _pages,
///     external: (ctx, route) => GoRouter.of(ctx).go(route),
///   ),
///   ...
/// )
///
/// // 3. As the scaffold body – the inline page host.
/// body: NovaDrawerBodyRouter(
///   controller: _drawerController,
///   pages: _pages,
///   fallback: _buildTabsBody(),   // shown when no registered page is active
/// ),
/// ```
class NovaDrawerBodyRouter extends StatefulWidget {
  /// Creates a [NovaDrawerBodyRouter].
  const NovaDrawerBodyRouter({
    super.key,
    required this.controller,
    required this.pages,
    this.fallback,
  });

  /// The drawer controller whose [NovaDrawerController.selectedItemId]
  /// determines which page is active.
  final NovaDrawerController controller;

  /// Pages that can be shown inline.
  ///
  /// Order is preserved internally for stable [IndexedStack] indexing.
  /// Changing the list at runtime (e.g. in [State.didUpdateWidget]) is
  /// supported; previously-visited pages are discarded and rebuilt.
  final List<NovaDrawerPage> pages;

  /// Widget shown when no registered page matches the current selection.
  ///
  /// Typically the bottom-navigation tab body (your [IndexedStack] with
  /// tabs).  Defaults to an invisible [SizedBox] when omitted.
  final Widget? fallback;

  @override
  State<NovaDrawerBodyRouter> createState() => _NovaDrawerBodyRouterState();
}

class _NovaDrawerBodyRouterState extends State<NovaDrawerBodyRouter> {
  // Ordered list of page IDs that have been activated at least once.
  // Stable ordering is required so that IndexedStack indices do not shift.
  final List<String> _visitedOrder = [];

  // The currently active page ID, or null when the fallback is shown.
  String? _currentId;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
    _syncWithController(forceRebuild: false);
  }

  @override
  void didUpdateWidget(NovaDrawerBodyRouter old) {
    super.didUpdateWidget(old);

    if (widget.controller != old.controller) {
      old.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }

    if (!_pagesEqual(widget.pages, old.pages)) {
      // Pages list changed – clear visited tracking and re-sync.
      _visitedOrder.clear();
      _currentId = null;
      _syncWithController(forceRebuild: false);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  // ── Controller listener ────────────────────────────────────────────

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() => _syncWithController(forceRebuild: true));
  }

  /// Updates [_currentId] and [_visitedOrder] based on the controller's
  /// current selection.  When [forceRebuild] is false, the call is
  /// permitted during [initState] (before the first [build]).
  void _syncWithController({required bool forceRebuild}) {
    final selectedId = widget.controller.selectedItemId;
    final page = _findPage(selectedId);

    if (page == null) {
      // No registered page matches → show fallback.
      _maybeEvictCurrentPage();
      _currentId = null;
      return;
    }

    if (_currentId == page.id) return; // Already showing this page.

    // Evict the outgoing page when it does not want to be kept alive.
    _maybeEvictCurrentPage();

    // Activate the incoming page (lazy first-build).
    if (!_visitedOrder.contains(page.id)) {
      _visitedOrder.add(page.id);
    }
    _currentId = page.id;
  }

  /// Removes the current page from [_visitedOrder] when it is not keepAlive,
  /// causing it to be rebuilt fresh the next time it becomes active.
  void _maybeEvictCurrentPage() {
    final oldPage = _findPage(_currentId);
    if (oldPage != null && !oldPage.keepAlive) {
      _visitedOrder.remove(oldPage.id);
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────

  NovaDrawerPage? _findPage(String? id) {
    if (id == null) return null;
    for (final p in widget.pages) {
      if (p.id == id) return p;
    }
    return null;
  }

  static bool _pagesEqual(
    List<NovaDrawerPage> a,
    List<NovaDrawerPage> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].id != b[i].id) return false;
    }
    return true;
  }

  // ── Build ──────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Build ordered list of visited pages for stable IndexedStack slots.
    final visitedPages = <NovaDrawerPage>[];
    for (final id in _visitedOrder) {
      final page = _findPage(id);
      if (page != null) visitedPages.add(page);
    }

    // Compute the active IndexedStack index.
    // Index 0 is always the fallback.
    int activeIndex = 0;
    if (_currentId != null) {
      final pos = visitedPages.indexWhere((p) => p.id == _currentId);
      if (pos >= 0) activeIndex = pos + 1;
    }

    return IndexedStack(
      index: activeIndex,
      children: [
        // Slot 0: fallback (tabs / empty state)
        widget.fallback ?? const SizedBox.shrink(),

        // Slots 1+: lazily-constructed pages (in visit order)
        for (final page in visitedPages)
          _NovaKeepAlivePage(
            key: ValueKey(page.id),
            wantKeepAlive: page.keepAlive,
            builder: page.builder,
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Internal keep-alive wrapper
// ---------------------------------------------------------------------------

/// Internal page wrapper that opts into [AutomaticKeepAliveClientMixin]
/// when [wantKeepAlive] is `true`, preventing Flutter from discarding the
/// widget's state while it is hidden in the [IndexedStack].
class _NovaKeepAlivePage extends StatefulWidget {
  const _NovaKeepAlivePage({
    super.key,
    required this.wantKeepAlive,
    required this.builder,
  });

  final bool wantKeepAlive;
  final WidgetBuilder builder;

  @override
  State<_NovaKeepAlivePage> createState() => _NovaKeepAlivePageState();
}

class _NovaKeepAlivePageState extends State<_NovaKeepAlivePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => widget.wantKeepAlive;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required by AutomaticKeepAliveClientMixin.
    return widget.builder(context);
  }
}
