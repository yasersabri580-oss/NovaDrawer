// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Scale animation for the AdvancedAppDrawer.
///
/// Provides scaling transitions that grow or shrink the drawer
/// and individual items with configurable origins and curves.
library;

import 'package:flutter/material.dart';

/// A widget that applies a scale animation to its child.
///
/// The child scales from [beginScale] to [endScale], optionally
/// combined with a fade effect for smoother visual transitions.
///
/// Example:
/// ```dart
/// ScaleDrawerAnimation(
///   animation: animationController,
///   child: drawerContent,
///   beginScale: 0.8,
///   alignment: Alignment.centerLeft,
/// )
/// ```
class ScaleDrawerAnimation extends StatelessWidget {
  /// Creates a [ScaleDrawerAnimation].
  const ScaleDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.beginScale = 0.0,
    this.endScale = 1.0,
    this.alignment = Alignment.center,
    this.curve = Curves.easeOutBack,
    this.includeFade = true,
  });

  /// The animation driving the scale transition.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Starting scale factor.
  final double beginScale;

  /// Ending scale factor.
  final double endScale;

  /// Alignment of the scale origin point.
  final Alignment alignment;

  /// Easing curve for the scale animation.
  final Curve curve;

  /// Whether to include a fade effect alongside scaling.
  final bool includeFade;

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = Tween<double>(
      begin: beginScale,
      end: endScale,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: curve,
    ));

    Widget result = ScaleTransition(
      scale: scaleAnimation,
      alignment: alignment,
      child: child,
    );

    if (includeFade) {
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: Interval(0.0, 0.5, curve: curve),
      );
      result = FadeTransition(
        opacity: fadeAnimation,
        child: result,
      );
    }

    return result;
  }
}

/// Scale animation with staggered timing for list items.
class StaggeredScaleAnimation extends StatelessWidget {
  /// Creates a [StaggeredScaleAnimation].
  const StaggeredScaleAnimation({
    super.key,
    required this.animation,
    required this.child,
    required this.index,
    this.totalItems = 10,
    this.beginScale = 0.5,
    this.alignment = Alignment.centerLeft,
    this.curve = Curves.easeOutBack,
  });

  /// The parent animation driving all items.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Index in the stagger sequence.
  final int index;

  /// Total number of staggered items.
  final int totalItems;

  /// Starting scale factor.
  final double beginScale;

  /// Alignment of the scale origin.
  final Alignment alignment;

  /// Easing curve for the scale.
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

    final scaleAnimation = Tween<double>(
      begin: beginScale,
      end: 1.0,
    ).animate(intervalAnimation);

    return FadeTransition(
      opacity: intervalAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        alignment: alignment,
        child: child,
      ),
    );
  }
}

/// A bounce-scale animation that overshoots before settling.
class BounceScaleAnimation extends StatelessWidget {
  /// Creates a [BounceScaleAnimation].
  const BounceScaleAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.alignment = Alignment.center,
  });

  /// The animation driving the bounce.
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Scale origin alignment.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.elasticOut,
    ));

    return ScaleTransition(
      scale: scaleAnimation,
      alignment: alignment,
      child: child,
    );
  }
}
