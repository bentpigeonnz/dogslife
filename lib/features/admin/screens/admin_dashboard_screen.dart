import 'package:flutter/material.dart';
import 'admin_management_screen.dart';

/// Admin Dashboard screen that routes to Admin Management
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This keeps your admin structure flexible for future expansion
    return const AdminManagementScreen();
  }
}
