import 'package:dogslife/features/about/screens/about_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'features/home/screens/home_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/adoption/screens/adoption_applications_screen.dart';
import 'features/adoption/screens/apply_to_adopt_screen.dart';
import 'features/donations/screens/donations_screen.dart';
import 'features/merchandise/screens/merchandise_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/user_profiles/screens/profile_screen.dart';
import 'features/admin/screens/admin_management_screen.dart';
import 'features/access_denied/screens/access_denied_screen.dart';
import 'features/authentication/screens/login_screen.dart';
import 'features/authentication/screens/register_screen.dart';
import 'features/welcome/screens/welcome_screen.dart';
import 'providers/role_provider.dart';
import 'services/permission_service.dart';

final GoRouter appRouter = GoRouter(
  redirect: (context, state) async {
    final user = FirebaseAuth.instance.currentUser;
    final role = Provider.of<RoleProvider>(context, listen: false).role;
    final isOnProfile = state.uri.path == '/profile';
    final isOnWelcome = state.uri.path == '/welcome';
    final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register';

    final isGuest = role == 'Guest';

    if (user == null && !isGuest && !isOnWelcome && !isLoggingIn) {
      return '/welcome';
    }

    if (user != null && !isOnProfile) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      final isComplete = doc.data()?['isProfileComplete'] == true;

      if (!isComplete) {
        return '/profile';
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
      redirect: (context, state) {
        final role = Provider.of<RoleProvider>(context, listen: false).role;
        return PermissionService.isAdmin(role) ? null : '/access-denied';
      },
    ),
    GoRoute(
      path: '/admin-management',
      builder: (context, state) => const AdminManagementScreen(),
      redirect: (context, state) {
        final role = Provider.of<RoleProvider>(context, listen: false).role;
        return PermissionService.isAdmin(role) ? null : '/access-denied';
      },
    ),
    GoRoute(
      path: '/adoption-applications',
      builder: (context, state) => const AdoptionApplicationsScreen(),
      redirect: (context, state) {
        final role = Provider.of<RoleProvider>(context, listen: false).role;
        return PermissionService.canViewAdoptionApplications(role) ? null : '/access-denied';
      },
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
      redirect: (context, state) {
        final role = Provider.of<RoleProvider>(context, listen: false).role;
        return PermissionService.canAccessSettings(role) ? null : '/access-denied';
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/access-denied',
      builder: (context, state) => const AccessDeniedScreen(),
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen()
    ),
  ],
);
