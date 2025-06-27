import 'package:flutter/material.dart';
import 'package:dogslife/widgets/role_badge.dart';

class ApplyToAdoptScreen extends StatelessWidget {
  const ApplyToAdoptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply to Adopt'),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: RoleBadge())],
      ),
      body: const Center(
        child: Text('Application form for adopting a dog goes here.'),
      ),
    );
  }
}
