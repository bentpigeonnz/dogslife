class PermissionService {
  /// Admin-only features
  static bool isAdmin(String? role) {
    return role == 'Admin';
  }

  /// Admin & Shelter Manager features
  static bool isManager(String? role) {
    return role == 'Admin' || role == 'Shelter Manager';
  }

  /// Volunteer features (includes Managers/Admins)
  static bool isVolunteer(String? role) {
    return role == 'Volunteer' || isManager(role);
  }

  /// Guests cannot access Adoption Application Status
  static bool canViewAdoptionApplications(String? role) {
    return role != 'Guest' && role != null;
  }

  /// Guests cannot access Settings
  static bool canAccessSettings(String? role) {
    return role != 'Guest' && role != null;
  }

  /// Only Admins and Managers can edit dogs
  static bool canEditDogs(String? role) {
    return isAdmin(role) || isManager(role);
  }

  /// Only Admins, Managers, Volunteers can view Medical Info
  static bool canViewMedicalInfo(String? role) {
    return isVolunteer(role) || isManager(role) || isAdmin(role);
  }

  /// Only Admins and Managers can access Donations management
  static bool canManageDonations(String? role) {
    return isAdmin(role) || isManager(role);
  }

  /// Guests cannot apply to adopt (forces register first)
  static bool canApplyToAdopt(String? role) {
    return role != 'Guest' && role != null;
  }

  /// Only Admins and Managers can manage merchandise
  static bool canManageMerchandise(String? role) {
  return isAdmin(role) || isManager(role);
  }
}
