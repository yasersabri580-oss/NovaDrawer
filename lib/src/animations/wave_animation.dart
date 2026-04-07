// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// Wave, parallax, and curtain animations for the NovaDrawer.
///
/// Provides creative reveal transitions including sine-wave clipping,
/// multi-layer parallax depth, and curtain-split effects.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A custom clipper that produces a sine-wave boundary edge.
///
/// The wave edge moves from left to right based on [progress],
/// with the number of oscillations controlled by [waveCount]
/// and the oscillation size controlled by [waveAmplitude].
class NovaWaveClipper extends CustomClipper<Path> {
  /// Creates a [NovaWaveClipper].
  const NovaWaveClipper({
    required this.progress,
    this.waveCount = 3,
    this.waveAmplitude = 20.0,
  });

  /// Animation progress from 0.0 (fully hidden) to 1.0 (fully revealed).
  final double progress;

  /// Number of full sine-wave oscillations along the clipping edge.
  final int waveCount;

  /// Peak amplitude of the sine wave in logical pixels.
  final double waveAmplitude;

  @override
  Path getClip(Size size) {
    final path = Path();
    final waveEdgeX = size.width * progress;

    path.moveTo(0, 0);
    path.lineTo(waveEdgeX, 0);

    // Draw the sine-wave boundary from top to bottom.
    for (var y = 0.0; y <= size.height; y += 1.0) {
      final normalizedY = y / size.height;
      final sineValue =
          math.sin(normalizedY * waveCount * 2.0 * math.pi) * waveAmplitude;
      // Dampen the wave amplitude near start and end of the animation.
      final dampening = math.sin(progress * math.pi);
      path.lineTo(waveEdgeX + sineValue * dampening, y);
    }

    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant NovaWaveClipper oldClipper) =>
      progress != oldClipper.progress ||
      waveCount != oldClipper.waveCount ||
      waveAmplitude != oldClipper.waveAmplitude;
}

/// A widget that reveals its child with a wave-like clipping boundary.
///
/// The clipping edge moves from left to right as the [animation] progresses,
/// using a sine-wave pattern to create an organic, fluid reveal.
///
/// Example:
/// ```dart
/// NovaWaveDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   waveCount: 4,
///   waveAmplitude: 25.0,
/// )
/// ```
class NovaWaveDrawerAnimation extends StatelessWidget {
  /// Creates a [NovaWaveDrawerAnimation].
  const NovaWaveDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.waveCount = 3,
    this.waveAmplitude = 20.0,
  });

  /// The animation driving the wave reveal.
  final Animation<double> animation;

  /// The child widget to reveal.
  final Widget child;

  /// Number of full sine-wave oscillations along the clipping edge.
  final int waveCount;

  /// Peak amplitude of the sine wave in logical pixels.
  final double waveAmplitude;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ClipPath(
          clipper: NovaWaveClipper(
            progress: animation.value.clamp(0.0, 1.0),
            waveCount: waveCount,
            waveAmplitude: waveAmplitude,
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

/// A widget that creates a parallax depth effect between drawer layers.
///
/// Renders multiple translucent copies of [child] in a [Stack], each
/// translating at a different rate controlled by [parallaxFactor].
/// Earlier layers move slower, creating an illusion of depth.
///
/// Example:
/// ```dart
/// NovaParallaxDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   parallaxFactor: 0.4,
///   layers: 3,
/// )
/// ```
class NovaParallaxDrawerAnimation extends StatelessWidget {
  /// Creates a [NovaParallaxDrawerAnimation].
  const NovaParallaxDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.parallaxFactor = 0.3,
    this.layers = 3,
  });

  /// The animation driving the parallax effect.
  final Animation<double> animation;

  /// The child widget to animate.
  final Widget child;

  /// Factor controlling the speed difference between layers.
  ///
  /// Higher values create a more pronounced depth effect.
  final double parallaxFactor;

  /// Number of parallax layers to render.
  final int layers;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final progress = animation.value.clamp(0.0, 1.0);

        return Stack(
          children: List.generate(layers, (index) {
            // Deeper layers (lower index) move slower.
            final layerRatio = (index + 1) / layers;
            final layerOffset =
                (1.0 - progress) * parallaxFactor * (1.0 - layerRatio);

            // Front layers are fully opaque; back layers are more transparent.
            final opacity =
                (progress * (0.4 + 0.6 * layerRatio)).clamp(0.0, 1.0);

            return Transform.translate(
              offset: Offset(-layerOffset * 100.0, 0),
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            );
          }),
        );
      },
      child: child,
    );
  }
}

/// A widget that reveals its child through vertical curtain-like strips.
///
/// The view is divided into [splitCount] vertical strips that open
/// outward from the center, each with a slight time offset for a
/// staggered reveal. A fade effect accompanies the clip.
///
/// Example:
/// ```dart
/// NovaCurtainDrawerAnimation(
///   animation: controller,
///   child: drawerContent,
///   splitCount: 4,
/// )
/// ```
class NovaCurtainDrawerAnimation extends StatelessWidget {
  /// Creates a [NovaCurtainDrawerAnimation].
  const NovaCurtainDrawerAnimation({
    super.key,
    required this.animation,
    required this.child,
    this.splitCount = 2,
  });

  /// The animation driving the curtain reveal.
  final Animation<double> animation;

  /// The child widget to reveal.
  final Widget child;

  /// Number of vertical strips to split the view into.
  final int splitCount;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final totalWidth = constraints.maxWidth;
            final stripWidth = totalWidth / splitCount;

            return Stack(
              children: List.generate(splitCount, (index) {
                // Strips closer to the center animate first.
                final distanceFromCenter =
                    ((index + 0.5) - splitCount / 2.0).abs() /
                        (splitCount / 2.0);
                final staggerDelay = distanceFromCenter * 0.3;

                // Remap animation progress with stagger offset.
                final stripProgress = ((animation.value - staggerDelay) /
                        (1.0 - staggerDelay))
                    .clamp(0.0, 1.0);

                final stripLeft = index * stripWidth;

                return Positioned(
                  left: stripLeft,
                  top: 0,
                  bottom: 0,
                  width: stripWidth,
                  child: Opacity(
                    opacity: stripProgress,
                    child: ClipRect(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        widthFactor: stripProgress,
                        child: SizedBox(
                          width: stripWidth,
                          child: OverflowBox(
                            maxWidth: totalWidth,
                            alignment: Alignment.centerLeft,
                            child: Transform.translate(
                              offset: Offset(-stripLeft, 0),
                              child: child,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
      child: child,
    );
  }
}
