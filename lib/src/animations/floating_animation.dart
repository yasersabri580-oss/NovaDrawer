// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// Floating drawer animations for the NovaAppDrawer.
///
/// Provides floating, bounce, and circular-reveal effects that make
/// the drawer appear to hover above the underlying content with
/// animated shadows and transforms.
library;

import 'dart:math' show pi, sqrt, max;

import 'package:flutter/material.dart';

/// A widget that applies a floating animation to its child.
///
/// The child rises along the Y-axis while an expanding shadow and a
/// subtle scale transition create the illusion of the drawer lifting
/// off the surface.
///
/// Example:
/// ```dart
/// NovaFloatingDrawerAnimation(
///   animation: animationController,
///   child: drawerContent,
///   floatHeight: 16.0,
///   shadowOpacity: 0.4,
/// )
/// ```
class NovaFloatingDrawerAnimation extends StatelessWidget {
  /// Creates a [NovaFloatingDrawerAnimation].
  const NovaFloatingDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.floatHeight = 12.0,
    this.shadowOpacity = 0.3,
    this.curve = Curves.easeOutCubic,
  });

  /// The animation that drives the floating transition.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Maximum Y-axis offset in logical pixels when fully open.
  final double floatHeight;

  /// Peak opacity of the drop-shadow beneath the drawer.
  final double shadowOpacity;

  /// Easing curve applied to the floating animation.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        final t = curvedAnimation.value;
        final translateY = -floatHeight * t;
        final scale = 0.98 + 0.02 * t;
        final shadow = shadowOpacity * t;

        return Transform(
          transform: Matrix4.identity()
            ..translate(0.0, translateY)
            ..scale(scale),
          alignment: Alignment.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, shadow),
                  blurRadius: 24.0 * t,
                  spreadRadius: 4.0 * t,
                  offset: Offset(0, 8.0 * t),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// A floating animation that combines an upward lift with a bounce
/// overshoot for a playful entrance effect.
///
/// The drawer scales from 0.9 to 1.0 with a configurable overshoot
/// controlled by [bounceIntensity], while simultaneously rising and
/// casting an animated shadow.
///
/// Example:
/// ```dart
/// NovaFloatingBounceAnimation(
///   animation: animationController,
///   child: drawerContent,
///   bounceIntensity: 1.5,
/// )
/// ```
class NovaFloatingBounceAnimation extends StatelessWidget {
  /// Creates a [NovaFloatingBounceAnimation].
  const NovaFloatingBounceAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.floatHeight = 12.0,
    this.shadowOpacity = 0.3,
    this.bounceIntensity = 1.2,
  });

  /// The animation that drives the bounce transition.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Maximum Y-axis offset in logical pixels when fully open.
  final double floatHeight;

  /// Peak opacity of the drop-shadow beneath the drawer.
  final double shadowOpacity;

  /// Multiplier for the elastic overshoot. Values above 1.0 produce
  /// a more pronounced bounce.
  final double bounceIntensity;

  @override
  Widget build(BuildContext context) {
    final bounceCurve = _BounceCurve(bounceIntensity);

    final bounceAnimation = CurvedAnimation(
      parent: animation,
      curve: bounceCurve,
    );

    final shadowAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final bt = bounceAnimation.value;
        final st = shadowAnimation.value;
        final translateY = -floatHeight * bt;
        final scale = 0.9 + 0.1 * bt;
        final shadow = shadowOpacity * st;

        return Transform(
          transform: Matrix4.identity()
            ..translate(0.0, translateY)
            ..scale(scale),
          alignment: Alignment.center,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, shadow),
                  blurRadius: 24.0 * st,
                  spreadRadius: 4.0 * st,
                  offset: Offset(0, 8.0 * st),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// A bounce curve that overshoots 1.0 before settling, producing an
/// elastic feel whose intensity is tuneable.
class _BounceCurve extends Curve {
  const _BounceCurve(this.intensity);

  final double intensity;

  @override
  double transformInternal(double t) {
    // Damped sine that overshoots proportionally to [intensity].
    final overshoot = intensity - 1.0;
    return 1.0 - (1.0 - t) * (1.0 - t) + overshoot * sin(pi * t) * (1.0 - t);
  }
}

/// A circular-reveal animation that expands a clip circle from a
/// configurable [origin], combined with a fade and a floating shadow.
///
/// The clip circle grows from zero radius to fully cover the child
/// as the animation progresses, giving a modern reveal appearance.
///
/// Example:
/// ```dart
/// NovaFloatingRevealAnimation(
///   animation: animationController,
///   child: drawerContent,
///   origin: Alignment.topLeft,
/// )
/// ```
class NovaFloatingRevealAnimation extends StatelessWidget {
  /// Creates a [NovaFloatingRevealAnimation].
  const NovaFloatingRevealAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.origin = Alignment.centerLeft,
    this.shadowOpacity = 0.3,
    this.curve = Curves.easeOutCubic,
  });

  /// The animation that drives the reveal.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Alignment within the child from which the reveal circle expands.
  final Alignment origin;

  /// Peak opacity of the drop-shadow beneath the drawer.
  final double shadowOpacity;

  /// Easing curve applied to the reveal animation.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        final t = curvedAnimation.value;
        final shadow = shadowOpacity * t;

        return DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, shadow),
                blurRadius: 24.0 * t,
                spreadRadius: 4.0 * t,
                offset: Offset(0, 8.0 * t),
              ),
            ],
          ),
          child: Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: ClipPath(
              clipper: _CircularRevealClipper(
                fraction: t,
                origin: origin,
              ),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}

/// A [CustomClipper] that clips to a circle expanding from [origin].
///
/// At [fraction] 0.0 the circle has zero radius; at 1.0 it is large
/// enough to cover the entire child.
class _CircularRevealClipper extends CustomClipper<Path> {
  const _CircularRevealClipper({
    required this.fraction,
    required this.origin,
  });

  /// Current reveal fraction (0.0 – 1.0).
  final double fraction;

  /// Alignment of the circle's centre within the clip area.
  final Alignment origin;

  @override
  Path getClip(Size size) {
    // Map Alignment (-1..1) to pixel coordinates.
    final centerX = size.width * (origin.x + 1.0) / 2.0;
    final centerY = size.height * (origin.y + 1.0) / 2.0;
    final center = Offset(centerX, centerY);

    // Maximum radius: distance from the origin to the farthest corner.
    final maxRadius = _maxCornerDistance(center, size);

    final path = Path()
      ..addOval(
        Rect.fromCircle(center: center, radius: maxRadius * fraction),
      );
    return path;
  }

  @override
  bool shouldReclip(covariant _CircularRevealClipper oldClipper) =>
      fraction != oldClipper.fraction || origin != oldClipper.origin;

  static double _maxCornerDistance(Offset center, Size size) {
    final corners = <Offset>[
      Offset.zero,
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];
    var maxDist = 0.0;
    for (final corner in corners) {
      final dx = corner.dx - center.dx;
      final dy = corner.dy - center.dy;
      final dist = sqrt(dx * dx + dy * dy);
      maxDist = max(maxDist, dist);
    }
    return maxDist;
  }
}
