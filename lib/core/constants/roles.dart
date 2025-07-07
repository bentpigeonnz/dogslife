/// All valid user roles used in the app for RBAC.
const List<String> kAllRoles = [
  'guest',
  'adopter',
  'staff',
  'shelter_manager',
  'manager',
  'admin',
  'volunteer',
];

/// Human-friendly labels for display.
const Map<String, String> kRoleLabels = {
  'guest': 'Guest',
  'adopter': 'Adopter',
  'staff': 'Staff',
  'shelter_manager': 'Shelter Manager',
  'manager': 'Manager',
  'admin': 'Admin',
  'volunteer': 'Volunteer',
};

/// Role groups for permission checks (RBAC)
const List<String> kAdminRoles = ['admin', 'manager'];
const List<String> kStaffRoles = [
  'admin', 'manager', 'shelter_manager', 'staff'
];
const List<String> kCanManageEvents = [
  'admin', 'manager', 'shelter_manager'
];
const List<String> kCanViewDonations = [
  'admin', 'manager', 'shelter_manager', 'volunteer'
];
