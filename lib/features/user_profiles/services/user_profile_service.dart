import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserProfileService {
  final _usersRef = FirebaseFirestore.instance.collection('users');

  /// Fetch user by ID
  Future<UserProfile?> getUserProfile(String id) async {
    final doc = await _usersRef.doc(id).get();
    if (!doc.exists) return null;
    return UserProfile.fromFirestore(doc);
  }

  /// Listen to user profile in real time
  Stream<UserProfile?> streamUserProfile(String id) {
    return _usersRef.doc(id).snapshots().map(
          (doc) => doc.exists ? UserProfile.fromFirestore(doc) : null,
    );
  }

  /// Create or update a user profile (RBAC handled in provider/logic)
  Future<void> setUserProfile(UserProfile profile) async {
    await _usersRef.doc(profile.id).set(profile.toFirestore(), SetOptions(merge: true));
  }

  /// Update fields (partial update)
  Future<void> updateUserProfile(String id, Map<String, dynamic> updates) async {
    await _usersRef.doc(id).set(updates, SetOptions(merge: true));
  }

  /// Log a profile event to auditLog (admin only)
  Future<void> appendAuditLog(String id, Map<String, dynamic> entry) async {
    await _usersRef.doc(id).update({
      'auditLog': FieldValue.arrayUnion([entry])
    });
  }

  /// For admin: fetch all users, or by role (paginated if needed)
  Future<List<UserProfile>> getUsers({String? role}) async {
    Query q = _usersRef;
    if (role != null) {
      q = q.where('roles', arrayContains: role);
    }
    final snap = await q.get();
    return snap.docs.map((d) => UserProfile.fromFirestore(d)).toList();
  }

  /// Add/remove FCM token for device
  Future<void> updateFcmTokens(String id, List<String> tokens) async {
    await _usersRef.doc(id).update({'fcmTokens': tokens});
  }

  /// Delete user (soft delete; sets accountStatus to deleted)
  Future<void> softDeleteUser(String id) async {
    await _usersRef.doc(id).update({'accountStatus': 'deleted'});
  }

  /// Reactivate user
  Future<void> reactivateUser(String id) async {
    await _usersRef.doc(id).update({'accountStatus': 'active'});
  }

  /// For privacy: export user data (admin or user only)
  Future<Map<String, dynamic>?> exportUserData(String id) async {
    final doc = await _usersRef.doc(id).get();
    if (!doc.exists) return null;
    return doc.data();
  }
}
