import 'package:flutter/material.dart';
import 'package:nova_drawer/main.dart';

class AnimationShowcaseScreen extends StatefulWidget {
  const AnimationShowcaseScreen({super.key});

  @override
  State<AnimationShowcaseScreen> createState() =>
      _AnimationShowcaseScreenState();
}

class _AnimationShowcaseScreenState extends State<AnimationShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  DrawerAnimationType _selectedType = DrawerAnimationType.slide;
  bool _isForward = false;

  static const _types = DrawerAnimationType.values;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        setState(() {
          _isForward = status == AnimationStatus.completed;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _play() {
    if (_isForward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  void _reset() {
    _controller.reset();
    setState(() => _isForward = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Animations')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Controls ---
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Animation Type',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<DrawerAnimationType>(
                      value: _selectedType,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _types
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(_formatName(t.name)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _reset();
                          setState(() => _selectedType = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _play,
                            icon: Icon(
                              _isForward ? Icons.replay : Icons.play_arrow,
                            ),
                            label: Text(_isForward ? 'Reverse' : 'Play'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // --- Preview ---
            Expanded(
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withAlpha(80),
                  ),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return DrawerAnimationWrapper(
                          animation: _controller,
                          animationType: _selectedType,
                          animationConfig: const DrawerAnimationConfig(
                            duration: Duration(milliseconds: 600),
                            curve: Curves.easeInOutCubic,
                          ),
                          child: _previewContent(theme),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),
            Text(
              _descriptionFor(_selectedType),
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _previewContent(ThemeData theme) {
    return Container(
      width: 200,
      height: 140,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.widgets, size: 36, color: theme.colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            _formatName(_selectedType.name),
            style: theme.textTheme.titleSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  String _descriptionFor(DrawerAnimationType type) {
    switch (type) {
      case DrawerAnimationType.slide:
        return 'Slides in from the side';
      case DrawerAnimationType.fade:
        return 'Fades in/out with opacity';
      case DrawerAnimationType.scale:
        return 'Scales up/down from center';
      case DrawerAnimationType.rotate:
        return 'Rotates in/out with perspective';
      case DrawerAnimationType.morph:
        return 'Morphs between shapes';
      case DrawerAnimationType.elastic:
        return 'Elastic bounce effect';
      case DrawerAnimationType.spring:
        return 'Spring physics-based motion';
      case DrawerAnimationType.shimmer:
        return 'Shimmer highlight sweep';
      case DrawerAnimationType.blur:
        return 'Blur transition effect';
      case DrawerAnimationType.gradient:
        return 'Gradient color transition';
    }
  }

  String _formatName(String name) {
    return name
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}')
        .replaceFirst(name[0], name[0].toUpperCase())
        .trim();
  }
}
