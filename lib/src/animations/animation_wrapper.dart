// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Animation wrapper for the AdvancedAppDrawer.
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

/// A unified animation wrapper that applies the configured animation
/// type to its child.
///
/// Delegates to the appropriate animation widget based on the
/// [animationType] parameter, using settings from [animationConfig].
///
/// Example:
/// ```dart
/// DrawerAnimationWrapper(
///   animation: controller,
///   animationType: DrawerAnimationType.slide,
///   child: drawerContent,
/// )
/// ```
class DrawerAnimationWrapper extends StatelessWidget {
  /// Creates a [DrawerAnimationWrapper].
  const DrawerAnimationWrapper({
    super.key,
    required this.animation,
    required this.animationType,
    required this.child,
    this.animationConfig = const DrawerAnimationConfig(),
    this.isRtl = false,
  });

  /// The animation driving the transition.
  final Animation<double> animation;

  /// Which animation type to apply.
  final DrawerAnimationType animationType;

  /// The child widget to animate.
  final Widget child;

  /// Animation configuration (timing, curves, etc.).
  final DrawerAnimationConfig animationConfig;

  /// Whether the layout direction is right-to-left.
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    switch (animationType) {
      case DrawerAnimationType.slide:
        return SlideDrawerAnimation(
          animation: animation,
          beginOffset: Offset(isRtl ? 1.0 : -1.0, 0.0),
          curve: animationConfig.curve,
          child: child,
        );

      case DrawerAnimationType.fade:
        return FadeDrawerAnimation(
          animation: animation,
          curve: animationConfig.curve,
          child: child,
        );

      case DrawerAnimationType.scale:
        return ScaleDrawerAnimation(
          animation: animation,
          beginScale: 0.8,
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          curve: animationConfig.curve,
          child: child,
        );

      case DrawerAnimationType.rotate:
        return PerspectiveRotateAnimation(
          animation: animation,
          curve: animationConfig.curve,
          fromRight: isRtl,
          child: child,
        );

      case DrawerAnimationType.morph:
        return MorphDrawerAnimation(
          animation: animation,
          curve: animationConfig.curve,
          child: child,
        );

      case DrawerAnimationType.elastic:
        return ElasticDrawerAnimation(
          animation: animation,
          period: animationConfig.elasticPeriod,
          child: child,
        );

      case DrawerAnimationType.spring:
        return SpringDrawerAnimation(
          animation: animation,
          stiffness: animationConfig.springStiffness,
          damping: animationConfig.springDamping,
          child: child,
        );

      case DrawerAnimationType.shimmer:
        return ShimmerDrawerAnimation(
          animation: animation,
          baseColor: animationConfig.shimmerBaseColor,
          highlightColor: animationConfig.shimmerHighlightColor,
          child: child,
        );

      case DrawerAnimationType.blur:
        return BlurDrawerAnimation(
          animation: animation,
          maxSigma: animationConfig.blurSigma,
          curve: animationConfig.curve,
          child: child,
        );

      case DrawerAnimationType.gradient:
        return GradientDrawerAnimation(
          animation: animation,
          curve: animationConfig.curve,
          child: child,
        );
    }
  }
}

/// Applies staggered item animations based on the configured type.
///
/// Each item receives a delayed entrance animation, creating a
/// cascading visual effect.
class StaggeredItemAnimationWrapper extends StatelessWidget {
  /// Creates a [StaggeredItemAnimationWrapper].
  const StaggeredItemAnimationWrapper({
    super.key,
    required this.animation,
    required this.animationType,
    required this.child,
    required this.index,
    this.totalItems = 10,
    this.animationConfig = const DrawerAnimationConfig(),
    this.isRtl = false,
  });

  /// The parent animation.
  final Animation<double> animation;

  /// Animation type to apply per item.
  final DrawerAnimationType animationType;

  /// The child widget.
  final Widget child;

  /// Index in the stagger sequence.
  final int index;

  /// Total number of items being staggered.
  final int totalItems;

  /// Animation configuration.
  final DrawerAnimationConfig animationConfig;

  /// Whether layout is right-to-left.
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    if (!animationConfig.enableStaggeredAnimations) return child;

    switch (animationType) {
      case DrawerAnimationType.slide:
        return StaggeredSlideAnimation(
          animation: animation,
          index: index,
          totalItems: totalItems,
          beginOffset: Offset(isRtl ? 0.5 : -0.5, 0.0),
          child: child,
        );

      case DrawerAnimationType.fade:
        return StaggeredFadeAnimation(
          animation: animation,
          index: index,
          totalItems: totalItems,
          child: child,
        );

      case DrawerAnimationType.scale:
        return StaggeredScaleAnimation(
          animation: animation,
          index: index,
          totalItems: totalItems,
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: child,
        );

      default:
        // For animation types without stagger variants, fall back to slide
        return StaggeredSlideAnimation(
          animation: animation,
          index: index,
          totalItems: totalItems,
          beginOffset: Offset(isRtl ? 0.5 : -0.5, 0.0),
          child: child,
        );
    }
  }
}
