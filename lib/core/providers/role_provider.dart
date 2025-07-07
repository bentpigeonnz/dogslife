// lib/core/providers/role_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Riverpod AsyncNotifier for user role (RBAC).
/// Loads from Firestore, supports dev override, and persists in SharedPreferences.
class RoleNotifier extends AsyncNotifier<String?> {
  @override
  Future<String?> build() async {
    // 1. Check for dev override in local storage (for debugging)
    final prefs = await SharedPreferences.getInstance();
    final devRole = prefs.getString('dev_role_override');
    if (devRole != null && devRole.isNotEmpty) {
      return devRole;
    }

    // 2. If not set, load from Firestore using current Firebase user
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return 'guest';

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data()?['role'] ?? 'guest';
  }

  /// For dev: Set an override role locally (persists until cleared)
  Future<void> setDevRoleOverride(String? role) async {
    state = AsyncValue.data(role ?? 'guest');
    final prefs = await SharedPreferences.getInstance();
    if (role != null && role.isNotEmpty) {
      await prefs.setString('dev_role_override', role);
    } else {
      await prefs.remove('dev_role_override');
    }
    // Optionally reload (if you want to force rebuild elsewhere)
    ref.invalidateSelf();
  }

  /// Clear dev override so role loads from Firestore again.
  Future<void> clearDevOverride() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('dev_role_override');
    ref.invalidateSelf(); // Triggers reload from backend
  }
}

/// Main Riverpod provider for the signed-in user's role.
/// Use as: `ref.watch(roleProvider)`
final roleProvider = AsyncNotifierProvider<RoleNotifier, String?>(
  RoleNotifier.new,
);
