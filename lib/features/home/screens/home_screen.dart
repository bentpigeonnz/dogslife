import 'package:dogslife/widgets/top_right_menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dogslife/providers/role_provider.dart';
import 'package:dogslife/services/permission_service.dart';
import 'package:dogslife/widgets/bottom_nav_scaffold.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleProvider>(context).role;

    return BottomNavScaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: const [TopRightMenu()],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Welcome to dogsLife!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),

            if (PermissionService.isAdmin(role))
              ElevatedButton(
                onPressed: () => context.go('/admin'),
                child: const Text('Admin Dashboard'),
              ),

            if (PermissionService.canViewAdoptionApplications(role))
              ElevatedButton(
                onPressed: () => context.go('/adoption-applications'),
                child: const Text('View Adoption Applications'),
              ),

            ElevatedButton(
              onPressed: () => context.go('/merchandise'),
              child: const Text('Shop Merchandise'),
            ),
          ],
        ),
      ),
    );
  }
}
