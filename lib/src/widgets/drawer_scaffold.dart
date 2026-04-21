// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Drawer scaffold widget for the NovaAppDrawer.
///
/// A responsive scaffold that automatically manages drawer display
/// mode based on screen size: overlay on mobile, side/push on
/// tablet/desktop, with optional mini-drawer collapse.
library;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/drawer_item.dart';
import '../models/drawer_theme.dart';
import '../models/drawer_config.dart';
import '../controllers/drawer_controller.dart';
import '../utils/responsive_utils.dart';
import 'advanced_app_drawer.dart';
import 'mini_drawer.dart';

/// A scaffold that integrates the [NovaAppDrawer] with responsive
/// layout management.
///
/// Automatically switches between overlay, push, and side display
/// modes based on screen size and configuration. Handles gesture
/// controls, animations, and state management.
///
/// Example:
/// ```dart
/// NovaDrawerScaffold(
///   controller: drawerController,
///   drawer: NovaAppDrawer(
///     controller: drawerController,
///     sections: mySections,
///   ),
///   body: MyPageContent(),
///   appBar: AppBar(title: Text('My App')),
/// )
/// ```
class NovaDrawerScaffold extends StatefulWidget {
  /// Creates a [NovaDrawerScaffold].
  const NovaDrawerScaffold({
    super.key,
    required this.controller,
    required this.drawer,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.theme,
    this.config = const NovaDrawerConfig(),
    this.miniDrawerHeader,
    this.miniDrawerFooter,
    this.miniDrawerItems,
    this.miniDrawerSections,
    this.onItemTap,
    this.scaffoldKey,
    this.backgroundColor,
  });

  /// Controller managing drawer state.
  final NovaDrawerController controller;

  /// The full drawer widget.
  final NovaAppDrawer drawer;

  /// The main page content.
  final Widget body;

  /// Optional app bar.
  final PreferredSizeWidget? appBar;

  /// Optional floating action button.
  final Widget? floatingActionButton;

  /// FAB location.
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// Optional bottom navigation bar.
  final Widget? bottomNavigationBar;

  /// Theme overrides.
  final NovaDrawerTheme? theme;

  /// Configuration.
  final NovaDrawerConfig config;

  /// Header for the mini drawer.
  final Widget? miniDrawerHeader;

  /// Footer for the mini drawer.
  final Widget? miniDrawerFooter;

  /// Items for the mini drawer (defaults to drawer items).
  final List<NovaDrawerItem>? miniDrawerItems;

  /// Sections for the mini drawer.
  final List<NovaDrawerSectionData>? miniDrawerSections;

  /// Callback when a drawer item is tapped.
  final void Function(NovaDrawerItem item)? onItemTap;

  /// Scaffold key for controlling the default scaffold drawer.
  final GlobalKey<ScaffoldState>? scaffoldKey;

  /// Background color for the scaffold.
  final Color? backgroundColor;

  @override
  State<NovaDrawerScaffold> createState() => _NovaDrawerScaffoldState();
}

