import 'package:flutter/material.dart';
import 'package:dogslife/widgets/bottom_nav_scaffold.dart';
import 'package:dogslife/widgets/role_badge.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavScaffold(
      body: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          actions: const [Padding(padding: EdgeInsets.only(right: 12), child: RoleBadge())],
        ),
        body: const Center(
          child: Text('Settings Screen Content'),
        ),
      ),
    );
  }
}
