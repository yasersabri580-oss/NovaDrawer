// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Gradient background for the AdvancedAppDrawer.
///
/// Provides animated gradient backgrounds for the drawer surface.
library;

import 'package:flutter/material.dart';

/// An animated gradient background for the drawer.
///
/// Cycles through colors over time for a visually dynamic backdrop.
///
/// Example:
/// ```dart
/// DrawerGradientBackground(
///   colors: [Colors.blue.shade900, Colors.purple.shade900],
///   child: drawerContent,
/// )
/// ```
class DrawerGradientBackground extends StatefulWidget {
  /// Creates a [DrawerGradientBackground].
  const DrawerGradientBackground({
    super.key,
    required this.child,
    this.colors,
    this.animated = true,
    this.duration = const Duration(seconds: 6),
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.stops,
    this.opacity = 1.0,
  });

  /// The child widget displayed on top.
  final Widget child;

  /// Gradient colors. Defaults to theme-derived colors.
  final List<Color>? colors;

  /// Whether the gradient animates over time.
  final bool animated;

  /// Duration of one animation cycle.
  final Duration duration;

  /// Gradient start alignment.
  final Alignment begin;

  /// Gradient end alignment.
  final Alignment end;

  /// Gradient color stops.
  final List<double>? stops;

  /// Opacity of the gradient overlay.
  final double opacity;

  @override
  State<DrawerGradientBackground> createState() =>
      _DrawerGradientBackgroundState();
}

class _DrawerGradientBackgroundState extends State<DrawerGradientBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.animated) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(DrawerGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animated != oldWidget.animated) {
      if (widget.animated) {
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
    final theme = Theme.of(context);
    final defaultColors = [
      theme.colorScheme.primary.withAlpha(25),
      theme.colorScheme.secondary.withAlpha(25),
      theme.colorScheme.tertiary.withAlpha(25),
    ];
    final colors = widget.colors ?? defaultColors;

    if (!widget.animated) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: widget.begin,
            end: widget.end,
            colors: colors,
            stops: widget.stops,
          ),
        ),
        child: widget.child,
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        final shiftedColors = _shiftColors(colors, t);

        return Opacity(
          opacity: widget.opacity,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.lerp(widget.begin, widget.end, t * 0.3) ??
                    widget.begin,
                end: Alignment.lerp(widget.end, widget.begin, t * 0.3) ??
                    widget.end,
                colors: shiftedColors,
                stops: widget.stops,
              ),
            ),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }

  List<Color> _shiftColors(List<Color> colors, double t) {
    final result = <Color>[];
    for (var i = 0; i < colors.length; i++) {
      final next = (i + 1) % colors.length;
      result.add(Color.lerp(colors[i], colors[next], t) ?? colors[i]);
    }
    return result;
  }
}
