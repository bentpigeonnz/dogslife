// lib/router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Import your screens here
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/register_screen.dart';
import 'features/dog_management/screens/dog_list_screen.dart';
import 'features/dog_management/screens/dog_detail_screen.dart';
import 'features/dog_management/screens/dog_form_screen.dart';
import 'features/admin/screens/admin_dashboard_screen.dart';
import 'features/events/screens/event_list_screen.dart';
// ...add more as you go

// Import your Riverpod providers
import 'core/providers/auth_provider.dart'; // e.g., for auth state
import 'core/providers/role_provider.dart'; // for RBAC

// This allows Riverpod context in route guards:
final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/dogs', // Change as needed

  // Listen to authentication/role state with Riverpod
  refreshListenable: GoRouterRefreshStream(authStateChangesProvider), // Example

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/dogs',
      builder: (context, state) => const DogListScreen(),
      routes: [
        GoRoute(
          path: ':dogId',
          builder: (context, state) =>
              DogDetailScreen(dogId: state.pathParameters['dogId']!),
        ),
        GoRoute(
          path: 'add',
          builder: (context, state) => const DogFormScreen(),
          // Example RBAC: Only admins/managers can add
          redirect: (context, state) {
            final role = context.read(roleProvider).maybeWhen(
              data: (role) => role,
              orElse: () => 'guest',
            );
            if (role != 'admin' && role != 'shelter_manager') {
              return '/login';
            }
            return null;
          },
        ),
        GoRoute(
          path: ':dogId/edit',
          builder: (context, state) =>
              DogFormScreen(dogId: state.pathParameters['dogId']),
        ),
      ],
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
      redirect: (context, state) {
        final role = context.read(roleProvider).maybeWhen(
          data: (role) => role,
          orElse: () => 'guest',
        );
        if (role != 'admin' && role != 'manager') {
          return '/login';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/events',
      builder: (context, state) => const EventListScreen(),
    ),
    // ...more routes here!
  ],

  // Optional: global error handler
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text(state.error.toString())),
  ),
);

/// Example: Use Riverpod auth stream as GoRouterRefreshListenable
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;
  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// Example providers (implement these with Riverpod!)
// final authStateChangesProvider = StreamProvider<User?>((ref) => ...);
// final roleProvider = FutureProvider<String>((ref) => ...);

