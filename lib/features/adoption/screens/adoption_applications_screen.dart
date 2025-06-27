import 'package:flutter/material.dart';
import 'package:dogslife/widgets/role_badge.dart';

class AdoptionApplicationsScreen extends StatelessWidget {
  const AdoptionApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adoption Applications'),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: RoleBadge())],
      ),
      body: const Center(
        child: Text('List of adoption applications for Admins and Shelter Managers.'),
      ),
    );
  }
}
