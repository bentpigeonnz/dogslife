// lib/features/user_profile/user_profile_routes.dart

import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogs_life/features/user_profiles/providers/user_profile_provider.dart';
import 'package:dogs_life/features/user_profiles/screens/user_profile_view_screen.dart';
import 'package:dogs_life/features/user_profiles/screens/user_profile_edit_screen.dart';

GoRouter getUserProfileRouter(WidgetRef ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/profile',
        name: 'profileView',
        builder: (context, state) => const UserProfileViewScreen(),
        redirect: (context, state) async {
          // Only allow if authenticated (customize as needed)
          final profileAsync = ref.read(userProfileProvider);
          if (profileAsync.value == null) return '/login'; // Or your login screen
          return null;
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'profileEdit',
            builder: (context, state) => const UserProfileEditScreen(),
            redirect: (context, state) async {
              // RBAC: Only allow self, admin, or manager
              final profileAsync = ref.read(userProfileProvider);
              final roles = profileAsync.value?.roles ?? [];
              if (roles.contains('admin') || roles.contains('manager')) {
                return null;
              }
              // You may want to allow self-edit:
              // if (profileAsync.value?.id == getCurrentUserId()) return null;
              // else:
              return '/profile'; // No access
            },
          ),
        ],
      ),
    ],
  );
}
