// lib/core/providers/auth_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod/riverpod.dart';

/// Stream of Firebase User (null if logged out).
final authStateProvider = StreamProvider<User?>(
      (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// Helper for quick access to current user.
final currentUserProvider = Provider<User?>(
      (ref) => ref.watch(authStateProvider).maybeWhen(
    data: (user) => user,
    orElse: () => null,
  ),
);

/// Auth actions: login, logout, register
final authActionsProvider = Provider<AuthActions>((ref) => AuthActions());

class AuthActions {
  /// Email/password sign-in
  Future<UserCredential> signIn(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, password: password,
    );
  }

  /// Register new user
  Future<UserCredential> register(String email, String password) async {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, password: password,
    );
  }

  /// Sign out
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
