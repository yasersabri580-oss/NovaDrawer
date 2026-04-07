// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Blur transition animation for the AdvancedAppDrawer.
///
/// Provides a Gaussian blur transition effect that blurs or
/// unblurs the drawer content during open/close.
library;

import 'dart:ui';

import 'package:flutter/material.dart';

/// A widget that applies an animated blur transition to its child.
///
/// Transitions from a blurred state to clear (or vice versa),
/// optionally combined with opacity for a frosted-glass effect.
///
/// Example:
/// ```dart
/// BlurDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   maxSigma: 15.0,
/// )
/// ```
class BlurDrawerAnimation extends StatelessWidget {
  /// Creates a [BlurDrawerAnimation].
  const BlurDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.maxSigma = 10.0,
    this.curve = Curves.easeInOut,
    this.blurDirection = BlurDirection.blurToSharp,
    this.includeFade = true,
  });

  /// The animation driving the blur transition.
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Maximum blur sigma value.
  final double maxSigma;

  /// Easing curve.
  final Curve curve;

  /// Direction of the blur transition.
  final BlurDirection blurDirection;

  /// Whether to include a fade effect.
  final bool includeFade;

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
        final sigma = blurDirection == BlurDirection.blurToSharp
            ? maxSigma * (1.0 - t)
            : maxSigma * t;

        Widget result = ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: sigma.clamp(0.0, maxSigma),
            sigmaY: sigma.clamp(0.0, maxSigma),
          ),
          child: child,
        );

        if (includeFade) {
          result = Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: result,
          );
        }

        return result;
      },
      child: child,
    );
  }
}

/// Direction of the blur transition.
enum BlurDirection {
  /// Starts blurry and becomes sharp.
  blurToSharp,

  /// Starts sharp and becomes blurry.
  sharpToBlur,
}

/// A frosted-glass effect overlay for the drawer background.
///
/// Creates a translucent, blurred overlay that gives a modern
/// glass-morphism appearance.
class FrostedGlassEffect extends StatelessWidget {
  /// Creates a [FrostedGlassEffect].
  const FrostedGlassEffect({
    super.key,
    required this.child,
    this.sigma = 10.0,
    this.opacity = 0.1,
    this.tintColor,
  });

  /// The child widget displayed with the frosted effect.
  final Widget child;

  /// Blur sigma for the frosted glass.
  final double sigma;

  /// Opacity of the tint overlay.
  final double opacity;

  /// Color of the frosted glass tint.
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    final effectiveTintColor = tintColor ??
        Theme.of(context).colorScheme.surface;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: ColoredBox(
          color: effectiveTintColor.withAlpha((opacity * 255).round()),
          child: child,
        ),
      ),
    );
  }
}

/// An animated frosted glass that transitions blur intensity.
class AnimatedFrostedGlass extends StatelessWidget {
  /// Creates an [AnimatedFrostedGlass].
  const AnimatedFrostedGlass({
    super.key,
    required this.animation,
    required this.child,
    this.maxSigma = 15.0,
    this.maxOpacity = 0.2,
    this.tintColor,
    this.curve = Curves.easeInOut,
  });

  /// The animation controlling blur intensity.
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Maximum blur sigma.
  final double maxSigma;

  /// Maximum tint opacity.
  final double maxOpacity;

  /// Tint overlay color.
  final Color? tintColor;

  /// Easing curve.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final effectiveTintColor = tintColor ??
        Theme.of(context).colorScheme.surface;
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        final sigma = maxSigma * curvedAnimation.value;
        final opacity = maxOpacity * curvedAnimation.value;

        return ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: sigma.clamp(0.0, maxSigma),
              sigmaY: sigma.clamp(0.0, maxSigma),
            ),
            child: ColoredBox(
              color: effectiveTintColor.withAlpha((opacity * 255).round()),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
