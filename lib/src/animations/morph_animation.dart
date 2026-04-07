// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Morph animation for the AdvancedAppDrawer.
///
/// Provides shape-morphing transitions that smoothly transform
/// the drawer between different sizes and shapes.
library;

import 'package:flutter/material.dart';

/// A widget that morphs its container shape during animation.
///
/// Smoothly interpolates between [beginDecoration] and [endDecoration],
/// creating a fluid shape transformation effect.
///
/// Example:
/// ```dart
/// MorphDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   beginDecoration: BoxDecoration(borderRadius: BorderRadius.circular(32)),
///   endDecoration: BoxDecoration(borderRadius: BorderRadius.zero),
/// )
/// ```
class MorphDrawerAnimation extends StatelessWidget {
  /// Creates a [MorphDrawerAnimation].
  const MorphDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.beginDecoration,
    this.endDecoration,
    this.beginSize,
    this.endSize,
    this.curve = Curves.easeInOutCubic,
    this.includeFade = true,
  });

  /// The animation driving the morph.
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Starting box decoration.
  final BoxDecoration? beginDecoration;

  /// Ending box decoration.
  final BoxDecoration? endDecoration;

  /// Starting size. If null, uses child's natural size.
  final Size? beginSize;

  /// Ending size. If null, uses child's natural size.
  final Size? endSize;

  /// Easing curve for the morph.
  final Curve curve;

  /// Whether to include a fade effect.
  final bool includeFade;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    final defaultBegin = BoxDecoration(
      borderRadius: BorderRadius.circular(32.0),
      color: Colors.transparent,
    );
    final defaultEnd = const BoxDecoration(
      borderRadius: BorderRadius.zero,
      color: Colors.transparent,
    );

    final decorationTween = DecorationTween(
      begin: beginDecoration ?? defaultBegin,
      end: endDecoration ?? defaultEnd,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        Widget result = DecoratedBox(
          decoration: decorationTween.evaluate(curvedAnimation),
          child: child,
        );

        if (beginSize != null && endSize != null) {
          final sizeTween = SizeTween(begin: beginSize, end: endSize);
          final currentSize = sizeTween.evaluate(curvedAnimation);
          if (currentSize != null) {
            result = SizedBox(
              width: currentSize.width,
              height: currentSize.height,
              child: result,
            );
          }
        }

        if (includeFade) {
          result = Opacity(
            opacity: curvedAnimation.value.clamp(0.0, 1.0),
            child: result,
          );
        }

        return ClipRRect(
          borderRadius: _interpolateBorderRadius(curvedAnimation.value),
          child: result,
        );
      },
      child: child,
    );
  }

  /// Interpolates between begin and end border radii.
  BorderRadius _interpolateBorderRadius(double t) {
    final beginRadius = (beginDecoration?.borderRadius as BorderRadius?) ??
        BorderRadius.circular(32.0);
    const endRadius = BorderRadius.zero;
    return BorderRadius.lerp(beginRadius, endRadius, t) ?? BorderRadius.zero;
  }
}

/// A morph animation specifically for transitioning between
/// mini and expanded drawer states.
class DrawerExpansionMorph extends StatelessWidget {
  /// Creates a [DrawerExpansionMorph].
  const DrawerExpansionMorph({
    super.key,
    required this.animation,
    required this.child,
    required this.collapsedWidth,
    required this.expandedWidth,
    this.curve = Curves.easeInOutCubic,
  });

  /// The animation controlling expansion (0 = collapsed, 1 = expanded).
  final Animation<double> animation;

  /// The child widget.
  final Widget child;

  /// Width when fully collapsed.
  final double collapsedWidth;

  /// Width when fully expanded.
  final double expandedWidth;

  /// Easing curve.
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
        final width = collapsedWidth +
            (expandedWidth - collapsedWidth) * curvedAnimation.value;
        return SizedBox(
          width: width,
          child: child,
        );
      },
      child: child,
    );
  }
}
