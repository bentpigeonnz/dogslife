import 'package:flutter/material.dart';
import 'package:dogslife/widgets/role_badge.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: RoleBadge())],
      ),
      body: const Center(
        child: Text('Admin-only dashboard content goes here.'),
      ),
    );
  }
}
