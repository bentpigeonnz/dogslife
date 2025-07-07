// lib/services/permission_service.dart

import 'package:dogs_life/core/constants/roles.dart';

/// PermissionService centralizes all RBAC logic.
/// Use these helpers for any permission checks, instead of role string compares in your UI.
/// Update here if roles or app requirements change!
class PermissionService {
  // ---- Dogs ----
  static bool canAddDog(String? role) => kAdminRoles.contains(role);
  static bool canManageDogs(String? role) => kAdminRoles.contains(role) || kStaffRoles.contains(role);
  static bool canDeleteDog(String? role) => kAdminRoles.contains(role);
  static bool canEditDog(String? role) => kAdminRoles.contains(role) || kStaffRoles.contains(role);

  // ---- Events ----
  static bool canManageEvents(String? role) => kAdminRoles.contains(role) || kStaffRoles.contains(role);
  static bool canAddEvent(String? role) => kAdminRoles.contains(role) || kStaffRoles.contains(role);
  static bool canDeleteEvent(String? role) => kAdminRoles.contains(role);
  static bool canRSVPEvent(String? role) => role != null && role != 'guest';

  // ---- Adoptions ----
  static bool canApplyForAdoption(String? role) => role == null || role == 'guest' || role == 'adopter';
  static bool canManageAdoptions(String? role) => kAdminRoles.contains(role) || kStaffRoles.contains(role);

  // ---- Users ----
  static bool canViewUserProfiles(String? role) => kAdminRoles.contains(role) || kStaffRoles.contains(role);
  static bool canEditOwnProfile(String? role) => role != null && role != 'guest';
  static bool canManageUsers(String? role) => kAdminRoles.contains(role);

  // ---- Donations ----
  static bool canManageDonations(String? role) => kAdminRoles.contains(role);
  static bool canViewDonations(String? role) => kAdminRoles.contains(role) || role == 'volunteer';

  // ---- Merchandise ----
  static bool canManageMerchandise(String? role) => kAdminRoles.contains(role);

  // ---- Utilities ----
  static bool isAdmin(String? role) => role == 'admin';
  static bool isManager(String? role) => role == 'manager';
  static bool isStaff(String? role) => kStaffRoles.contains(role);

  // ---- Notifications ----
  // In core/services/permission_service.dart

  static bool canCreateNotification(String? role) => role == 'admin' || role == 'manager' || role == 'shelter_manager';
  static bool canDismissNotification(String? role) => role != 'guest';
  static bool canDeleteNotification(String? role) => role == 'admin' || role == 'manager';


// ---- Example: use for navigation guards, screens, etc. ----
// PermissionService.canManageEvents(userRole)
}