class _NovaDrawerScaffoldState extends State<NovaDrawerScaffold>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerAnimationController;
  late Animation<double> _drawerAnimation;
  late GlobalKey<ScaffoldState> _scaffoldKey;
  NovaDeviceType? _lastDeviceType;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = widget.scaffoldKey ?? GlobalKey<ScaffoldState>();
    _drawerAnimationController = AnimationController(
      vsync: this,
      duration: widget.config.animationConfig.duration,
      reverseDuration: widget.config.animationConfig.effectiveReverseDuration,
    );
    _drawerAnimation = CurvedAnimation(
      parent: _drawerAnimationController,
      curve: widget.config.animationConfig.curve,
      reverseCurve: widget.config.animationConfig.effectiveReverseCurve,
    );

    // Initialize controller state
    if (widget.config.isPinnedByDefault) {
      widget.controller.pin();
    }

    // Listen to controller changes
    widget.controller.addListener(_onControllerChanged);

    // Set initial animation state
    if (widget.controller.isOpen) {
      _drawerAnimationController.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(NovaDrawerScaffold oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _drawerAnimationController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;

    final mediaQuery = MediaQuery.maybeOf(context);
    if (mediaQuery != null) {
      final deviceType = NovaResponsiveUtils.getDeviceType(
        mediaQuery.size.width,
        widget.config.breakpoints,
      );
      final displayMode = NovaResponsiveUtils.resolveDisplayMode(
        widget.config.displayMode,
        deviceType,
      );

      if (displayMode == NovaDrawerDisplayMode.overlay) {
        final scaffoldState = _scaffoldKey.currentState;
        if (scaffoldState == null) return;

        final isRtl = Directionality.of(context) == TextDirection.rtl;
        final isDrawerActuallyOpen = isRtl
            ? scaffoldState.isEndDrawerOpen
            : scaffoldState.isDrawerOpen;

        if (widget.controller.isOpen && !isDrawerActuallyOpen) {
          if (isRtl) {
            scaffoldState.openEndDrawer();
          } else {
            scaffoldState.openDrawer();
          }
        } else if (!widget.controller.isOpen && isDrawerActuallyOpen) {
          Navigator.of(context).maybePop();
        }
        return;
      }
    }

    if (widget.controller.isOpen) {
      _drawerAnimationController.forward();
    } else {
      _drawerAnimationController.reverse();
    }

    // Rebuild so that side/mini layouts pick up the new controller state
    // (e.g. isOpen, isPinned, isMini) since they read controller fields
    // directly inside build() rather than through AnimatedBuilder.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final deviceType = NovaResponsiveUtils.getDeviceType(
      screenWidth,
      widget.config.breakpoints,
    );

    // Update controller with current device type after the build phase to
    // avoid calling notifyListeners() while the widget tree is being built.
    if (_lastDeviceType != deviceType) {
      _lastDeviceType = deviceType;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.controller.updateDeviceType(deviceType);
        }
      });
    }

    final themeData = Theme.of(context);
    final drawerTheme = widget.theme?.resolve(themeData) ??
        const NovaDrawerTheme().resolve(themeData);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final displayMode = NovaResponsiveUtils.resolveDisplayMode(
      widget.config.displayMode,
      deviceType,
    );

    return NovaDrawerControllerProvider(
      controller: widget.controller,
      child: NovaResponsiveDrawerData(
        deviceType: deviceType,
        drawerWidth: NovaResponsiveUtils.getDrawerWidth(deviceType, drawerTheme),
        miniDrawerWidth: NovaResponsiveUtils.getMiniDrawerWidth(drawerTheme),
        isDrawerOpen: widget.controller.isOpen,
        isPinned: widget.controller.isPinned,
        displayMode: widget.config.displayMode,
        child: _buildLayout(
          deviceType,
          displayMode,
          drawerTheme,
          isRtl,
        ),
      ),
    );
  }

  Widget _buildLayout(
    NovaDeviceType deviceType,
    NovaDrawerDisplayMode displayMode,
    NovaDrawerTheme drawerTheme,
    bool isRtl,
  ) {
    switch (displayMode) {
      case NovaDrawerDisplayMode.overlay:
        return _buildOverlayLayout(drawerTheme, isRtl);
      case NovaDrawerDisplayMode.push:
        return _buildPushLayout(drawerTheme, isRtl);
      case NovaDrawerDisplayMode.side:
        return _buildSideLayout(drawerTheme, isRtl);
      case NovaDrawerDisplayMode.mini:
        return _buildMiniLayout(drawerTheme, isRtl);
      case NovaDrawerDisplayMode.auto:
        // This shouldn't happen after resolveDisplayMode
        return _buildOverlayLayout(drawerTheme, isRtl);
    }
  }

  /// Overlay mode: drawer slides over content (mobile).
  Widget _buildOverlayLayout(NovaDrawerTheme drawerTheme, bool isRtl) {
    return Scaffold(
      key: _scaffoldKey,
      onDrawerChanged: _handleScaffoldDrawerChanged,
      onEndDrawerChanged: _handleScaffoldDrawerChanged,
      appBar: widget.appBar,
      body: _buildGestureDetector(
        child: widget.body,
        isRtl: isRtl,
      ),
      drawer: isRtl ? null : widget.drawer,
      endDrawer: isRtl ? widget.drawer : null,
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: widget.bottomNavigationBar,
      backgroundColor: widget.backgroundColor,
    );
  }

  void _handleScaffoldDrawerChanged(bool isOpened) {
    if (isOpened) {
      if (!widget.controller.isOpen) {
        widget.controller.open();
      }
      return;
    }

    if (widget.controller.isOpen) {
      widget.controller.close();
    }
  }

  /// Push mode: drawer pushes content aside (tablet).
  Widget _buildPushLayout(NovaDrawerTheme drawerTheme, bool isRtl) {
    final drawerWidth = NovaResponsiveUtils.getDrawerWidth(
      widget.controller.deviceType,
      drawerTheme,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.appBar,
      body: AnimatedBuilder(
        animation: _drawerAnimation,
        builder: (context, child) {
          final slideAmount = drawerWidth * _drawerAnimation.value;

          return Stack(
            children: [
              // Main content - slides with drawer
              AnimatedPositioned(
                duration: Duration.zero,
                left: isRtl ? 0 : slideAmount,
                right: isRtl ? slideAmount : 0,
                top: 0,
                bottom: 0,
                child: widget.body,
              ),

              // Overlay scrim
              if (_drawerAnimation.value > 0 && widget.config.showOverlay)
                Positioned.fill(
                  child: GestureDetector(
                    onTap: widget.config.closeOnOutsideTap
                        ? () => widget.controller.close()
                        : null,
                    child: ColoredBox(
                      color: (widget.config.overlayColor ?? Colors.black)
                          .withAlpha(
                        (_drawerAnimation.value *
                                widget.config.overlayOpacity *
                                255)
                            .round(),
                      ),
                    ),
                  ),
                ),

              // Drawer
              Positioned(
                left: isRtl ? null : 0,
                right: isRtl ? 0 : null,
                top: 0,
                bottom: 0,
                width: drawerWidth,
                child: _drawerAnimation.value > 0
                    ? widget.drawer
                    : const SizedBox.shrink(),
              ),
            ],
          );
        },
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: widget.bottomNavigationBar,
      backgroundColor: widget.backgroundColor,
    );
  }

  /// Side mode: drawer sits alongside content (desktop).
  Widget _buildSideLayout(NovaDrawerTheme drawerTheme, bool isRtl) {
    final drawerWidth = NovaResponsiveUtils.getDrawerWidth(
      widget.controller.deviceType,
      drawerTheme,
    );
    final miniWidth = NovaResponsiveUtils.getMiniDrawerWidth(drawerTheme);
    final isOpen = widget.controller.isOpen || widget.controller.isPinned;
    final showMini = !isOpen && widget.config.showMiniOnCollapse;

    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.appBar,
      body: Row(
        children: [
          // Drawer or mini drawer
          AnimatedContainer(
            duration: widget.config.animationConfig.duration,
            curve: widget.config.animationConfig.curve,
            width: isOpen
                ? drawerWidth
                : showMini
                    ? miniWidth
                    : 0,
            child: isOpen
                ? widget.drawer
                : showMini
                    ? _buildMiniDrawer(drawerTheme)
                    : const SizedBox.shrink(),
          ),

          // Main content
          Expanded(child: widget.body),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: widget.bottomNavigationBar,
      backgroundColor: widget.backgroundColor,
    );
  }

  /// Mini mode: always shows collapsed drawer.
  Widget _buildMiniLayout(NovaDrawerTheme drawerTheme, bool isRtl) {
    final drawerWidth = NovaResponsiveUtils.getDrawerWidth(
      widget.controller.deviceType,
      drawerTheme,
    );
    final miniWidth = NovaResponsiveUtils.getMiniDrawerWidth(drawerTheme);
    final isExpanded = widget.controller.isOpen;

    return Scaffold(
      key: _scaffoldKey,
      appBar: widget.appBar,
      body: Row(
        children: [
          AnimatedContainer(
            duration: widget.config.animationConfig.duration,
            curve: widget.config.animationConfig.curve,
            width: isExpanded ? drawerWidth : miniWidth,
            child: isExpanded
                ? widget.drawer
                : _buildMiniDrawer(drawerTheme),
          ),
          Expanded(child: widget.body),
        ],
      ),
      floatingActionButton: widget.floatingActionButton,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      bottomNavigationBar: widget.bottomNavigationBar,
      backgroundColor: widget.backgroundColor,
    );
  }

  Widget _buildMiniDrawer(NovaDrawerTheme drawerTheme) {
    return NovaDrawerControllerProvider(
      controller: widget.controller,
      child: NovaMiniDrawer(
        items: widget.miniDrawerItems ?? widget.drawer.items,
        sections: widget.miniDrawerSections ?? widget.drawer.sections,
        header: widget.miniDrawerHeader,
        footer: widget.miniDrawerFooter,
        onItemTap: widget.onItemTap,
        onExpandRequest: () => widget.controller.open(),
        theme: widget.theme,
        // Use the drawer's config so that settings like enableHoverExpand
        // and hoverExpandDelay configured on the NovaAppDrawer are honoured.
        config: widget.drawer.config,
      ),
    );
  }

  Widget _buildGestureDetector({
    required Widget child,
    required bool isRtl,
  }) {
    final gestureConfig = widget.config.gestureConfig;
    if (!gestureConfig.enableSwipeToOpen) return child;

    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final delta = details.primaryDelta ?? 0;
        final threshold = gestureConfig.swipeSensitivity * 10;

        if (isRtl) {
          if (delta < -threshold && !widget.controller.isOpen) {
            widget.controller.open();
          } else if (delta > threshold && widget.controller.isOpen) {
            widget.controller.close();
          }
        } else {
          if (delta > threshold && !widget.controller.isOpen) {
            widget.controller.open();
          } else if (delta < -threshold && widget.controller.isOpen) {
            widget.controller.close();
          }
        }
      },
      child: child,
    );
  }
}
