// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Configuration options for the NovaAppDrawer.
///
/// Controls behavior like responsiveness, gestures, pinning,
/// animation styles, and accessibility settings.
library;

import 'package:flutter/material.dart';

import '../animations/animation_config.dart';

/// Enumeration of supported drawer animation types.
///
/// Each type provides a distinct visual transition when the drawer
/// opens and closes.
enum NovaDrawerAnimationType {
  /// Drawer slides in from the side.
  slide,

  /// Drawer fades in/out with opacity transition.
  fade,

  /// Drawer scales up/down from a point.
  scale,

  /// Drawer rotates in/out.
  rotate,

  /// Drawer morphs between shapes.
  morph,

  /// Elastic bounce effect on open/close.
  elastic,

  /// Spring physics-based animation.
  spring,

  /// Shimmer/loading effect while transitioning.
  shimmer,

  /// Blur transition between states.
  blur,

  /// Gradient color transition effect.
  gradient,

  /// Floating drawer effect with shadow and elevation.
  floating,

  /// Floating drawer with bounce overshoot.
  floatingBounce,

  /// Circular reveal effect from an origin point.
  floatingReveal,

  /// Wave-like boundary reveal animation.
  wave,

  /// Parallax multi-layer depth effect.
  parallax,

  /// Curtain-style split reveal animation.
  curtain,
}

/// Enumeration of drawer display modes.
enum NovaDrawerDisplayMode {
  /// Standard overlay drawer that covers content.
  overlay,

  /// Drawer pushes content to the side.
  push,

  /// Drawer sits alongside content (persistent).
  side,

  /// Mini collapsed drawer showing only icons.
  mini,

  /// Automatically chooses mode based on screen size.
  auto,
}

/// Breakpoints for responsive layout transitions.
///
/// Defines the screen widths at which the drawer switches
/// between mobile, tablet, and desktop layouts.
class NovaDrawerBreakpoints {
  /// Creates [NovaDrawerBreakpoints] with custom values.
  const NovaDrawerBreakpoints({
    this.mobile = 600.0,
    this.tablet = 1024.0,
  });

  /// Maximum width for mobile layout. Screens wider than this
  /// but narrower than [tablet] use tablet layout.
  final double mobile;

  /// Maximum width for tablet layout. Screens wider use desktop layout.
  final double tablet;

  /// Default breakpoints matching Material Design guidelines.
  static const NovaDrawerBreakpoints standard = NovaDrawerBreakpoints();
}

/// Gesture control configuration for the drawer.
class NovaDrawerGestureConfig {
  /// Creates a [NovaDrawerGestureConfig].
  const NovaDrawerGestureConfig({
    this.enableSwipeToOpen = true,
    this.enableSwipeToClose = true,
    this.swipeEdgeWidth = 20.0,
    this.swipeSensitivity = 0.5,
    this.enableDragHandle = true,
    this.dragHandleColor,
  });

  /// Whether swipe-from-edge opens the drawer.
  final bool enableSwipeToOpen;

  /// Whether swipe gesture closes the drawer.
  final bool enableSwipeToClose;

  /// Width of the edge detection area for swipe-to-open (in logical pixels).
  final double swipeEdgeWidth;

  /// Sensitivity of swipe gestures (0.0 to 1.0).
  final double swipeSensitivity;

  /// Whether to show a visible drag handle.
  final bool enableDragHandle;

  /// Custom color for the drag handle.
  final Color? dragHandleColor;
}

/// Accessibility configuration for the drawer.
class NovaDrawerAccessibilityConfig {
  /// Creates a [NovaDrawerAccessibilityConfig].
  const NovaDrawerAccessibilityConfig({
    this.enableSemantics = true,
    this.enableFocusTraversal = true,
    this.enableScalableText = true,
    this.minimumTouchTarget = 48.0,
    this.announceOnOpen = true,
    this.announceOnClose = true,
    this.drawerLabel = 'Navigation drawer',
    this.closeButtonLabel = 'Close navigation drawer',
  });

  /// Whether to include semantic annotations for screen readers.
  final bool enableSemantics;

