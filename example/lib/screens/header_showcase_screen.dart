import 'package:flutter/material.dart';
import 'package:nova_drawer/main.dart';

class HeaderShowcaseScreen extends StatefulWidget {
  const HeaderShowcaseScreen({super.key});

  @override
  State<HeaderShowcaseScreen> createState() => _HeaderShowcaseScreenState();
}

class _HeaderShowcaseScreenState extends State<HeaderShowcaseScreen> {
  final Map<HeaderVariant, bool> _collapsedStates = {
    for (final v in HeaderVariant.values) v: false,
  };

  static const profile = HeaderUserProfile(
    name: 'Jane Developer',
    email: 'jane@example.com',
    role: 'Senior Engineer',
    status: UserStatus.online,
    notificationCount: 5,
  );

  static const accounts = [
    HeaderUserProfile(name: 'Alice', status: UserStatus.online),
    HeaderUserProfile(name: 'Bob', status: UserStatus.busy),
    HeaderUserProfile(name: 'Carol', status: UserStatus.away),
  ];

  late final List<HeaderAction> actions = [
    HeaderAction(
      id: 'edit',
      icon: Icons.edit,
      tooltip: 'Edit profile',
      onTap: () => _showSnack('Edit tapped'),
    ),
    HeaderAction(
      id: 'settings',
      icon: Icons.settings,
      tooltip: 'Settings',
      onTap: () => _showSnack('Settings tapped'),
    ),
    const HeaderAction(
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
        children: HeaderVariant.values.map(_buildCard).toList(),
      ),
    );
  }

  Widget _buildCard(HeaderVariant variant) {
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

  Widget _buildLabel(HeaderVariant variant, bool isCollapsed) {
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

  Widget _buildHeader(HeaderVariant variant, bool isCollapsed) {
    return NovaDrawerHeader(
      config: _configFor(variant, isCollapsed),
    );
  }

  NovaHeaderConfig _configFor(HeaderVariant variant, bool isCollapsed) {
    switch (variant) {
      case HeaderVariant.classic:
        return NovaHeaderConfig(
          variant: HeaderVariant.classic,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
        );

      case HeaderVariant.glassmorphism:
        return NovaHeaderConfig(
          variant: HeaderVariant.glassmorphism,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
          gradientColors: const [Colors.deepPurple, Colors.indigo],
        );

      case HeaderVariant.compact:
        return NovaHeaderConfig(
          variant: HeaderVariant.compact,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
        );

      case HeaderVariant.hero:
        return NovaHeaderConfig(
          variant: HeaderVariant.hero,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
          coverHeight: 120,
        );

      case HeaderVariant.expanded:
        return NovaHeaderConfig(
          variant: HeaderVariant.expanded,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
          isCollapsed: isCollapsed,
          enableCollapseExpand: true,
        );

      case HeaderVariant.animatedGradient:
        return NovaHeaderConfig(
          variant: HeaderVariant.animatedGradient,
          profile: profile,
          showCloseButton: false,
          showPinButton: false,
          gradientColors: const [
            Colors.purple,
            Colors.blue,
            Colors.teal,
          ],
        );

      case HeaderVariant.avatarStack:
        return NovaHeaderConfig(
          variant: HeaderVariant.avatarStack,
          profile: profile,
          accounts: accounts,
          showCloseButton: false,
          showPinButton: false,
        );

      case HeaderVariant.multiAction:
        return NovaHeaderConfig(
          variant: HeaderVariant.multiAction,
          profile: profile,
          actions: actions,
          showCloseButton: false,
          showPinButton: false,
        );

      case HeaderVariant.statusAware:
        return NovaHeaderConfig(
          variant: HeaderVariant.statusAware,
          profile: profile,
          showStatusIndicator: true,
          showCloseButton: false,
          showPinButton: false,
        );

      case HeaderVariant.collapsible:
        return NovaHeaderConfig(
          variant: HeaderVariant.collapsible,
          profile: profile,
          isCollapsed: isCollapsed,
          enableCollapseExpand: true,
          showCloseButton: false,
          showPinButton: false,
        );
    }
  }
}
