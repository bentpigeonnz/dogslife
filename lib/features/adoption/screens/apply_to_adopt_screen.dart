import 'package:flutter/material.dart';

class ApplyToAdoptScreen extends StatelessWidget {
  const ApplyToAdoptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apply to Adopt')),
      body: const Center(child: Text('Adoption Form')),
    );
  }
}
