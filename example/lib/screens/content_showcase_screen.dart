import 'package:flutter/material.dart';
import 'package:nova_drawer/main.dart';

class ContentShowcaseScreen extends StatefulWidget {
  const ContentShowcaseScreen({super.key});

  @override
  State<ContentShowcaseScreen> createState() => _ContentShowcaseScreenState();
}

class _ContentShowcaseScreenState extends State<ContentShowcaseScreen> {
  String _searchQuery = '';
  final Set<String> _selectedFilters = {'all'};

  // --- Sample data ---

  static const _stats = [
    NovaDrawerStatItem(
      label: 'Projects',
      value: '42',
      icon: Icons.folder_outlined,
    ),
    NovaDrawerStatItem(
      label: 'Tasks',
      value: '128',
      icon: Icons.task_alt,
    ),
    NovaDrawerStatItem(
      label: 'Stars',
      value: '1.2K',
      icon: Icons.star_outline,
    ),
    NovaDrawerStatItem(
      label: 'Team',
      value: '8',
      icon: Icons.group_outlined,
    ),
  ];

  static const _shortcuts = [
    NovaDrawerShortcut(
      id: 'new_file',
      label: 'New File',
      icon: Icons.note_add,
      color: Colors.blue,
    ),
    NovaDrawerShortcut(
      id: 'upload',
      label: 'Upload',
      icon: Icons.upload_file,
      color: Colors.green,
    ),
    NovaDrawerShortcut(
      id: 'share',
      label: 'Share',
      icon: Icons.share,
      color: Colors.orange,
    ),
    NovaDrawerShortcut(
      id: 'export',
      label: 'Export',
      icon: Icons.download,
      color: Colors.purple,
    ),
    NovaDrawerShortcut(
      id: 'calendar',
      label: 'Calendar',
      icon: Icons.calendar_month,
      color: Colors.red,
    ),
    NovaDrawerShortcut(
      id: 'chat',
      label: 'Chat',
      icon: Icons.chat_bubble_outline,
      color: Colors.teal,
      badge: 2,
    ),
  ];

  late final List<NovaDrawerRecentItem> _recentItems = [
    NovaDrawerRecentItem(
      id: '1',
      title: 'Project Alpha',
      subtitle: 'Last edited 5 min ago',
      icon: Icons.folder,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NovaDrawerRecentItem(
      id: '2',
      title: 'Design System v2',
      subtitle: 'Shared by Alice',
      icon: Icons.design_services,
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    NovaDrawerRecentItem(
      id: '3',
      title: 'Sprint Retro Notes',
      subtitle: 'Meeting notes',
      icon: Icons.sticky_note_2,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static const _workspaces = [
    NovaDrawerWorkspace(
      id: 'personal',
      name: 'Personal',
      icon: Icons.person,
      isActive: true,
    ),
    NovaDrawerWorkspace(
      id: 'team',
      name: 'Team Nova',
      icon: Icons.groups,
    ),
    NovaDrawerWorkspace(
      id: 'org',
      name: 'Acme Corp',
      icon: Icons.business,
    ),
  ];

  static const _appStatus = NovaDrawerAppStatus(
    isOnline: true,
    statusMessage: 'All systems operational',
    version: '1.4.0',
    buildNumber: '2024.06.15',
  );

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Content Widgets')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Search Bar', _buildSearchBar()),
          _section('Stats Card', _buildStatsCard()),
          _section('Shortcuts Grid', _buildShortcutsGrid()),
          _section('Recent Items', _buildRecentItems()),
          _section('Filter Chips', _buildFilterChips()),
          _section('Workspace Switcher', _buildWorkspaceSwitcher()),
          _section('App Status', _buildAppStatus()),
        ],
      ),
    );
  }

  Widget _section(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: child,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // --- Widgets ---

  Widget _buildSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NovaDrawerSearchBar<String>.simple(
          items: const ['Home', 'Settings', 'Profile', 'Dashboard', 'Analytics'],
          searchableFields: (item) => [item],
          toResult: (item) => SearchResult(id: item, title: item, data: item),
          hintText: 'Search items…',
          onChanged: (v) => setState(() => _searchQuery = v),
        ),
        if (_searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              'Query: "$_searchQuery"',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }


  Widget _buildStatsCard() {
    return const NovaDrawerStatsCard(items: _stats);
  }

  Widget _buildShortcutsGrid() {
    return const NovaDrawerShortcutsGrid(
      shortcuts: _shortcuts,
      crossAxisCount: 3,
    );
  }

  Widget _buildRecentItems() {
    return NovaDrawerRecentItems(items: _recentItems);
  }

  Widget _buildFilterChips() {
    const chipDefs = [
      ('all', 'All', Icons.select_all),
      ('active', 'Active', Icons.play_circle_outline),
      ('archived', 'Archived', Icons.archive_outlined),
      ('starred', 'Starred', Icons.star_outline),
      ('mine', 'Mine', Icons.person_outline),
    ];

    return NovaDrawerFilterChipsWidget(
      chips: chipDefs
          .map((c) => NovaDrawerFilterChip(
                id: c.$1,
                label: c.$2,
                icon: c.$3,
                isSelected: _selectedFilters.contains(c.$1),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFilters.add(c.$1);
                    } else {
                      _selectedFilters.remove(c.$1);
                    }
                  });
                },
              ))
          .toList(),
    );
  }

  Widget _buildWorkspaceSwitcher() {
    return const NovaDrawerWorkspaceSwitcher(workspaces: _workspaces);
  }

  Widget _buildAppStatus() {
    return const NovaDrawerAppStatusWidget(status: _appStatus);
  }
}
