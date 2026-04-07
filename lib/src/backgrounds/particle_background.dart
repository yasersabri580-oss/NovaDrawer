// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Particle background for the AdvancedAppDrawer.
///
/// Provides floating particle effects for a dynamic, modern
/// drawer background.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// An animated particle effects background for the drawer.
///
/// Renders floating circular particles that drift and fade
/// for a subtle, modern ambient effect.
///
/// Example:
/// ```dart
/// DrawerParticleBackground(
///   particleCount: 30,
///   color: Colors.white.withOpacity(0.1),
///   child: drawerContent,
/// )
/// ```
class DrawerParticleBackground extends StatefulWidget {
  /// Creates a [DrawerParticleBackground].
  const DrawerParticleBackground({
    super.key,
    required this.child,
    this.particleCount = 20,
    this.color,
    this.maxRadius = 4.0,
    this.minRadius = 1.0,
    this.speed = 0.5,
    this.enabled = true,
    this.opacity = 0.3,
  });

  /// The child widget displayed on top.
  final Widget child;

  /// Number of particles to render.
  final int particleCount;

  /// Color of the particles. Defaults to theme primary color.
  final Color? color;

  /// Maximum particle radius.
  final double maxRadius;

  /// Minimum particle radius.
  final double minRadius;

  /// Animation speed multiplier.
  final double speed;

  /// Whether particle animation is active.
  final bool enabled;

  /// Global opacity of particles.
  final double opacity;

  @override
  State<DrawerParticleBackground> createState() =>
      _DrawerParticleBackgroundState();
}

class _DrawerParticleBackgroundState extends State<DrawerParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<_Particle> _particles;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    _particles = _generateParticles();
    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(DrawerParticleBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
    if (widget.particleCount != oldWidget.particleCount) {
      _particles = _generateParticles();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_Particle> _generateParticles() {
    return List.generate(widget.particleCount, (index) {
      return _Particle(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        radius: widget.minRadius +
            _random.nextDouble() * (widget.maxRadius - widget.minRadius),
        speedX: (_random.nextDouble() - 0.5) * widget.speed * 0.01,
        speedY: (_random.nextDouble() - 0.5) * widget.speed * 0.01,
        opacity: 0.2 + _random.nextDouble() * 0.6,
        phase: _random.nextDouble() * math.pi * 2,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final particleColor = widget.color ??
        Theme.of(context).colorScheme.primary;

    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _ParticlePainter(
                    particles: _particles,
                    color: particleColor,
                    animationValue: _controller.value,
                    globalOpacity: widget.opacity,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Internal data class representing a single particle.
class _Particle {
  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    required this.phase,
  });

  double x;
  double y;
  final double radius;
  final double speedX;
  final double speedY;
  final double opacity;
  final double phase;
}

/// Custom painter that renders the particle field.
class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.particles,
    required this.color,
    required this.animationValue,
    required this.globalOpacity,
  });

  final List<_Particle> particles;
  final Color color;
  final double animationValue;
  final double globalOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // Calculate position based on animation time
      final t = animationValue * 2 * math.pi;
      final x = (particle.x +
              particle.speedX * math.sin(t + particle.phase) * 10) %
          1.0;
      final y = (particle.y +
              particle.speedY * math.cos(t + particle.phase) * 10) %
          1.0;

      // Pulsing opacity
      final pulseOpacity =
          particle.opacity * (0.7 + 0.3 * math.sin(t * 2 + particle.phase));

      final paint = Paint()
        ..color = color.withAlpha(
            (pulseOpacity * globalOpacity * 255).round().clamp(0, 255))
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x * size.width, y * size.height),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
