// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Enum representing the visual surface style of the drawer.
enum NovaDrawerSurfaceStyle {
  /// Plain flat surface with background color only.
  plain,

  /// Elevated surface with shadow.
  elevated,

  /// Glassmorphism with blur and transparency.
  glassmorphism,

  /// Background-blurred surface.
  blurred,

  /// Gradient-filled surface.
  gradient,

  /// Premium shadow-heavy surface.
  premiumShadow,

  /// Outlined minimal surface.
  outlinedMinimal,

  /// Neumorphic subtle surface.
  neumorphic,

  /// Image-backed surface.
  imageBacked,

  /// Animated mesh gradient surface.
  animatedMeshGradient,
}

/// Configuration for the drawer surface appearance.
///
/// Controls the visual style of the drawer panel itself.
class NovaDrawerSurfaceConfig {
  /// Creates a surface configuration.
  const NovaDrawerSurfaceConfig({
    this.style = NovaDrawerSurfaceStyle.plain,
    this.backgroundColor,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
    this.blurSigma = 10.0,
    this.opacity = 1.0,
    this.elevation = 0.0,
    this.borderRadius,
    this.border,
    this.shadowColor,
    this.backgroundImage,
    this.backgroundImageFit = BoxFit.cover,
    this.meshColors,
    this.customSurfaceBuilder,
  });

  /// The surface style to use.
  final NovaDrawerSurfaceStyle style;

  /// Background color for the surface.
  final Color? backgroundColor;

  /// Colors for gradient-based surfaces.
  final List<Color>? gradientColors;

  /// Start alignment for gradients.
  final AlignmentGeometry? gradientBegin;

  /// End alignment for gradients.
  final AlignmentGeometry? gradientEnd;

  /// Blur sigma for glassmorphism and blurred surfaces.
  final double blurSigma;

  /// Surface opacity.
  final double opacity;

  /// Elevation for elevated and shadow surfaces.
  final double elevation;

  /// Border radius for the surface.
  final BorderRadiusGeometry? borderRadius;

  /// Border for outlined surfaces.
  final BoxBorder? border;

  /// Shadow color for elevated surfaces.
  final Color? shadowColor;

  /// Background image for image-backed surfaces.
  final ImageProvider? backgroundImage;

  /// How the background image is fit.
  final BoxFit backgroundImageFit;

  /// Colors for the animated mesh gradient.
  final List<Color>? meshColors;

  /// A custom builder that replaces the default surface rendering.
  final Widget Function(BuildContext context, Widget child)?
      customSurfaceBuilder;

  /// Creates a copy with the given fields replaced.
  NovaDrawerSurfaceConfig copyWith({
    NovaDrawerSurfaceStyle? style,
    Color? backgroundColor,
    List<Color>? gradientColors,
    AlignmentGeometry? gradientBegin,
    AlignmentGeometry? gradientEnd,
    double? blurSigma,
    double? opacity,
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    BoxBorder? border,
    Color? shadowColor,
    ImageProvider? backgroundImage,
    BoxFit? backgroundImageFit,
    List<Color>? meshColors,
    Widget Function(BuildContext, Widget)? customSurfaceBuilder,
  }) {
    return NovaDrawerSurfaceConfig(
      style: style ?? this.style,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradientColors: gradientColors ?? this.gradientColors,
      gradientBegin: gradientBegin ?? this.gradientBegin,
      gradientEnd: gradientEnd ?? this.gradientEnd,
      blurSigma: blurSigma ?? this.blurSigma,
      opacity: opacity ?? this.opacity,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      border: border ?? this.border,
      shadowColor: shadowColor ?? this.shadowColor,
      backgroundImage: backgroundImage ?? this.backgroundImage,
      backgroundImageFit: backgroundImageFit ?? this.backgroundImageFit,
      meshColors: meshColors ?? this.meshColors,
      customSurfaceBuilder: customSurfaceBuilder ?? this.customSurfaceBuilder,
    );
  }
}

/// Widget that renders the drawer surface based on [NovaDrawerSurfaceConfig].
class NovaDrawerSurface extends StatelessWidget {
  /// Creates a drawer surface.
  const NovaDrawerSurface({
    super.key,
    required this.child,
    this.config = const NovaDrawerSurfaceConfig(),
  });

  /// The content to display inside the surface.
  final Widget child;

  /// The surface configuration.
  final NovaDrawerSurfaceConfig config;