  /// Whether to enable keyboard focus traversal.
  final bool enableFocusTraversal;

  /// Whether text scales with system accessibility settings.
  final bool enableScalableText;

  /// Minimum touch target size in logical pixels (accessibility guideline).
  final double minimumTouchTarget;

  /// Whether to announce drawer opening to screen readers.
  final bool announceOnOpen;

  /// Whether to announce drawer closing to screen readers.
  final bool announceOnClose;

  /// Semantic label for the drawer container.
  final String drawerLabel;

  /// Semantic label for the close button.
  final String closeButtonLabel;
}

/// Configuration for auto-hide on scroll behavior.
class NovaDrawerAutoHideConfig {
  /// Creates a [NovaDrawerAutoHideConfig].
  const NovaDrawerAutoHideConfig({
    this.enabled = false,
    this.scrollThreshold = 50.0,
    this.hideDelay = Duration.zero,
    this.showDelay = const Duration(milliseconds: 300),
  });

  /// Whether auto-hide on scroll is enabled.
  final bool enabled;

  /// Minimum scroll delta to trigger hide/show.
  final double scrollThreshold;

  /// Delay before hiding the drawer after scroll starts.
  final Duration hideDelay;

  /// Delay before showing the drawer after scroll stops.
  final Duration showDelay;
}

/// Complete configuration for the NovaAppDrawer.
///
/// Combines all sub-configurations into a single object for easy
/// passing to the drawer widget.
///
/// Example:
/// ```dart
/// NovaDrawerConfig(
///   displayMode: NovaDrawerDisplayMode.auto,
///   animationType: NovaDrawerAnimationType.slide,
///   isPinnable: true,
///   gestureConfig: NovaDrawerGestureConfig(enableSwipeToOpen: true),
/// )
/// ```
class NovaDrawerConfig {
  /// Creates a [NovaDrawerConfig].
  const NovaDrawerConfig({
    this.displayMode = NovaDrawerDisplayMode.auto,
    this.animationType = NovaDrawerAnimationType.slide,
    this.animationConfig = const NovaDrawerAnimationConfig(),
    this.breakpoints = const NovaDrawerBreakpoints(),
    this.gestureConfig = const NovaDrawerGestureConfig(),
    this.accessibilityConfig = const NovaDrawerAccessibilityConfig(),
    this.autoHideConfig = const NovaDrawerAutoHideConfig(),
    this.isPinnable = true,
    this.isPinnedByDefault = false,
    this.showMiniOnCollapse = true,
    this.enableDynamicWidth = true,
    this.rtlSupport = true,
    this.closeOnItemTap = true,
    this.closeOnOutsideTap = true,
    this.showOverlay = true,
    this.overlayColor,
    this.overlayOpacity = 0.5,
    this.resizeToAvoidBottomInset = true,
    this.enableHoverExpand = false,
    this.hoverExpandDelay = const Duration(milliseconds: 500),
    this.enableAutoScrollToSelected = true,
    this.autoScrollDuration = const Duration(milliseconds: 380),
    this.autoScrollCurve = Curves.easeInOut,
  });

  /// How the drawer is displayed on screen.
  final NovaDrawerDisplayMode displayMode;

  /// Primary animation type for open/close transitions.
  final NovaDrawerAnimationType animationType;

  /// Detailed animation configuration.
  final NovaDrawerAnimationConfig animationConfig;

  /// Responsive breakpoints for layout switching.
  final NovaDrawerBreakpoints breakpoints;

  /// Gesture control settings.
  final NovaDrawerGestureConfig gestureConfig;

  /// Accessibility settings.
  final NovaDrawerAccessibilityConfig accessibilityConfig;

  /// Auto-hide on scroll settings.
  final NovaDrawerAutoHideConfig autoHideConfig;

  /// Whether the drawer can be pinned open on tablet/desktop.
  final bool isPinnable;

  /// Whether the drawer starts pinned open.
  final bool isPinnedByDefault;

  /// Whether to show mini drawer when collapsed on desktop/tablet.
  final bool showMiniOnCollapse;

  /// Whether drawer width adjusts dynamically based on content/screen.
  final bool enableDynamicWidth;

