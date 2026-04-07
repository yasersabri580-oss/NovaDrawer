// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// A search bar widget with animated focus state for the drawer.
///
/// Provides a text input with search icon, clear button,
/// and smooth border/elevation animation on focus.
library;

import 'package:flutter/material.dart';

/// A search bar with animated focus state for use inside the drawer.
///
/// Example:
/// ```dart
/// DrawerSearchBar(
///   hintText: 'Search items…',
///   onChanged: (query) => filterItems(query),
///   onSubmitted: (query) => performSearch(query),
/// )
/// ```
class DrawerSearchBar extends StatefulWidget {
  /// Creates a [DrawerSearchBar].
  const DrawerSearchBar({
    super.key,
    this.controller,
    this.hintText = 'Search…',
    this.onChanged,
    this.onSubmitted,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  });

  /// Optional external text controller.
  final TextEditingController? controller;

  /// Placeholder text shown when the field is empty.
  final String hintText;

  /// Called each time the text changes.
  final ValueChanged<String>? onChanged;

  /// Called when the user submits the search (e.g. presses Enter).
  final ValueChanged<String>? onSubmitted;

  /// Outer padding around the search bar.
  final EdgeInsetsGeometry padding;

  @override
  State<DrawerSearchBar> createState() => _DrawerSearchBarState();
}

class _DrawerSearchBarState extends State<DrawerSearchBar> {
  late final TextEditingController _controller;
  bool _ownsController = false;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: widget.padding,
      child: Focus(
        onFocusChange: (focused) => setState(() => _hasFocus = focused),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withAlpha(
              _hasFocus ? 200 : 100,
            ),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(
              color: _hasFocus
                  ? colorScheme.primary.withAlpha(180)
                  : colorScheme.outline.withAlpha(60),
              width: _hasFocus ? 1.5 : 1.0,
            ),
          ),
          child: TextField(
            controller: _controller,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            style: Theme.of(context).textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: widget.hintText,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 10.0,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 20.0,
                color: _hasFocus ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              suffixIcon: _controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18.0),
                      onPressed: () {
                        _controller.clear();
                        widget.onChanged?.call('');
                      },
                      tooltip: 'Clear search',
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
