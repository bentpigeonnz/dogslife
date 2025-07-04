// lib/core/providers/permission_provider.dart

import 'package:riverpod/riverpod.dart';
import 'package:dogslife/constants/roles.dart';

/// Example: Can the user add a dog?
final canAddDogProvider = Provider<bool>((ref) {
  final role = ref.watch(effectiveRoleProvider);
  return kAdminRoles.contains(role) || kStaffRoles.contains(role);
});

// Add more as needed, e.g. canEditEventsProvider, canViewDonationsProvider...
