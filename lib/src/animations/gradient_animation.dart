// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Gradient transition animation for the AdvancedAppDrawer.
///
/// Provides smooth color gradient transitions for the drawer
/// background during open/close or state changes.
library;

import 'package:flutter/material.dart';

/// A widget that animates between two gradient states.
///
/// Smoothly interpolates the gradient colors and stops to create
/// fluid color transitions on the drawer background.
///
/// Example:
/// ```dart
/// GradientDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   beginGradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
///   endGradient: LinearGradient(colors: [Colors.teal, Colors.green]),
/// )
/// ```
class GradientDrawerAnimation extends StatelessWidget {
  /// Creates a [GradientDrawerAnimation].
  const GradientDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.beginGradient,
    this.endGradient,
    this.curve = Curves.easeInOut,
    this.includeChildFade = true,
  });

  /// The animation driving the gradient transition.
  final Animation<double> animation;

  /// The child widget displayed on top of the gradient.
  final Widget child;

  /// Starting gradient.
  final LinearGradient? beginGradient;

  /// Ending gradient.
  final LinearGradient? endGradient;

  /// Easing curve for the gradient transition.
  final Curve curve;

  /// Whether to fade the child in alongside the gradient.
  final bool includeChildFade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBeginGradient = beginGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withAlpha(0),
            theme.colorScheme.primaryContainer.withAlpha(0),
          ],
        );
    final effectiveEndGradient = endGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primaryContainer.withAlpha(25),
            theme.colorScheme.secondaryContainer.withAlpha(25),
          ],
        );

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
    );

    return AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        final t = curvedAnimation.value;
        final gradient = LinearGradient.lerp(
          effectiveBeginGradient,
          effectiveEndGradient,
          t,
        );

        Widget content = child!;
        if (includeChildFade) {
          content = Opacity(
            opacity: t.clamp(0.0, 1.0),
            child: content,
          );
        }

        return DecoratedBox(
          decoration: BoxDecoration(gradient: gradient),
          child: content,
        );
      },
      child: child,
    );
  }
}

/// An animated gradient background that continuously cycles through colors.
class AnimatedGradientBackground extends StatefulWidget {
  /// Creates an [AnimatedGradientBackground].
  const AnimatedGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.duration = const Duration(seconds: 5),
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.enabled = true,
  });

  /// The child widget.
  final Widget child;

  /// Colors to cycle through. Must have at least 2 colors.
  final List<Color>? colors;

  /// Duration of one complete color cycle.
  final Duration duration;

  /// Gradient start alignment.
  final Alignment begin;

  /// Gradient end alignment.
  final Alignment end;

  /// Whether the animation is active.
  final bool enabled;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<AnimatedGradientBackground>
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
  void didUpdateWidget(AnimatedGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
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
    final theme = Theme.of(context);
    final colors = widget.colors ??
        [
          theme.colorScheme.primary.withAlpha(51),
          theme.colorScheme.secondary.withAlpha(51),
          theme.colorScheme.tertiary.withAlpha(51),
          theme.colorScheme.primary.withAlpha(51),
        ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        // Shift colors based on animation progress
        final shiftedColors = _shiftColors(colors, t);

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.begin,
              end: widget.end,
              colors: shiftedColors,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }

  /// Shifts colors cyclically based on animation progress.
  List<Color> _shiftColors(List<Color> colors, double t) {
    if (colors.length < 2) return colors;

    final result = <Color>[];
    for (var i = 0; i < colors.length; i++) {
      final nextIndex = (i + 1) % colors.length;
      result.add(Color.lerp(colors[i], colors[nextIndex], t) ?? colors[i]);
    }
    return result;
  }
}

/// A pulsing gradient effect for attention-drawing highlights.
class PulsingGradient extends StatefulWidget {
  /// Creates a [PulsingGradient].
  const PulsingGradient({
    super.key,
    required this.child,
    this.color,
    this.duration = const Duration(seconds: 2),
    this.minOpacity = 0.0,
    this.maxOpacity = 0.15,
    this.enabled = true,
  });

  /// The child widget.
  final Widget child;

  /// Pulse color.
  final Color? color;

  /// Duration of one pulse cycle.
  final Duration duration;

  /// Minimum pulse opacity.
  final double minOpacity;

  /// Maximum pulse opacity.
  final double maxOpacity;

  /// Whether pulsing is active.
  final bool enabled;

  @override
  State<PulsingGradient> createState() => _PulsingGradientState();
}

class _PulsingGradientState extends State<PulsingGradient>
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
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(PulsingGradient oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
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
    final pulseColor = widget.color ??
        Theme.of(context).colorScheme.primary;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final opacity = widget.minOpacity +
            (widget.maxOpacity - widget.minOpacity) * _controller.value;

        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                pulseColor.withAlpha((opacity * 255).round()),
                pulseColor.withAlpha(0),
              ],
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
