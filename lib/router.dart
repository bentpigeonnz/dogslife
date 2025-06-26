import 'package:go_router/go_router.dart';

import 'features/home/screens/home_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/adoption/screens/adoption_applications_screen.dart';
import 'features/adoption/screens/apply_to_adopt_screen.dart';
import 'features/donations/screens/donations_screen.dart';
import 'features/merchandise/screens/merchandise_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/user_profiles/screens/profile_screen.dart';
import 'features/admin/screens/admin_management_screen.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin-management',
      builder: (context, state) => const AdminManagementScreen(),
    ),

    GoRoute(
      path: '/adoption-applications',
      builder: (context, state) => const AdoptionApplicationsScreen(),
    ),
    GoRoute(
      path: '/apply-to-adopt',
      builder: (context, state) => const ApplyToAdoptScreen(),
    ),
    GoRoute(
      path: '/donations',
      builder: (context, state) => const DonationsScreen(),
    ),
    GoRoute(
      path: '/merchandise',
      builder: (context, state) => const MerchandiseScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
