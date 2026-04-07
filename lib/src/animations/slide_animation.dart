// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Slide animation for the AdvancedAppDrawer.
///
/// Provides a horizontal or vertical slide transition that moves
/// the drawer in from the edge of the screen.
library;

import 'package:flutter/material.dart';

/// A widget that applies a sliding animation to its child.
///
/// The child slides in from a configurable [beginOffset] to its
/// final position, driven by the provided [animation].
///
/// Example:
/// ```dart
/// SlideDrawerAnimation(
///   animation: animationController,
///   beginOffset: Offset(-1.0, 0.0),
///   child: drawerContent,
/// )
/// ```
class SlideDrawerAnimation extends StatelessWidget {
  /// Creates a [SlideDrawerAnimation].
  const SlideDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.beginOffset = const Offset(-1.0, 0.0),
    this.endOffset = Offset.zero,
    this.curve = Curves.easeInOutCubic,
  });

  /// The animation that drives the slide transition.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Starting offset as a fraction of the child's size.
  /// Defaults to sliding in from the left.
  final Offset beginOffset;

  /// Ending offset. Defaults to the child's natural position.
  final Offset endOffset;

  /// Easing curve applied to the slide animation.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: curve,
    ));

    return SlideTransition(
      position: slideAnimation,
      child: child,
    );
  }
}

/// A variant that slides individual items with staggered timing.
///
/// Each child slides in with a delay based on its [index],
/// creating a cascading entrance effect.
class StaggeredSlideAnimation extends StatelessWidget {
  /// Creates a [StaggeredSlideAnimation].
  const StaggeredSlideAnimation({
    super.key,
    required this.animation,
    required this.child,
    required this.index,
    this.totalItems = 10,
    this.beginOffset = const Offset(-0.5, 0.0),
    this.curve = Curves.easeOutCubic,
  });

  /// The parent animation driving all items.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Index of this item in the stagger sequence.
  final int index;

  /// Total number of items being staggered.
  final int totalItems;

  /// Starting offset for the slide.
  final Offset beginOffset;

  /// Easing curve for each item's slide.
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

    final slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(intervalAnimation);

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(intervalAnimation);

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: child,
      ),
    );
  }
}
