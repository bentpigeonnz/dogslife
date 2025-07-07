import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/user_profile_service.dart';

class UserProfileNotifier extends StateNotifier<AsyncValue<UserProfile?>> {
  final UserProfileService service;
  final String userId;
  final Set<String> userRoles;

  Stream<UserProfile?>? _profileStream;
  late final StreamSubscription<UserProfile?> _profileSub;

  UserProfileNotifier({
    required this.service,
    required this.userId,
    required this.userRoles,
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _profileStream = service.streamUserProfile(userId);
    _profileSub = _profileStream!.listen(
          (profile) => state = AsyncValue.data(profile),
      onError: (e, st) => state = AsyncValue.error(e, st),
    );
  }

  @override
  void dispose() {
    _profileSub.cancel();
    super.dispose();
  }

  Future<void> saveProfile(UserProfile profile) async {
    // RBAC: Only allow if self or admin/manager
    if (profile.id != userId && !_canEditAny()) return;
    state = const AsyncValue.loading();
    await service.setUserProfile(profile);
  }

  Future<void> updateProfileFields(Map<String, dynamic> updates) async {
    // RBAC: restrict sensitive fields to admin/manager
    if (!_canEditAny()) return;
    state = const AsyncValue.loading();
    await service.updateUserProfile(userId, updates);
  }

  Future<void> requestAccountDeletion() async {
    await service.updateUserProfile(userId, {'accountDeletionRequested': true});
  }

  Future<void> softDeleteUser(String targetUserId) async {
    if (!_canEditAny()) return;
    await service.softDeleteUser(targetUserId);
  }

  Future<void> appendAudit(Map<String, dynamic> entry) async {
    if (!_canEditAny()) return;
    await service.appendAuditLog(userId, entry);
  }

  // RBAC utility: Can this user edit ANY profile?
  bool _canEditAny() =>
      userRoles.contains('admin') || userRoles.contains('manager');
}

final userProfileServiceProvider =
Provider<UserProfileService>((ref) => UserProfileService());

final userProfileProvider =
StateNotifierProvider<UserProfileNotifier, AsyncValue<UserProfile?>>(
      (ref) {
    // TODO: Replace with real user id and roles (inject from auth/session context)
    final userId = 'currentUserId';
    final userRoles = <String>{'guest'};
    final service = ref.watch(userProfileServiceProvider);
    return UserProfileNotifier(
      service: service,
      userId: userId,
      userRoles: userRoles,
    );
  },
);
