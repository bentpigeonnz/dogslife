// lib/core/providers/role_provider.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:dogslife/constants/roles.dart';

/// Loads the role for the current user (default: 'guest')
final roleProvider = FutureProvider<String>((ref) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return 'guest';
  final doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();
  final role = doc.data()?['role'] as String? ?? 'guest';
  // Only allow known roles (SSOT!)
  return kAllRoles.contains(role) ? role : 'guest';
});

/// For advanced/dev mode: override the role (used in DevRoleSwitcher, tests, etc)
final devRoleOverrideProvider = StateProvider<String?>((ref) => null);

/// Use this provider throughout your app for RBAC.
final effectiveRoleProvider = Provider<String>((ref) {
  final devOverride = ref.watch(devRoleOverrideProvider);
  if (devOverride != null && kAllRoles.contains(devOverride)) return devOverride;
  final roleAsync = ref.watch(roleProvider);
  return roleAsync.maybeWhen(
    data: (role) => role,
    orElse: () => 'guest',
  );
});
