import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dogslife/providers/role_provider.dart';
import 'package:dogslife/services/permission_service.dart';
import 'package:dogslife/widgets/bottom_nav_scaffold.dart';
import 'package:dogslife/widgets/role_badge.dart';

class MerchandiseScreen extends StatelessWidget {
  const MerchandiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<RoleProvider>(context).role;

    return BottomNavScaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Merchandise'),
          actions: const [Padding(padding: EdgeInsets.only(right: 12), child: RoleBadge())],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Browse our merchandise!'),

              const SizedBox(height: 20),

              if (PermissionService.canManageMerchandise(role))
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Add Product screen (to be implemented)
                  },
                  child: const Text('Add Product'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
