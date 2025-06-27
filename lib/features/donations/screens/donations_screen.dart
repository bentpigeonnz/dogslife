import 'package:flutter/material.dart';
import 'package:dogslife/widgets/role_badge.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donations'),
        actions: const [Padding(padding: EdgeInsets.only(right: 12), child: RoleBadge())],
      ),
      body: const Center(
        child: Text('Donation options and Stripe integration goes here.'),
      ),
    );
  }
}