  @override
  Widget build(BuildContext context) {
    if (config.customSurfaceBuilder != null) {
      return config.customSurfaceBuilder!(context, child);
    }

    switch (config.style) {
      case NovaDrawerSurfaceStyle.plain:
        return _buildPlain();
      case NovaDrawerSurfaceStyle.elevated:
        return _buildElevated();
      case NovaDrawerSurfaceStyle.glassmorphism:
        return _buildGlassmorphism();
      case NovaDrawerSurfaceStyle.blurred:
        return _buildBlurred();
      case NovaDrawerSurfaceStyle.gradient:
        return _buildGradient();
      case NovaDrawerSurfaceStyle.premiumShadow:
        return _buildPremiumShadow();
      case NovaDrawerSurfaceStyle.outlinedMinimal:
        return _buildOutlinedMinimal();
      case NovaDrawerSurfaceStyle.neumorphic:
        return _buildNeumorphic();
      case NovaDrawerSurfaceStyle.imageBacked:
        return _buildImageBacked();
      case NovaDrawerSurfaceStyle.animatedMeshGradient:
        return _buildAnimatedMeshGradient();
    }
  }

  Widget _buildPlain() {
    return Container(
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: config.borderRadius,
      ),
      child: child,
    );
  }

  Widget _buildElevated() {
    return Container(
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: config.borderRadius,
        boxShadow: [
          BoxShadow(
            color: config.shadowColor ?? const Color(0x33000000),
            blurRadius: config.elevation * 2,
            offset: Offset(0, config.elevation),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildGlassmorphism() {
    return ClipRRect(
      borderRadius:
          (config.borderRadius as BorderRadius?) ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: config.blurSigma,
          sigmaY: config.blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: (config.backgroundColor ?? const Color(0xFFFFFFFF))
                .withValues(alpha: config.opacity * 0.2),
            borderRadius: config.borderRadius,
            border: config.border ??
                Border.all(
                  color: const Color(0x33FFFFFF),
                  width: 1.5,
                ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildBlurred() {
    return ClipRRect(
      borderRadius:
          (config.borderRadius as BorderRadius?) ?? BorderRadius.zero,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: config.blurSigma,
          sigmaY: config.blurSigma,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: (config.backgroundColor ?? const Color(0xFF000000))
                .withValues(alpha: config.opacity * 0.5),
            borderRadius: config.borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildGradient() {
    final colors = config.gradientColors ??
        const [Color(0xFF6366F1), Color(0xFF8B5CF6)];
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: (config.gradientBegin ?? Alignment.topLeft) as Alignment,
          end: (config.gradientEnd ?? Alignment.bottomRight) as Alignment,
        ),
        borderRadius: config.borderRadius,
      ),
      child: child,
    );
  }

  Widget _buildPremiumShadow() {
    return Container(
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: config.borderRadius,
        boxShadow: [
          BoxShadow(
            color: config.shadowColor ?? const Color(0x4D000000),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 4,
          ),
          BoxShadow(
            color: (config.shadowColor ?? const Color(0x1A000000))
                .withValues(alpha: 0.1),
            blurRadius: 48,
            offset: const Offset(0, 16),
            spreadRadius: 8,
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildOutlinedMinimal() {
    return Container(
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: config.borderRadius,
        border: config.border ??
            Border.all(
              color: const Color(0x1A000000),
              width: 1.0,
            ),
      ),
      child: child,
    );
  }

  Widget _buildNeumorphic() {
    final bg = config.backgroundColor ?? const Color(0xFFE0E5EC);
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: config.borderRadius ?? BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFFFFF).withValues(alpha: 0.7),
            blurRadius: 10,
            offset: const Offset(-5, -5),
          ),
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(5, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildImageBacked() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: config.borderRadius,
        image: config.backgroundImage != null
            ? DecorationImage(
                image: config.backgroundImage!,
                fit: config.backgroundImageFit,
              )
            : null,
        color: config.backgroundImage == null ? config.backgroundColor : null,
      ),
      child: child,
    );
  }

  Widget _buildAnimatedMeshGradient() {
    // Animated mesh gradient uses a simplified gradient approach
    // since true mesh gradients require custom painting.
    final colors = config.meshColors ??
        config.gradientColors ??
        const [
          Color(0xFF6366F1),
          Color(0xFF8B5CF6),
          Color(0xFFEC4899),
          Color(0xFF3B82F6),
        ];
    return _AnimatedMeshGradientSurface(
      colors: colors,
      borderRadius: config.borderRadius,
      child: child,
    );
  }
}

class _AnimatedMeshGradientSurface extends StatefulWidget {
  const _AnimatedMeshGradientSurface({
    required this.child,
    required this.colors,
    this.borderRadius,
  });

  final Widget child;
  final List<Color> colors;
  final BorderRadiusGeometry? borderRadius;

  @override
  State<_AnimatedMeshGradientSurface> createState() =>
      _AnimatedMeshGradientSurfaceState();
}

class _AnimatedMeshGradientSurfaceState
    extends State<_AnimatedMeshGradientSurface>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        // Shift gradient alignment based on animation progress.
        final begin = Alignment(
          -1.0 + t * 2.0,
          -1.0 + t,
        );
        final end = Alignment(
          1.0 - t,
          1.0 - t * 0.5,
        );
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.colors,
              begin: begin,
              end: end,
            ),
            borderRadius: widget.borderRadius,
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
