import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    // --- Basic Info ---
    required String id,
    required String email,
    String? displayName,
    String? avatarUrl,
    String? phone,                // NZ validation in UI
    String? bio,
    String? address,

    // --- Roles & Permissions ---
    @Default(['guest']) List<String> roles,
    String? roleBadge,
    Map<String, dynamic>? rbacMeta,   // {assignedAt, assignedBy}
    String? devRoleOverride,          // For debug/dev only

    // --- Account Status & Security ---
    @Default('active') String accountStatus, // active, suspended, deleted, pending
    DateTime? lastLogin,
    required DateTime createdAt,
    DateTime? updatedAt,
    @Default([]) List<Map<String, dynamic>> linkedAccounts, // {provider, email, uid}
    String? passwordResetToken,
    @Default(false) bool accountDeletionRequested,

    // --- Preferences & Settings ---
    @Default({}) Map<String, bool> notificationPrefs,
    @Default('system') String themePref,    // light/dark/system
    @Default('en') String language,
    @Default({}) Map<String, dynamic> privacySettings,
    @Default(false) bool dataExportRequested,

    // --- Activity & Engagement ---
    @Default([]) List<String> adoptionApplications, // application IDs
    @Default([]) List<String> rsvpedEvents,         // event IDs
    @Default([]) List<Map<String, dynamic>> donationHistory, // {amount, date, receipt}
    @Default([]) List<Map<String, dynamic>> orders, // {orderId, items, date}
    @Default([]) List<Map<String, dynamic>> volunteerShifts, // {date, shift, role}
    @Default([]) List<Map<String, dynamic>> auditLog, // admin only

    // --- Admin/Manager-Only Fields ---
    String? internalNotes,                        // Visible to admin/staff only
    Map<String, bool>? adminFlags,                // {banned: true, needsReview: true}
    @Default([]) List<Map<String, dynamic>> roleHistory, // {role, assignedAt, by}
    String? linkedShelterId,                      // For multi-org

    // --- Technical/Integration ---
    @Default([]) List<String> fcmTokens,
    @Default([]) List<String> appVersions,
    @Default([]) List<Map<String, dynamic>> deviceInfo,
    @Default({}) Map<String, bool> remoteConfigFlags,

    // --- Emergency & Social ---
    Map<String, String>? emergencyContact,     // {name, phone, relationship}
    Map<String, String>? socialLinks,          // {google, facebook, twitter}
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  factory UserProfile.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      UserProfile.fromJson({...doc.data() ?? {}, 'id': doc.id});
}

/// --- Firestore Serialization/Helpers ---
extension UserProfileX on UserProfile {
  Map<String, dynamic> toFirestore() {
    final data = toJson();
    data.remove('id'); // Never store 'id' in Firestore doc
    return data;
  }

  /// Returns displayName if set/non-empty, else email (never null)
  String get displayOrEmail =>
      (displayName != null && displayName!.isNotEmpty) ? displayName! : email;

  /// Returns avatarUrl or fallback
  String get avatarOrPlaceholder =>
      (avatarUrl != null && avatarUrl!.isNotEmpty)
          ? avatarUrl!
          : 'assets/images/placeholder_user.png';

  bool get isAdmin => roles.contains('admin');
  bool get isManager => roles.contains('manager');
  bool get isStaff => roles.contains('staff');
  bool get isVolunteer => roles.contains('volunteer');
  bool get isAdopter => roles.contains('adopter');
  bool get isGuest => roles.contains('guest');
}
