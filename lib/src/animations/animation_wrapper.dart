// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Animation wrapper for the NovaAppDrawer.
///
/// Provides a unified interface for applying any of the supported
/// animation types to drawer content via a single widget.
library;

import 'package:flutter/material.dart';

import '../models/drawer_config.dart';
import '../animations/animation_config.dart';
import '../animations/slide_animation.dart';
import '../animations/fade_animation.dart';
import '../animations/scale_animation.dart';
import '../animations/rotate_animation.dart';
import '../animations/morph_animation.dart';
import '../animations/elastic_animation.dart';
import '../animations/spring_animation.dart';
import '../animations/shimmer_animation.dart';
import '../animations/blur_animation.dart';
import '../animations/gradient_animation.dart';
import '../animations/floating_animation.dart';
import '../animations/wave_animation.dart';

/// A unified animation wrapper that applies the configured animation
/// type to its child.
///
/// Delegates to the appropriate animation widget based on the
/// [animationType] parameter, using settings from [animationConfig].
///
/// Example:
/// ```dart
/// NovaDrawerAnimationWrapper(
///   animation: controller,
///   animationType: NovaDrawerAnimationType.slide,
///   child: drawerContent,
/// )
/// ```
class NovaDrawerAnimationWrapper extends StatelessWidget {
  /// Creates a [NovaDrawerAnimationWrapper].
  const NovaDrawerAnimationWrapper({
    super.key,
    required this.animation,
    required this.animationType,
    required this.child,
    this.animationConfig = const NovaDrawerAnimationConfig(),
    this.isRtl = false,
  });

  /// The animation driving the transition.
  final Animation<double> animation;

  /// Which animation type to apply.
  final NovaDrawerAnimationType animationType;

  /// The child widget to animate.
  final Widget child;

  /// Animation configuration (timing, curves, etc.).
  final NovaDrawerAnimationConfig animationConfig;

  /// Whether the layout direction is right-to-left.
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    switch (animationType) {
      case NovaDrawerAnimationType.slide:
        return NovaSlideDrawerAnimation(
          animation: animation,
          beginOffset: Offset(isRtl ? 1.0 : -1.0, 0.0),
          curve: animationConfig.curve,
          child: child,
        );

      case NovaDrawerAnimationType.fade:
        return NovaFadeDrawerAnimation(
          animation: animation,
          curve: animationConfig.curve,
          child: child,
        );

      case NovaDrawerAnimationType.scale:
        return NovaScaleDrawerAnimation(
          animation: animation,
          beginScale: 0.8,
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          curve: animationConfig.curve,
          child: child,
        );

      case NovaDrawerAnimationType.rotate:
        return NovaPerspectiveRotateAnimation(
          animation: animation,
          curve: animationConfig.curve,
          fromRight: isRtl,
          child: child,
        );

      case NovaDrawerAnimationType.morph:
        return NovaMorphDrawerAnimation(
          animation: animation,
          curve: animationConfig.curve,
          child: child,
        );

      case NovaDrawerAnimationType.elastic:
        return NovaElasticDrawerAnimation(
          animation: animation,
          period: animationConfig.elasticPeriod,
          child: child,
        );

      case NovaDrawerAnimationType.spring:
        return NovaSpringDrawerAnimation(
          animation: animation,
          stiffness: animationConfig.springStiffness,
          damping: animationConfig.springDamping,
          child: child,
        );

      case NovaDrawerAnimationType.shimmer:
        return NovaShimmerDrawerAnimation(
          animation: animation,
          baseColor: animationConfig.shimmerBaseColor,
          highlightColor: animationConfig.shimmerHighlightColor,
          child: child,
        );

      case NovaDrawerAnimationType.blur:
        return NovaBlurDrawerAnimation(
          animation: animation,
          maxSigma: animationConfig.blurSigma,
          curve: animationConfig.curve,
          child: child,
        );

      case NovaDrawerAnimationType.gradient:
        return NovaGradientDrawerAnimation(
          animation: animation,
          curve: animationConfig.curve,
          child: child,
        );

      case NovaDrawerAnimationType.floating:
        return NovaFloatingDrawerAnimation(
          animation: animation,
          child: child,
        );

      case NovaDrawerAnimationType.floatingBounce:
        return NovaFloatingBounceAnimation(
          animation: animation,
          child: child,
        );

      case NovaDrawerAnimationType.floatingReveal:
        return NovaFloatingRevealAnimation(
          animation: animation,
          origin: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: child,
        );

      case NovaDrawerAnimationType.wave:
        return NovaWaveDrawerAnimation(
          animation: animation,
          child: child,
        );

      case NovaDrawerAnimationType.parallax:
        return NovaParallaxDrawerAnimation(
          animation: animation,
          child: child,
        );

      case NovaDrawerAnimationType.curtain:
        return NovaCurtainDrawerAnimation(
          animation: animation,
          child: child,
        );
    }
  }
}

/// Applies staggered item animations based on the configured type.
///
/// Each item receives a delayed entrance animation, creating a
/// cascading visual effect.
class NovaStaggeredItemAnimationWrapper extends StatelessWidget {
  /// Creates a [NovaStaggeredItemAnimationWrapper].
  const NovaStaggeredItemAnimationWrapper({
    super.key,
    required this.animation,
    required this.animationType,
    required this.child,
    required this.index,
    this.totalItems = 10,
    this.animationConfig = const NovaDrawerAnimationConfig(),
    this.isRtl = false,
  });

  /// The parent animation.
  final Animation<double> animation;

  /// Animation type to apply per item.
  final NovaDrawerAnimationType animationType;

  /// The child widget.
  final Widget child;

  /// Index in the stagger sequence.
  final int index;

  /// Total number of items being staggered.
  final int totalItems;

  /// Animation configuration.
  final NovaDrawerAnimationConfig animationConfig;

  /// Whether layout is right-to-left.
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    if (!animationConfig.enableStaggeredAnimations) return child;

    switch (animationType) {
      case NovaDrawerAnimationType.slide:
        return NovaStaggeredSlideAnimation(
          animation: animation,
          index: index,
          totalItems: totalItems,
          beginOffset: Offset(isRtl ? 0.5 : -0.5, 0.0),
          child: child,
        );

      case NovaDrawerAnimationType.fade:
        return NovaStaggeredFadeAnimation(
          animation: animation,
          index: index,
          totalItems: totalItems,
          child: child,
        );

      case NovaDrawerAnimationType.scale:
        return NovaStaggeredScaleAnimation(
          animation: animation,
          index: index,
          totalItems: totalItems,
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: child,
        );

      default:
        // For animation types without stagger variants, fall back to slide
        return NovaStaggeredSlideAnimation(
          animation: animation,
          index: index,
          totalItems: totalItems,
          beginOffset: Offset(isRtl ? 0.5 : -0.5, 0.0),
          child: child,
        );
    }
  }
}