  /// Whether RTL language support is enabled.
  final bool rtlSupport;

  /// Whether to close the drawer when an item is tapped (mobile).
  final bool closeOnItemTap;

  /// Whether to close the drawer when tapping outside it.
  final bool closeOnOutsideTap;

  /// Whether to show a scrim/overlay behind the drawer.
  final bool showOverlay;

  /// Custom overlay color (defaults to black).
  final Color? overlayColor;

  /// Opacity of the background overlay (0.0 to 1.0).
  final double overlayOpacity;

  /// Whether the drawer resizes when the keyboard appears.
  final bool resizeToAvoidBottomInset;

  /// Whether the drawer auto-scrolls to the selected item when opened.
  ///
  /// When `true` (default), the drawer scroll position is animated to bring
  /// the currently selected item into the centre of the visible area each time
  /// the drawer transitions from closed → open. This is especially useful when
  /// there are many items (30+) and the user last tapped one near the bottom.
  final bool enableAutoScrollToSelected;

  /// Duration of the auto-scroll animation.
  final Duration autoScrollDuration;

  /// Curve applied to the auto-scroll animation.
  final Curve autoScrollCurve;

  /// Creates a copy of this config with the given fields replaced.
  NovaDrawerConfig copyWith({
    NovaDrawerDisplayMode? displayMode,
    NovaDrawerAnimationType? animationType,
    NovaDrawerAnimationConfig? animationConfig,
    NovaDrawerBreakpoints? breakpoints,
    NovaDrawerGestureConfig? gestureConfig,
    NovaDrawerAccessibilityConfig? accessibilityConfig,
    NovaDrawerAutoHideConfig? autoHideConfig,
    bool? isPinnable,
    bool? isPinnedByDefault,
    bool? showMiniOnCollapse,
    bool? enableDynamicWidth,
    bool? rtlSupport,
    bool? closeOnItemTap,
    bool? closeOnOutsideTap,
    bool? showOverlay,
    Color? overlayColor,
    double? overlayOpacity,
    bool? resizeToAvoidBottomInset,
    bool? enableHoverExpand,
    Duration? hoverExpandDelay,
    bool? enableAutoScrollToSelected,
    Duration? autoScrollDuration,
    Curve? autoScrollCurve,
  }) {
    return NovaDrawerConfig(
      displayMode: displayMode ?? this.displayMode,
      animationType: animationType ?? this.animationType,
      animationConfig: animationConfig ?? this.animationConfig,
      breakpoints: breakpoints ?? this.breakpoints,
      gestureConfig: gestureConfig ?? this.gestureConfig,
      accessibilityConfig: accessibilityConfig ?? this.accessibilityConfig,
      autoHideConfig: autoHideConfig ?? this.autoHideConfig,
      isPinnable: isPinnable ?? this.isPinnable,
      isPinnedByDefault: isPinnedByDefault ?? this.isPinnedByDefault,
      showMiniOnCollapse: showMiniOnCollapse ?? this.showMiniOnCollapse,
      enableDynamicWidth: enableDynamicWidth ?? this.enableDynamicWidth,
      rtlSupport: rtlSupport ?? this.rtlSupport,
      closeOnItemTap: closeOnItemTap ?? this.closeOnItemTap,
      closeOnOutsideTap: closeOnOutsideTap ?? this.closeOnOutsideTap,
      showOverlay: showOverlay ?? this.showOverlay,
      overlayColor: overlayColor ?? this.overlayColor,
      overlayOpacity: overlayOpacity ?? this.overlayOpacity,
      resizeToAvoidBottomInset:
          resizeToAvoidBottomInset ?? this.resizeToAvoidBottomInset,
      enableHoverExpand: enableHoverExpand ?? this.enableHoverExpand,
      hoverExpandDelay: hoverExpandDelay ?? this.hoverExpandDelay,
      enableAutoScrollToSelected:
          enableAutoScrollToSelected ?? this.enableAutoScrollToSelected,
      autoScrollDuration: autoScrollDuration ?? this.autoScrollDuration,
      autoScrollCurve: autoScrollCurve ?? this.autoScrollCurve,
    );
  }
}
