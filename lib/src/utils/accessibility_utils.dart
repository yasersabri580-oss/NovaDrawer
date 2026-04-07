// Copyright (c) 2024 AdvancedAppDrawer Contributors
// Licensed under the MIT License.

/// Accessibility utilities for the AdvancedAppDrawer.
///
/// Provides helper methods for semantic annotations, focus management,
/// and screen-reader-friendly labeling.
library;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

import '../models/drawer_config.dart';
import '../models/drawer_item.dart';

/// Utility class for accessibility-related helpers.
class AccessibilityUtils {
  /// Private constructor – all members are static.
  const AccessibilityUtils._();

  /// Wraps a [child] widget with appropriate semantic annotations
  /// for a drawer item.
  static Widget wrapWithSemantics({
    required Widget child,
    required DrawerItem item,
    required bool isSelected,
    required DrawerAccessibilityConfig config,
    int? indexInList,
    int? listLength,
  }) {
    if (!config.enableSemantics) return child;

    final label = item.semanticLabel ?? item.title;
    final hint = item.hasChildren ? 'Double tap to expand' : 'Double tap to navigate';
    final stateDescription = isSelected ? 'Selected' : '';

    return Semantics(
      label: label,
      hint: hint,
      button: !item.hasChildren,
      enabled: item.isEnabled,
      selected: isSelected,
      value: stateDescription,
      sortKey: indexInList != null ? OrdinalSortKey(indexInList.toDouble()) : null,
      child: child,
    );
  }

  /// Wraps a [child] widget with a focus traversal group for
  /// keyboard navigation.
  static Widget wrapWithFocusTraversal({
    required Widget child,
    required DrawerAccessibilityConfig config,
    FocusNode? focusNode,
  }) {
    if (!config.enableFocusTraversal) return child;

    return Focus(
      focusNode: focusNode,
      child: child,
    );
  }

  /// Wraps a [child] widget with text scaling based on
  /// accessibility settings.
  static Widget wrapWithScalableText({
    required Widget child,
    required DrawerAccessibilityConfig config,
  }) {
    if (!config.enableScalableText) return child;

    return MediaQuery.withClampedTextScaling(
      minScaleFactor: 1.0,
      maxScaleFactor: 2.0,
      child: child,
    );
  }

  /// Announces a message to screen readers.
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, Directionality.of(context));
  }

  /// Creates an [ExcludeSemantics] wrapper to hide decorative elements.
  static Widget excludeFromSemantics({required Widget child}) {
    return ExcludeSemantics(child: child);
  }

  /// Ensures a widget meets minimum touch target size requirements.
  static Widget ensureMinimumTouchTarget({
    required Widget child,
    required double minimumSize,
  }) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: minimumSize,
        minHeight: minimumSize,
      ),
      child: child,
    );
  }

  /// Generates a semantic label for a drawer section header.
  static String sectionHeaderLabel(String sectionTitle, bool isExpanded) {
    return '$sectionTitle section, ${isExpanded ? 'expanded' : 'collapsed'}';
  }

  /// Generates a semantic label for a nested drawer item.
  static String nestedItemLabel(String title, int depth) {
    if (depth == 0) return title;
    return '$title, level ${depth + 1}';
  }

  /// Generates a semantic label for a badge.
  static String badgeLabel(DrawerItemBadge badge) {
    if (badge.count != null) return '${badge.count} notifications';
    if (badge.label != null) return badge.label!;
    return '';
  }
}
