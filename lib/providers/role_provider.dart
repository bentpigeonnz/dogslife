import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class RoleProvider with ChangeNotifier {
  String? _role;

  String? get role => _role;

  /// Loads role from Firestore after login
  Future<void> loadRole() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _role = 'Guest';
      notifyListeners();
      return;
    }

    final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    _role = doc.data()?['role'] ?? 'Guest';
    notifyListeners();
  }

  /// For Dev Role Switcher or testing
  void setRole(String newRole) {
    _role = newRole;
    notifyListeners();
  }
}
