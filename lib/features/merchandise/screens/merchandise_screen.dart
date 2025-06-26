import 'package:flutter/material.dart';

class MerchandiseScreen extends StatelessWidget {
  const MerchandiseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Merchandise')),
      body: const Center(child: Text('Merchandise Available')),
    );
  }
}
