import 'package:flutter/material.dart';
import 'package:nova_drawer/nova_drawer.dart';

class HeaderShowcaseScreen extends StatefulWidget {
  const HeaderShowcaseScreen({super.key});

  @override
  State<HeaderShowcaseScreen> createState() => _HeaderShowcaseScreenState();
}

class _HeaderShowcaseScreenState extends State<HeaderShowcaseScreen> {
  final Map<NovaHeaderVariant, bool> _collapsedStates = {
    for (final v in NovaHeaderVariant.values) v: false,
  };

  static const profile = NovaHeaderUserProfile(
    name: 'Jane Developer',
    email: 'jane@example.com',
    role: 'Senior Engineer',
    status: NovaUserStatus.online,
    notificationCount: 5,
  );

  static const accounts = [
    NovaHeaderUserProfile(name: 'Alice', status: NovaUserStatus.online),
    NovaHeaderUserProfile(name: 'Bob', status: NovaUserStatus.busy),
    NovaHeaderUserProfile(name: 'Carol', status: NovaUserStatus.away),
  ];

  late final List<NovaHeaderAction> actions = [
    NovaHeaderAction(
      id: 'edit',
      icon: Icons.edit,
      tooltip: 'Edit profile',
      onTap: () => _showSnack('Edit tapped'),
    ),
    NovaHeaderAction(
      id: 'settings',
      icon: Icons.settings,
      tooltip: 'Settings',
      onTap: () => _showSnack('Settings tapped'),
    ),
    const NovaHeaderAction(
      id: 'notifications',
      icon: Icons.notifications,
      badge: 3,
      tooltip: 'Notifications',
    ),
  ];

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Header Variants')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: NovaHeaderVariant.values.map(_buildCard).toList(),
      ),
    );
  }

  Widget _buildCard(NovaHeaderVariant variant) {
    final isCollapsed = _collapsedStates[variant] ?? false;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildLabel(variant, isCollapsed),
          _buildHeader(variant, isCollapsed),
        ],
      ),
    );
  }

  Widget _buildLabel(NovaHeaderVariant variant, bool isCollapsed) {
    return InkWell(
      onTap: () => setState(() {
        _collapsedStates[variant] = !isCollapsed;
      }),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Text(
                variant.name[0].toUpperCase() + variant.name.substring(1),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            Icon(
              isCollapsed ? Icons.expand_more : Icons.expand_less,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(NovaHeaderVariant variant, bool isCollapsed) {
    return NovaDrawerHeader(
      config: _configFor(variant, isCollapsed),
    );
  }

  NovaHeaderConfig _configFor(NovaHeaderVariant variant, bool isCollapsed) {
    switch (variant) {
      case NovaHeaderVariant.classic:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.classic,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
        );

      case NovaHeaderVariant.glassmorphism:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.glassmorphism,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
          gradientColors: const [Colors.deepPurple, Colors.indigo],
        );

      case NovaHeaderVariant.compact:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.compact,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
        );

      case NovaHeaderVariant.hero:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.hero,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
          coverHeight: 120,
        );

      case NovaHeaderVariant.expanded:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.expanded,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
          isCollapsed: isCollapsed,
          enableCollapseExpand: true,
        );

      case NovaHeaderVariant.animatedGradient:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.animatedGradient,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
          gradientColors: const [
            Colors.purple,
            Colors.blue,
            Colors.teal,
          ],
        );

      case NovaHeaderVariant.avatarStack:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.avatarStack,
          profile: profile,
          accounts: accounts,
          showCloseButton: false,
          showPinButton: false,
        );

      case NovaHeaderVariant.multiAction:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.multiAction,
          profile: profile,
          actions: actions,
          showCloseButton: false,
          showPinButton: false,
        );

      case NovaHeaderVariant.statusAware:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.statusAware,
          profile: profile,
          showStatusIndicator: true,
          showCloseButton: false,
          showPinButton: false,
        );

      case NovaHeaderVariant.collapsible:
        return NovaHeaderConfig(
          variant: NovaHeaderVariant.collapsible,
          profile: profile,
          isCollapsed: isCollapsed,
          enableCollapseExpand: true,
          showCloseButton: false,
          showPinButton: false,
        );
    }
  }
}
