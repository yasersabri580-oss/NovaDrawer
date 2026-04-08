// Copyright (c) 2024 NovaAppDrawer Contributors
// Licensed under the MIT License.

/// Shimmer animation for the NovaAppDrawer.
///
/// Provides a shimmering loading/highlight effect that sweeps
/// across the drawer surface during transitions.
library;

import 'package:flutter/material.dart';

/// A widget that applies a shimmer effect to its child.
///
/// A gradient highlight sweeps across the surface, commonly used
/// as a loading placeholder or attention-drawing effect.
///
/// Example:
/// ```dart
/// NovaShimmerDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   baseColor: Colors.grey[300]!,
///   highlightColor: Colors.grey[100]!,
/// )
/// ```
class NovaShimmerDrawerAnimation extends StatelessWidget {
  /// Creates a [NovaShimmerDrawerAnimation].
  const NovaShimmerDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.direction = NovaShimmerDirection.leftToRight,
    this.curve = Curves.linear,
  });

  /// The animation driving the shimmer sweep.
  final Animation<double> animation;

  /// The child widget to overlay with shimmer.
  final Widget child;

  /// Base color of the shimmer (darker).
  final Color? baseColor;

  /// Highlight color of the shimmer (lighter).
  final Color? highlightColor;

  /// Direction of the shimmer sweep.
  final NovaShimmerDirection direction;

  /// Easing curve for the shimmer movement.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBaseColor = baseColor ??
        theme.colorScheme.surfaceContainerHighest;
    final effectiveHighlightColor = highlightColor ??
        theme.colorScheme.surface;

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return _createShimmerGradient(
              bounds,
              curvedAnimation.value,
              effectiveBaseColor,
              effectiveHighlightColor,
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: child,
    );
  }

  /// Creates the sweeping gradient for the shimmer effect.
  LinearGradient _createShimmerGradient(
    Rect bounds,
    double animationValue,
    Color base,
    Color highlight,
  ) {
    final Alignment begin;
    final Alignment end;

    switch (direction) {
      case NovaShimmerDirection.leftToRight:
        begin = Alignment(-1.0 + 3.0 * animationValue, 0.0);
        end = Alignment(1.0 + 3.0 * animationValue, 0.0);
      case NovaShimmerDirection.rightToLeft:
        begin = Alignment(1.0 - 3.0 * animationValue, 0.0);
        end = Alignment(-1.0 - 3.0 * animationValue, 0.0);
      case NovaShimmerDirection.topToBottom:
        begin = Alignment(0.0, -1.0 + 3.0 * animationValue);
        end = Alignment(0.0, 1.0 + 3.0 * animationValue);
      case NovaShimmerDirection.bottomToTop:
        begin = Alignment(0.0, 1.0 - 3.0 * animationValue);
        end = Alignment(0.0, -1.0 - 3.0 * animationValue);
    }

    return LinearGradient(
      begin: begin,
      end: end,
      colors: [base, highlight, base],
      stops: const [0.0, 0.5, 1.0],
    );
  }
}

/// Direction of the shimmer sweep.
enum NovaShimmerDirection {
  /// Shimmer moves from left to right.
  leftToRight,

  /// Shimmer moves from right to left.
  rightToLeft,

  /// Shimmer moves from top to bottom.
  topToBottom,

  /// Shimmer moves from bottom to top.
  bottomToTop,
}

/// A continuous shimmer effect that loops indefinitely.
///
/// Useful for loading state placeholders in the drawer.
class NovaContinuousShimmer extends StatefulWidget {
  /// Creates a [NovaContinuousShimmer].
  const NovaContinuousShimmer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.direction = NovaShimmerDirection.leftToRight,
    this.enabled = true,
  });

  /// The child widget.
  final Widget child;

  /// Base shimmer color.
  final Color? baseColor;

  /// Highlight shimmer color.
  final Color? highlightColor;

  /// Duration of one complete shimmer cycle.
  final Duration duration;

  /// Shimmer direction.
  final NovaShimmerDirection direction;

  /// Whether the shimmer animation is active.
  final bool enabled;

  @override
  State<NovaContinuousShimmer> createState() => _NovaContinuousShimmerState();
}

class _NovaContinuousShimmerState extends State<NovaContinuousShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(NovaContinuousShimmer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
      if (widget.enabled) {
        _controller.repeat();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return NovaShimmerDrawerAnimation(
      animation: _controller,
      baseColor: widget.baseColor,
      highlightColor: widget.highlightColor,
      direction: widget.direction,
      child: widget.child,
    );
  }
}
