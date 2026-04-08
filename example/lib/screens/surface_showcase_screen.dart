import 'package:flutter/material.dart';
import 'package:nova_drawer/nova_drawer.dart';

class SurfaceShowcaseScreen extends StatelessWidget {
  const SurfaceShowcaseScreen({super.key});

  static const _styles = NovaDrawerSurfaceStyle.values;

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

  Widget _buildCard(BuildContext context, NovaDrawerSurfaceStyle style) {
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
            child: NovaDrawerSurface(
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

  NovaDrawerSurfaceConfig _configFor(NovaDrawerSurfaceStyle style, BuildContext ctx) {
    switch (style) {
      case NovaDrawerSurfaceStyle.plain:
        return const NovaDrawerSurfaceConfig(style: NovaDrawerSurfaceStyle.plain);

      case NovaDrawerSurfaceStyle.elevated:
        return const NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.elevated,
          elevation: 8,
        );

      case NovaDrawerSurfaceStyle.glassmorphism:
        return const NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.glassmorphism,
          blurSigma: 12,
          opacity: 0.15,
        );

      case NovaDrawerSurfaceStyle.blurred:
        return const NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.blurred,
          blurSigma: 15,
        );

      case NovaDrawerSurfaceStyle.gradient:
        return const NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.gradient,
          gradientColors: [Colors.deepPurple, Colors.indigo, Colors.blue],
          gradientBegin: Alignment.topLeft,
          gradientEnd: Alignment.bottomRight,
        );

      case NovaDrawerSurfaceStyle.premiumShadow:
        return const NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.premiumShadow,
          elevation: 12,
          shadowColor: Colors.black54,
        );

      case NovaDrawerSurfaceStyle.outlinedMinimal:
        return NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.outlinedMinimal,
          border: Border.all(
            color: Theme.of(ctx).colorScheme.outline,
          ),
        );

      case NovaDrawerSurfaceStyle.neumorphic:
        return const NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.neumorphic,
          elevation: 4,
        );

      case NovaDrawerSurfaceStyle.imageBacked:
        return const NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.imageBacked,
          backgroundImage: AssetImage('assets/placeholder.png'),
          opacity: 0.3,
        );

      case NovaDrawerSurfaceStyle.animatedMeshGradient:
        return const NovaDrawerSurfaceConfig(
          style: NovaDrawerSurfaceStyle.animatedMeshGradient,
          meshColors: [
            Colors.purple,
            Colors.blue,
            Colors.teal,
            Colors.green,
          ],
        );
    }
  }

  IconData _iconFor(NovaDrawerSurfaceStyle style) {
    switch (style) {
      case NovaDrawerSurfaceStyle.plain:
        return Icons.rectangle_outlined;
      case NovaDrawerSurfaceStyle.elevated:
        return Icons.layers;
      case NovaDrawerSurfaceStyle.glassmorphism:
        return Icons.blur_on;
      case NovaDrawerSurfaceStyle.blurred:
        return Icons.blur_circular;
      case NovaDrawerSurfaceStyle.gradient:
        return Icons.gradient;
      case NovaDrawerSurfaceStyle.premiumShadow:
        return Icons.wb_shade;
      case NovaDrawerSurfaceStyle.outlinedMinimal:
        return Icons.crop_square;
      case NovaDrawerSurfaceStyle.neumorphic:
        return Icons.rounded_corner;
      case NovaDrawerSurfaceStyle.imageBacked:
        return Icons.image;
      case NovaDrawerSurfaceStyle.animatedMeshGradient:
        return Icons.auto_awesome;
    }
  }

  String _descriptionFor(NovaDrawerSurfaceStyle style) {
    switch (style) {
      case NovaDrawerSurfaceStyle.plain:
        return 'Flat surface with background color';
      case NovaDrawerSurfaceStyle.elevated:
        return 'Raised surface with shadow';
      case NovaDrawerSurfaceStyle.glassmorphism:
        return 'Frosted glass transparency effect';
      case NovaDrawerSurfaceStyle.blurred:
        return 'Background-blurred surface';
      case NovaDrawerSurfaceStyle.gradient:
        return 'Linear gradient fill';
      case NovaDrawerSurfaceStyle.premiumShadow:
        return 'Deep, premium shadow styling';
      case NovaDrawerSurfaceStyle.outlinedMinimal:
        return 'Clean outline, no fill';
      case NovaDrawerSurfaceStyle.neumorphic:
        return 'Soft neumorphic surface';
      case NovaDrawerSurfaceStyle.imageBacked:
        return 'Image as background';
      case NovaDrawerSurfaceStyle.animatedMeshGradient:
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
