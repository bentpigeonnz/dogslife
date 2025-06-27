import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About dogsLife')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('dogsLife', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Version: 1.0.0'),
            Text('Developed by: Your Team Name'),
            SizedBox(height: 16),
            Text(
              'dogsLife is designed to help shelters and rescues manage dogs, adoptions, and more.',
            ),
          ],
        ),
      ),
    );
  }
}
