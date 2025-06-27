import 'package:flutter/material.dart';
import 'package:dogslife/widgets/role_badge.dart';

class AdminManagementScreen extends StatelessWidget {
  const AdminManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Management'),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: RoleBadge())],
      ),
      body: const Center(
        child: Text('Admin-only management tools go here.'),
      ),
    );
  }
}
