// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// A horizontally scrollable row of filter chips for the drawer.
///
/// Wraps Flutter's [FilterChip] with optional icons and accent
/// colors, driven by [DrawerFilterChip] data models.
library;

import 'package:flutter/material.dart';

import '../models/content_config.dart';

/// A horizontal row of selectable [DrawerFilterChip] items.
///
/// Example:
/// ```dart
/// DrawerFilterChips(
///   chips: [
///     DrawerFilterChip(id: 'all', label: 'All', isSelected: true),
///     DrawerFilterChip(id: 'docs', label: 'Docs', icon: Icons.article),
///     DrawerFilterChip(id: 'images', label: 'Images', icon: Icons.image),
///   ],
/// )
/// ```
class DrawerFilterChips extends StatelessWidget {
  /// Creates a [DrawerFilterChips] widget.
  const DrawerFilterChips({
    super.key,
    required this.chips,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  /// The filter chips to display.
  final List<DrawerFilterChip> chips;

  /// Outer padding around the chip row.
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (int i = 0; i < chips.length; i++) ...[
              if (i > 0) const SizedBox(width: 8.0),
              _buildChip(context, chips[i]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, DrawerFilterChip chip) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = chip.color ?? colorScheme.primary;

    return FilterChip(
      label: Text(chip.label),
      selected: chip.isSelected,
      onSelected: chip.onSelected,
      avatar: chip.icon != null
          ? Icon(chip.icon, size: 16.0, color: accentColor)
          : null,
      selectedColor: accentColor.withAlpha(40),
      checkmarkColor: accentColor,
      side: BorderSide(
        color: chip.isSelected
            ? accentColor.withAlpha(120)
            : colorScheme.outline.withAlpha(60),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
