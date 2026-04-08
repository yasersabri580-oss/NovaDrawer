// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Rotate animation for the NovaAppDrawer.
///
/// Provides rotation transitions for the drawer and items,
/// with configurable angles and origin points.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A widget that applies a rotation animation to its child.
///
/// Rotates from [beginAngle] to [endAngle] (in radians) around
/// the specified [alignment] point.
///
/// Example:
/// ```dart
/// NovaRotateDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   beginAngle: -math.pi / 4,
/// )
/// ```
class NovaRotateDrawerAnimation extends StatelessWidget {
  /// Creates a [NovaRotateDrawerAnimation].
  const NovaRotateDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.beginAngle = -math.pi / 12,
    this.endAngle = 0.0,
    this.alignment = Alignment.centerLeft,
    this.curve = Curves.easeOutCubic,
    this.includeFade = true,
    this.includeSlide = false,
  });

  /// The animation driving the rotation.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Starting rotation angle in radians.
  final double beginAngle;

  /// Ending rotation angle in radians.
  final double endAngle;

  /// Alignment of the rotation origin.
  final Alignment alignment;

  /// Easing curve for the rotation.
  final Curve curve;

  /// Whether to include a fade effect.
  final bool includeFade;

  /// Whether to include a horizontal slide.
  final bool includeSlide;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    final rotationTween = Tween<double>(
      begin: beginAngle,
      end: endAngle,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        Widget result = Transform.rotate(
          angle: rotationTween.evaluate(curvedAnimation),
          alignment: alignment,
          child: child,
        );

        if (includeFade) {
          result = Opacity(
            opacity: curvedAnimation.value.clamp(0.0, 1.0),
            child: result,
          );
        }

        if (includeSlide) {
          final slideOffset = Offset(
            -50.0 * (1.0 - curvedAnimation.value),
            0.0,
          );
          result = Transform.translate(
            offset: slideOffset,
            child: result,
          );
        }

        return result;
      },
      child: child,
    );
  }
}

/// A 3D-perspective rotation animation.
///
/// Creates a "door opening" effect by rotating the drawer around
/// a vertical axis with perspective projection.
class NovaPerspectiveRotateAnimation extends StatelessWidget {
  /// Creates a [NovaPerspectiveRotateAnimation].
  const NovaPerspectiveRotateAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.maxAngle = math.pi / 3,
    this.perspective = 0.002,
    this.curve = Curves.easeOutCubic,
    this.fromRight = false,
  });

  /// The animation driving the rotation.
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Maximum rotation angle.
  final double maxAngle;

  /// Perspective depth factor.
  final double perspective;

  /// Easing curve.
  final Curve curve;

  /// Whether the rotation comes from the right side.
  final bool fromRight;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        final angle = maxAngle * (1.0 - curvedAnimation.value);
        final direction = fromRight ? -1.0 : 1.0;

        final transform = Matrix4.identity()
          ..setEntry(3, 2, perspective)
          ..rotateY(angle * direction);

        return Transform(
          transform: transform,
          alignment: fromRight ? Alignment.centerRight : Alignment.centerLeft,
          child: Opacity(
            opacity: curvedAnimation.value.clamp(0.0, 1.0),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
