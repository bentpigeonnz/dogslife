import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dogslife/providers/role_provider.dart';
import 'package:dogslife/services/permission_service.dart';

class BottomNavScaffold extends StatelessWidget {
  final Widget body;

  const BottomNavScaffold({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleProvider>(context).role;
    final isGuest = role == 'Guest';

    final List<_NavItem> leftItems = [
      _NavItem(
        icon: Icons.shopping_bag,
        label: 'Shop',
        route: '/merchandise',
        visible: true,
      ),
    ];

    final List<_NavItem> rightItems = [
      _NavItem(
        icon: Icons.settings,
        label: 'Settings',
        route: '/settings',
        visible: !isGuest && PermissionService.canAccessSettings(role),
      ),
      _NavItem(
        icon: Icons.admin_panel_settings,
        label: 'Admin',
        route: '/admin',
        visible: PermissionService.isAdmin(role),
      ),
    ];

    final centerIcon = isGuest ? Icons.pets : Icons.home;
    final centerLabel = isGuest ? 'Welcome' : 'Home';
    final centerRoute = isGuest ? '/welcome' : '/';

    return Scaffold(
      body: body,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        tooltip: centerLabel,
        onPressed: () {
          context.go(centerRoute);
        },
        child: Icon(centerIcon),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: leftItems
                    .where((item) => item.visible)
                    .map((item) => IconButton(
                  tooltip: item.label,
                  icon: Icon(item.icon),
                  onPressed: () {
                    context.go(item.route);
                  },
                ))
                    .toList(),
              ),
              Row(
                children: rightItems
                    .where((item) => item.visible)
                    .map((item) => IconButton(
                  tooltip: item.label,
                  icon: Icon(item.icon),
                  onPressed: () {
                    context.go(item.route);
                  },
                ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  final bool visible;

  _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    required this.visible,
  });
}
