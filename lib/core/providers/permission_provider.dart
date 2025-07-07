import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogs_life/core/constants/roles.dart';
import 'package:dogs_life/core/providers/role_provider.dart';

// Example: Can the user add a dog?
final canAddDogProvider = Provider<bool>((ref) {
  final asyncRole = ref.watch(roleProvider);
  // Use .value for the String? role, fallback to 'guest' if loading/error
  final role = asyncRole.value ?? 'guest';
  return kAdminRoles.contains(role) || kStaffRoles.contains(role);
});

// Example: Can the user edit events?
final canEditEventsProvider = Provider<bool>((ref) {
  final asyncRole = ref.watch(roleProvider);
  final role = asyncRole.value ?? 'guest';
  return kAdminRoles.contains(role);
});

// Add more as needed, always following this pattern
