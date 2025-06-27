import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dogslife/providers/role_provider.dart';

class RoleBadge extends StatelessWidget {
  final String? roleOverride;

  const RoleBadge({super.key, this.roleOverride});

  @override
  Widget build(BuildContext context) {
    final role = roleOverride ?? Provider.of<RoleProvider>(context).role ?? 'Guest';

    Color color;
    switch (role) {
      case 'Admin':
        color = Colors.red;
        break;
      case 'Shelter Manager':
        color = Colors.orange;
        break;
      case 'Volunteer':
        color = Colors.blue;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(51), // 0.2 * 255 = 51 for 20% opacity
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
