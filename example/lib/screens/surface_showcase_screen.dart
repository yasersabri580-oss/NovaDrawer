import 'package:flutter/material.dart';
import 'package:nova_drawer/main.dart';

class SurfaceShowcaseScreen extends StatelessWidget {
  const SurfaceShowcaseScreen({super.key});

  static const _styles = DrawerSurfaceStyle.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Surface Styles')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _styles.length,
        itemBuilder: (context, index) => _buildCard(context, _styles[index]),
      ),
    );
  }

  Widget _buildCard(BuildContext context, DrawerSurfaceStyle style) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              _formatName(style.name),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(
            height: 140,
            child: DrawerSurface(
              config: _configFor(style, context),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _iconFor(style),
                      size: 32,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatName(style.name),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _descriptionFor(style),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DrawerSurfaceConfig _configFor(DrawerSurfaceStyle style, BuildContext ctx) {
    switch (style) {
      case DrawerSurfaceStyle.plain:
        return const DrawerSurfaceConfig(style: DrawerSurfaceStyle.plain);

      case DrawerSurfaceStyle.elevated:
        return const DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.elevated,
          elevation: 8,
        );

      case DrawerSurfaceStyle.glassmorphism:
        return const DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.glassmorphism,
          blurSigma: 12,
          opacity: 0.15,
        );

      case DrawerSurfaceStyle.blurred:
        return const DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.blurred,
          blurSigma: 15,
        );

      case DrawerSurfaceStyle.gradient:
        return const DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.gradient,
          gradientColors: [Colors.deepPurple, Colors.indigo, Colors.blue],
          gradientBegin: Alignment.topLeft,
          gradientEnd: Alignment.bottomRight,
        );

      case DrawerSurfaceStyle.premiumShadow:
        return const DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.premiumShadow,
          elevation: 12,
          shadowColor: Colors.black54,
        );

      case DrawerSurfaceStyle.outlinedMinimal:
        return DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.outlinedMinimal,
          border: Border.all(
            color: Theme.of(ctx).colorScheme.outline,
          ),
        );

      case DrawerSurfaceStyle.neumorphic:
        return const DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.neumorphic,
          elevation: 4,
        );

      case DrawerSurfaceStyle.imageBacked:
        return const DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.imageBacked,
          backgroundImage: AssetImage('assets/placeholder.png'),
          opacity: 0.3,
        );

      case DrawerSurfaceStyle.animatedMeshGradient:
        return const DrawerSurfaceConfig(
          style: DrawerSurfaceStyle.animatedMeshGradient,
          meshColors: [
            Colors.purple,
            Colors.blue,
            Colors.teal,
            Colors.green,
          ],
        );
    }
  }

  IconData _iconFor(DrawerSurfaceStyle style) {
    switch (style) {
      case DrawerSurfaceStyle.plain:
        return Icons.rectangle_outlined;
      case DrawerSurfaceStyle.elevated:
        return Icons.layers;
      case DrawerSurfaceStyle.glassmorphism:
        return Icons.blur_on;
      case DrawerSurfaceStyle.blurred:
        return Icons.blur_circular;
      case DrawerSurfaceStyle.gradient:
        return Icons.gradient;
      case DrawerSurfaceStyle.premiumShadow:
        return Icons.wb_shade;
      case DrawerSurfaceStyle.outlinedMinimal:
        return Icons.crop_square;
      case DrawerSurfaceStyle.neumorphic:
        return Icons.rounded_corner;
      case DrawerSurfaceStyle.imageBacked:
        return Icons.image;
      case DrawerSurfaceStyle.animatedMeshGradient:
        return Icons.auto_awesome;
    }
  }

  String _descriptionFor(DrawerSurfaceStyle style) {
    switch (style) {
      case DrawerSurfaceStyle.plain:
        return 'Flat surface with background color';
      case DrawerSurfaceStyle.elevated:
        return 'Raised surface with shadow';
      case DrawerSurfaceStyle.glassmorphism:
        return 'Frosted glass transparency effect';
      case DrawerSurfaceStyle.blurred:
        return 'Background-blurred surface';
      case DrawerSurfaceStyle.gradient:
        return 'Linear gradient fill';
      case DrawerSurfaceStyle.premiumShadow:
        return 'Deep, premium shadow styling';
      case DrawerSurfaceStyle.outlinedMinimal:
        return 'Clean outline, no fill';
      case DrawerSurfaceStyle.neumorphic:
        return 'Soft neumorphic surface';
      case DrawerSurfaceStyle.imageBacked:
        return 'Image as background';
      case DrawerSurfaceStyle.animatedMeshGradient:
        return 'Animated mesh gradient';
    }
  }

  String _formatName(String name) {
    return name
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}')
        .replaceFirst(name[0], name[0].toUpperCase())
        .trim();
  }
}
