// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Fade animation for the NovaAppDrawer.
///
/// Provides opacity-based transitions for the drawer and its items.
library;

import 'package:flutter/material.dart';

/// A widget that applies a fade-in/out animation to its child.
///
/// Example:
/// ```dart
/// NovaFadeDrawerAnimation(
///   animation: animationController,
///   child: drawerContent,
/// )
/// ```
class NovaFadeDrawerAnimation extends StatelessWidget {
  /// Creates a [NovaFadeDrawerAnimation].
  const NovaFadeDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.curve = Curves.easeInOut,
  });

  /// The animation driving the opacity transition.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Easing curve for the fade.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }
}

/// A fade animation with staggered timing for list items.
///
/// Items fade in sequentially based on their [index].
class NovaStaggeredFadeAnimation extends StatelessWidget {
  /// Creates a [NovaStaggeredFadeAnimation].
  const NovaStaggeredFadeAnimation({
    super.key,
    required this.animation,
    required this.child,
    required this.index,
    this.totalItems = 10,
    this.curve = Curves.easeIn,
  });

  /// The parent animation driving all items.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Index of this item in the stagger sequence.
  final int index;

  /// Total number of items being staggered.
  final int totalItems;

  /// Easing curve for each item's fade.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final itemCount = totalItems.clamp(1, 100);
    final start = (index / itemCount).clamp(0.0, 0.8);
    final end = ((index + 1) / itemCount).clamp(start + 0.05, 1.0);

    final intervalAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(start, end, curve: curve),
    );

    return FadeTransition(
      opacity: intervalAnimation,
      child: child,
    );
  }
}

/// A crossfade animation that blends between two child widgets.
class CrossNovaFadeDrawerAnimation extends StatelessWidget {
  /// Creates a [CrossNovaFadeDrawerAnimation].
  const CrossNovaFadeDrawerAnimation({
    super.key,
    required this.animation,
    required this.firstChild,
    required this.secondChild,
    this.curve = Curves.easeInOut,
  });

  /// The animation controlling the crossfade (0.0 = first, 1.0 = second).
  final Animation<double> animation;

  /// The widget shown when animation value is near 0.
  final Widget firstChild;

  /// The widget shown when animation value is near 1.
  final Widget secondChild;

  /// Easing curve for the crossfade.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, _) {
        return Stack(
          children: [
            Opacity(
              opacity: (1.0 - curvedAnimation.value).clamp(0.0, 1.0),
              child: firstChild,
            ),
            Opacity(
              opacity: curvedAnimation.value.clamp(0.0, 1.0),
              child: secondChild,
            ),
          ],
        );
      },
    );
  }
}
