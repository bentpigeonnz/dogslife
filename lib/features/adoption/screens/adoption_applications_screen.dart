import 'package:flutter/material.dart';

class AdoptionApplicationsScreen extends StatelessWidget {
  const AdoptionApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption Applications')),
      body: const Center(child: Text('List of Applications')),
    );
  }
}
