// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Elastic animation for the NovaAppDrawer.
///
/// Provides bouncy, elastic transitions with overshoot
/// for a playful visual effect.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A custom elastic curve with configurable period and amplitude.
///
/// Produces a bouncing overshoot effect similar to a stretched
/// rubber band snapping into place.
class NovaElasticCurve extends Curve {
  /// Creates an [NovaElasticCurve].
  const NovaElasticCurve({
    this.period = 0.4,
    this.amplitude = 1.0,
  });

  /// Period of the elastic oscillation (higher = slower bounces).
  final double period;

  /// Amplitude of the overshoot (higher = bigger bounces).
  final double amplitude;

  @override
  double transformInternal(double t) {
    final s = period / 4.0;
    final a = amplitude.clamp(1.0, double.infinity);
    return a *
            math.pow(2.0, -10.0 * t) *
            math.sin((t - s) * (2.0 * math.pi) / period) +
        1.0;
  }
}

/// A widget that applies an elastic animation to its child.
///
/// The child bounces into its final position with an overshoot
/// effect controlled by [period] and [amplitude].
///
/// Example:
/// ```dart
/// NovaElasticDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   period: 0.5,
///   amplitude: 1.2,
/// )
/// ```
class NovaElasticDrawerAnimation extends StatelessWidget {
  /// Creates an [NovaElasticDrawerAnimation].
  const NovaElasticDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.period = 0.4,
    this.amplitude = 1.0,
    this.axis = Axis.horizontal,
    this.includeFade = true,
  });

  /// The animation driving the elastic effect.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Period of the elastic oscillation.
  final double period;

  /// Amplitude of the overshoot.
  final double amplitude;

  /// Axis along which the elastic effect occurs.
  final Axis axis;

  /// Whether to include a fade effect.
  final bool includeFade;

  @override
  Widget build(BuildContext context) {
    final elasticCurve = NovaElasticCurve(
      period: period,
      amplitude: amplitude,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: elasticCurve,
    );

    final slideTween = axis == Axis.horizontal
        ? Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
        : Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero);

    Widget result = SlideTransition(
      position: slideTween.animate(curvedAnimation),
      child: child,
    );

    if (includeFade) {
      // Fade in quickly before the elastic bounce starts
      final fadeAnimation = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      );
      result = FadeTransition(
        opacity: fadeAnimation,
        child: result,
      );
    }

    return result;
  }
}

/// An elastic scale animation that bounces into size.
class NovaElasticScaleAnimation extends StatelessWidget {
  /// Creates an [NovaElasticScaleAnimation].
  const NovaElasticScaleAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.period = 0.4,
    this.amplitude = 1.0,
    this.alignment = Alignment.centerLeft,
  });

  /// The animation driving the elastic scale.
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Period of the elastic oscillation.
  final double period;

  /// Amplitude of the overshoot.
  final double amplitude;

  /// Scale origin alignment.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final elasticCurve = NovaElasticCurve(
      period: period,
      amplitude: amplitude,
    );

    final scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: elasticCurve,
    ));

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.2),
      ),
      child: ScaleTransition(
        scale: scaleAnimation,
        alignment: alignment,
        child: child,
      ),
    );
  }
}
