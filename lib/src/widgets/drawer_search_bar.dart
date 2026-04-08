// Copyright (c) 2024 NovaDrawer Contributors
// Licensed under the MIT License.

/// A search bar widget powered by the `search_plus` package for the drawer.
///
/// Wraps [SearchPlusBar] from `search_plus` with drawer-friendly defaults,
/// providing debounced search, animated focus, history support, and theming.
library;


import 'package:flutter/material.dart';
import 'package:search_plus/search_plus.dart';

/// A drawer search bar powered by the `search_plus` package.
///
/// Uses [SearchPlusController] and [SearchPlusBar] under the hood to provide
/// debounced, themeable search with optional history, suggestions, and
/// overlay results — all within the drawer context.
///
/// Example:
/// ```dart
/// NovaDrawerSearchBar<String>(
///   controller: mySearchController,
///   hintText: 'Search items…',
///   onResultSelected: (result) => navigateTo(result.data),
/// )
/// ```
///
/// For a simple callback-based usage without a controller:
/// ```dart
/// NovaDrawerSearchBar<String>.simple(
///   items: ['Home', 'Settings', 'Profile'],
///   searchableFields: (item) => [item],
///   toResult: (item) => SearchResult(id: item, title: item, data: item),
///   hintText: 'Search menu…',
///   onChanged: (query) => filterDrawerItems(query),
/// )
/// ```
class NovaDrawerSearchBar<T> extends StatefulWidget {
  /// Creates a [NovaDrawerSearchBar] with an externally managed controller.
  const NovaDrawerSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search…',
    this.onResultSelected,
    this.onChanged,
    this.showOverlayResults = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.animationConfig,
    this.themeData,
  }) : _items = null,
       _searchableFields = null,
       _toResult = null;

  /// Creates a simple [NovaDrawerSearchBar] with a built-in local adapter.
  ///
  /// Automatically creates and manages a [SearchPlusController] with a
  /// [LocalSearchAdapter] from the provided [items].
  const NovaDrawerSearchBar.simple({
    super.key,
    required List<T> items,
    required List<String> Function(T) searchableFields,
    required SearchResult<T> Function(T) toResult,
    this.hintText = 'Search…',
    this.onResultSelected,
    this.onChanged,
    this.showOverlayResults = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.animationConfig,
    this.themeData,
  }) : controller = null,
       _items = items,
       _searchableFields = searchableFields,
       _toResult = toResult;

  /// External search controller. If null, a simple local adapter is created.
  final SearchPlusController<T>? controller;

  /// Placeholder text shown when the field is empty.
  final String hintText;

  /// Called when a search result is selected.
  final void Function(SearchResult<T> result)? onResultSelected;

  /// Called each time the search query text changes.
  final ValueChanged<String>? onChanged;

  /// Whether to show an overlay dropdown with search results.
  final bool showOverlayResults;

  /// Outer padding around the search bar.
  final EdgeInsetsGeometry padding;

  /// Optional animation configuration for search results.
  final SearchAnimationConfig? animationConfig;

  /// Optional theme data to customize the search bar appearance.
  final SearchPlusThemeData? themeData;

  // Private fields for the simple constructor.
  final List<T>? _items;
  final List<String> Function(T)? _searchableFields;
  final SearchResult<T> Function(T)? _toResult;

  @override
  State<NovaDrawerSearchBar<T>> createState() => _NovaDrawerSearchBarState<T>();
}

class _NovaDrawerSearchBarState<T> extends State<NovaDrawerSearchBar<T>> {
  SearchPlusController<T>? _ownedController;

  SearchPlusController<T> get _controller =>
      widget.controller ?? _ownedController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownedController = SearchPlusController<T>(
        adapter: LocalSearchAdapter<T>(
          items: widget._items!,
          searchableFields: widget._searchableFields!,
          toResult: widget._toResult!,
        ),
      );
    }
 
  }

  @override
  void dispose() {
  
    _ownedController?.dispose();
    super.dispose();
  }

 
  @override
  Widget build(BuildContext context) {
    Widget searchBar = SearchPlusBar(

      controller: widget.controller ?? _ownedController!,
      hintText: widget.hintText,
      onChanged: widget.onChanged?.call, 
      
      onSubmitted: widget.onResultSelected != null
          ? (query) {
           
                widget.onResultSelected!(SearchResult(id: query, title: query));
              
            }
          : null,

    );

    if (widget.themeData != null) {
      searchBar = SearchTheme(data: widget.themeData!, child: searchBar);
    }

    return Padding(padding: widget.padding, child: searchBar);
  }
}
