// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Spring animation for the NovaAppDrawer.
///
/// Uses spring physics simulation for natural, physics-based
/// motion when opening/closing the drawer.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A widget that applies spring physics animation to its child.
///
/// Uses a [SpringSimulation] for realistic motion with configurable
/// [damping] and [stiffness].
///
/// Example:
/// ```dart
/// NovaSpringDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   stiffness: 300,
///   damping: 15,
/// )
/// ```
class NovaSpringDrawerAnimation extends StatelessWidget {
  /// Creates a [NovaSpringDrawerAnimation].
  const NovaSpringDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.stiffness = 200.0,
    this.damping = 0.7,
    this.mass = 1.0,
    this.axis = Axis.horizontal,
    this.includeFade = true,
  });

  /// The animation driving the spring effect.
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Spring stiffness (higher = faster snap).
  final double stiffness;

  /// Damping ratio (0 = undamped, 1 = critically damped).
  final double damping;

  /// Mass of the simulated object.
  final double mass;

  /// Axis of motion.
  final Axis axis;

  /// Whether to include a fade effect.
  final bool includeFade;

  @override
  Widget build(BuildContext context) {
    // Use a custom spring curve to approximate spring physics
    // within the standard Animation<double> framework.
    final springCurve = _SpringCurve(
      damping: damping,
      stiffness: stiffness,
      mass: mass,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: springCurve,
    );

    final slideTween = axis == Axis.horizontal
        ? Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
        : Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero);

    Widget result = SlideTransition(
      position: slideTween.animate(curvedAnimation),
      child: child,
    );

    if (includeFade) {
      result = FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
        ),
        child: result,
      );
    }

    return result;
  }
}

/// A custom curve that approximates spring physics behavior.
class _SpringCurve extends Curve {
  const _SpringCurve({
    required this.damping,
    required this.stiffness,
    required this.mass,
  });

  final double damping;
  final double stiffness;
  final double mass;

  @override
  double transformInternal(double t) {
    // Use a SpringSimulation to compute the curve
    final spring = SpringDescription(
      mass: mass,
      stiffness: stiffness,
      damping: damping * 2.0 * math.sqrt(stiffness * mass),
    );

    final simulation = SpringSimulation(spring, 0.0, 1.0, 0.0);
    return simulation.x(t).clamp(0.0, 1.5); // Allow slight overshoot
  }
}

/// A spring animation applied to scale transformations.
class NovaSpringScaleAnimation extends StatelessWidget {
  /// Creates a [NovaSpringScaleAnimation].
  const NovaSpringScaleAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.stiffness = 200.0,
    this.damping = 0.7,
    this.alignment = Alignment.centerLeft,
  });

  /// The animation controller.
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Spring stiffness.
  final double stiffness;

  /// Damping ratio.
  final double damping;

  /// Scale origin.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final springCurve = _SpringCurve(
      damping: damping,
      stiffness: stiffness,
      mass: 1.0,
    );

    final scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: springCurve,
    ));

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.3),
      ),
      child: ScaleTransition(
        scale: scaleAnimation,
        alignment: alignment,
        child: child,
      ),
    );
  }
}

/// Helper to create a [SpringDescription] for drawer animations.
SpringDescription createDrawerSpring({
  double stiffness = 200.0,
  double damping = 0.7,
  double mass = 1.0,
}) {
  return SpringDescription(
    mass: mass,
    stiffness: stiffness,
    damping: damping * 2.0 * math.sqrt(stiffness * mass),
  );
}
