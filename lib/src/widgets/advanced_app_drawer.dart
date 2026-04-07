// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Main AdvancedAppDrawer widget.
///
/// The primary widget that assembles the full drawer experience,
/// including header, sections, items, animations, and responsive
/// behavior. This is the main entry point for using the package.
library;

import 'package:flutter/material.dart';

import '../models/drawer_item.dart';
import '../models/drawer_theme.dart';
import '../models/drawer_config.dart';
import '../controllers/drawer_controller.dart';
import '../animations/animation_wrapper.dart';
import '../animations/shimmer_animation.dart';
import '../utils/responsive_utils.dart';
import '../utils/accessibility_utils.dart';
import '../backgrounds/gradient_background.dart';
import '../backgrounds/particle_background.dart';
import 'drawer_header.dart';
import 'drawer_section.dart';
import 'drawer_item_widget.dart';
import 'nested_menu_item.dart';

/// The main AdvancedAppDrawer widget.
///
/// Provides a complete, fully-featured navigation drawer with
/// responsive layout, animations, theming, accessibility, and
/// support for nested/dynamic items.
///
/// Use [AdvancedAppDrawer] as a direct child inside a [Scaffold.drawer]
/// or within a [DrawerScaffoldWidget] for automatic responsive behavior.
///
/// Example:
/// ```dart
/// AdvancedAppDrawer(
///   controller: drawerController,
///   sections: [
///     DrawerSectionData(
///       id: 'main',
///       title: 'Menu',
///       items: [
///         DrawerItem(id: 'home', title: 'Home', icon: Icons.home),
///         DrawerItem(id: 'profile', title: 'Profile', icon: Icons.person),
///       ],
///     ),
///   ],
///   header: DrawerHeaderWidget(title: 'My App'),
///   onItemTap: (item) => print('Tapped: ${item.title}'),
/// )
/// ```
class AdvancedAppDrawer extends StatefulWidget {
  /// Creates an [AdvancedAppDrawer].
  const AdvancedAppDrawer({
    super.key,
    required this.controller,
    this.sections = const [],
    this.items = const [],
    this.header,
    this.footer,
    this.onItemTap,
    this.theme,
    this.config = const DrawerConfig(),
    this.width,
    this.backgroundWidget,
    this.enableGradientBackground = false,
    this.gradientColors,
    this.enableParticleBackground = false,
    this.particleColor,
    this.particleCount = 20,
  });

  /// Controller managing drawer state.
  final AdvancedDrawerController controller;

  /// Sections grouping related items.
  final List<DrawerSectionData> sections;

  /// Flat list of items (used when sections are empty).
  final List<DrawerItem> items;

  /// Header widget at the top of the drawer.
  final Widget? header;

  /// Footer widget at the bottom of the drawer.
  final Widget? footer;

  /// Callback when any item is tapped.
  final void Function(DrawerItem item)? onItemTap;

  /// Theme customization.
  final AdvancedDrawerTheme? theme;

  /// Behavior configuration.
  final DrawerConfig config;

  /// Override width (otherwise derived from responsive config).
  final double? width;

  /// Custom background widget.
  final Widget? backgroundWidget;

  /// Whether to use animated gradient background.
  final bool enableGradientBackground;

  /// Colors for the gradient background.
  final List<Color>? gradientColors;

  /// Whether to use particle effect background.
  final bool enableParticleBackground;

  /// Color for particles.
  final Color? particleColor;

  /// Number of particles.
  final int particleCount;

  @override
  State<AdvancedAppDrawer> createState() => _AdvancedAppDrawerState();
}

