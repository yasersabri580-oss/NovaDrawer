// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Animation configuration for the NovaAppDrawer.
///
/// Defines duration, curve, and style parameters that apply
/// to all drawer animations.
library;

import 'package:flutter/material.dart';

/// Configuration for controlling drawer animation behavior.
///
/// Provides fine-grained control over timing, easing curves,
/// and enable/disable flags for various animation effects.
///
/// Example:
/// ```dart
/// NovaDrawerAnimationConfig(
///   duration: Duration(milliseconds: 350),
///   reverseDuration: Duration(milliseconds: 250),
///   curve: Curves.easeOutCubic,
///   enableItemAnimations: true,
/// )
/// ```
class NovaDrawerAnimationConfig {
  /// Creates a [NovaDrawerAnimationConfig].
  const NovaDrawerAnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration,
    this.curve = Curves.easeInOutCubic,
    this.reverseCurve,
    this.itemStaggerDelay = const Duration(milliseconds: 50),
    this.sectionAnimationDuration = const Duration(milliseconds: 250),
    this.nestedExpandDuration = const Duration(milliseconds: 200),
    this.hoverAnimationDuration = const Duration(milliseconds: 150),
    this.enableItemAnimations = true,
    this.enableSectionAnimations = true,
    this.enableHoverAnimations = true,
    this.enableStaggeredAnimations = true,
    this.enableBackgroundAnimations = true,
    this.springDamping = 0.7,
    this.springStiffness = 200.0,
    this.elasticPeriod = 0.4,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.blurSigma = 10.0,
  });

  /// Duration of the main drawer open/close animation.
  final Duration duration;

  /// Duration of the reverse (close) animation. Defaults to [duration].
  final Duration? reverseDuration;

  /// Easing curve for the forward animation.
  final Curve curve;

  /// Easing curve for the reverse animation. Defaults to reversed [curve].
  final Curve? reverseCurve;

  /// Delay between each item's staggered entrance animation.
  final Duration itemStaggerDelay;

  /// Duration of section expand/collapse animations.
  final Duration sectionAnimationDuration;

  /// Duration of nested item expand animations.
  final Duration nestedExpandDuration;

  /// Duration of hover highlight animations.
  final Duration hoverAnimationDuration;

  /// Whether individual item entrance/exit animations are enabled.
  final bool enableItemAnimations;

  /// Whether section expand/collapse animations are enabled.
  final bool enableSectionAnimations;

  /// Whether hover highlight animations are enabled.
  final bool enableHoverAnimations;

  /// Whether staggered item entrance is enabled.
  final bool enableStaggeredAnimations;

  /// Whether background animations (gradient, particle) are enabled.
  final bool enableBackgroundAnimations;

  /// Damping ratio for spring animations (0.0 = undamped, 1.0 = critical).
  final double springDamping;

  /// Stiffness of spring animations.
  final double springStiffness;

  /// Period of elastic animations.
  final double elasticPeriod;

  /// Base color for shimmer animation.
  final Color? shimmerBaseColor;

  /// Highlight color for shimmer animation.
  final Color? shimmerHighlightColor;

  /// Sigma value for blur transition animation.
  final double blurSigma;

  /// Effective reverse duration (falls back to [duration]).
  Duration get effectiveReverseDuration => reverseDuration ?? duration;

  /// Effective reverse curve (falls back to reversed [curve]).
  Curve get effectiveReverseCurve => reverseCurve ?? curve.flipped;

  /// Creates a copy of this config with the given fields replaced.
  NovaDrawerAnimationConfig copyWith({
    Duration? duration,
    Duration? reverseDuration,
    Curve? curve,
    Curve? reverseCurve,
    Duration? itemStaggerDelay,
    Duration? sectionAnimationDuration,
    Duration? nestedExpandDuration,
    Duration? hoverAnimationDuration,
    bool? enableItemAnimations,
    bool? enableSectionAnimations,
    bool? enableHoverAnimations,
    bool? enableStaggeredAnimations,
    bool? enableBackgroundAnimations,
    double? springDamping,
    double? springStiffness,
    double? elasticPeriod,
    Color? shimmerBaseColor,
    Color? shimmerHighlightColor,
    double? blurSigma,
  }) {
    return NovaDrawerAnimationConfig(
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      curve: curve ?? this.curve,
      reverseCurve: reverseCurve ?? this.reverseCurve,
      itemStaggerDelay: itemStaggerDelay ?? this.itemStaggerDelay,
      sectionAnimationDuration:
          sectionAnimationDuration ?? this.sectionAnimationDuration,
      nestedExpandDuration:
          nestedExpandDuration ?? this.nestedExpandDuration,
      hoverAnimationDuration:
          hoverAnimationDuration ?? this.hoverAnimationDuration,
      enableItemAnimations:
          enableItemAnimations ?? this.enableItemAnimations,
      enableSectionAnimations:
          enableSectionAnimations ?? this.enableSectionAnimations,
      enableHoverAnimations:
          enableHoverAnimations ?? this.enableHoverAnimations,
      enableStaggeredAnimations:
          enableStaggeredAnimations ?? this.enableStaggeredAnimations,
      enableBackgroundAnimations:
          enableBackgroundAnimations ?? this.enableBackgroundAnimations,
      springDamping: springDamping ?? this.springDamping,
      springStiffness: springStiffness ?? this.springStiffness,
      elasticPeriod: elasticPeriod ?? this.elasticPeriod,
      shimmerBaseColor: shimmerBaseColor ?? this.shimmerBaseColor,
      shimmerHighlightColor:
          shimmerHighlightColor ?? this.shimmerHighlightColor,
      blurSigma: blurSigma ?? this.blurSigma,
    );
  }
}