class _AdvancedAppDrawerState extends State<AdvancedAppDrawer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.config.animationConfig.duration,
      reverseDuration: widget.config.animationConfig.effectiveReverseDuration,
    );

    // Initialize sections in controller
    if (widget.sections.isNotEmpty) {
      widget.controller.setSections(widget.sections);
    }
    if (widget.items.isNotEmpty) {
      widget.controller.setItems(widget.items);
    }

    // Start the entrance animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final drawerTheme = widget.theme?.resolve(themeData) ??
        const AdvancedDrawerTheme().resolve(themeData);
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveWidth = widget.width ??
        ResponsiveUtils.getDrawerWidth(
          widget.controller.deviceType,
          drawerTheme,
        );

    return DrawerControllerProvider(
      controller: widget.controller,
      child: Semantics(
        label: widget.config.accessibilityConfig.drawerLabel,
        child: Material(
          elevation: drawerTheme.elevation ?? 1.0,
          shadowColor: drawerTheme.shadowColor,
          color: Colors.transparent,
          shape: drawerTheme.drawerShape,
          child: Container(
            width: effectiveWidth,
            decoration: _buildDecoration(drawerTheme),
            child: _buildContent(drawerTheme, isRtl),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(AdvancedDrawerTheme drawerTheme) {
    return BoxDecoration(
      color: drawerTheme.gradient == null
          ? drawerTheme.backgroundColor
          : null,
      gradient: drawerTheme.gradient,
      image: drawerTheme.backgroundImage,
      borderRadius: drawerTheme.borderRadius,
      border: drawerTheme.border,
    );
  }

  Widget _buildContent(AdvancedDrawerTheme drawerTheme, bool isRtl) {
    Widget content = Column(
      children: [
        // Header
        if (widget.header != null) widget.header!,

        // Loading state
        if (widget.controller.isLoading)
          _buildLoadingState(drawerTheme)
        // Error state
        else if (widget.controller.errorMessage != null)
          _buildErrorState(drawerTheme)
        // Content
        else
          Expanded(
            child: _buildScrollableContent(drawerTheme),
          ),

        // Footer
        if (widget.footer != null) ...[
          Divider(
            color: drawerTheme.dividerColor,
            height: 1.0,
          ),
          widget.footer!,
        ],
      ],
    );

    // Apply background effects
    if (widget.backgroundWidget != null) {
      content = Stack(
        children: [
          Positioned.fill(child: widget.backgroundWidget!),
          content,
        ],
      );
    }

    if (widget.enableGradientBackground) {
      content = DrawerGradientBackground(
        colors: widget.gradientColors,
        child: content,
      );
    }

    if (widget.enableParticleBackground) {
      content = DrawerParticleBackground(
        color: widget.particleColor,
        particleCount: widget.particleCount,
        child: content,
      );
    }

    // Apply entrance animation
    if (widget.config.animationConfig.enableItemAnimations) {
      content = DrawerAnimationWrapper(
        animation: _animationController,
        animationType: widget.config.animationType,
        animationConfig: widget.config.animationConfig,
        isRtl: isRtl,
        child: content,
      );
    }

    return ClipRect(child: content);
  }

  Widget _buildScrollableContent(AdvancedDrawerTheme drawerTheme) {
    final controller = widget.controller;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: drawerTheme.scrollbarTheme?.isAlwaysShown ?? false,
      child: ListView(
        controller: _scrollController,
        padding: drawerTheme.contentPadding,
        children: [
          // Sections
          if (widget.sections.isNotEmpty)
            for (final section in widget.sections)
              DrawerSectionWidget(
                section: section,
                onItemTap: widget.onItemTap,
                theme: widget.theme,
                config: widget.config,
              )
          // Flat items
          else
            for (final item in widget.items)
              if (item.isVisible && !controller.isItemHidden(item.id))
                _buildFlatItem(item, drawerTheme, controller),
        ],
      ),
    );
  }

  Widget _buildFlatItem(
    DrawerItem item,
    AdvancedDrawerTheme drawerTheme,
    AdvancedDrawerController controller,
  ) {
    if (item.customWidget != null) return item.customWidget!;

    final isSelected = controller.isSelected(item.id);

    if (item.hasChildren) {
      return NestedMenuItem(
        item: item,
        isSelected: isSelected,
        onItemTap: widget.onItemTap,
        theme: widget.theme,
        config: widget.config,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: DrawerItemWidget(
        item: item,
        isSelected: isSelected,
        onTap: () {
          controller.selectItem(item.id);
          widget.onItemTap?.call(item);
          item.onTap?.call();
          if (widget.config.closeOnItemTap &&
              controller.deviceType == DeviceType.mobile) {
            controller.close();
          }
        },
        theme: widget.theme,
        config: widget.config,
      ),
    );
  }

  Widget _buildLoadingState(AdvancedDrawerTheme drawerTheme) {
    return Expanded(
      child: ContinuousShimmer(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: List.generate(
              6,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: drawerTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: drawerTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(AdvancedDrawerTheme drawerTheme) {
    return Expanded(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load items',
                style: drawerTheme.itemTextStyle?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.controller.errorMessage ?? 'Unknown error',
                style: drawerTheme.subtitleTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: () {
                  // Re-trigger loading
                  widget.controller.notifyListeners();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
