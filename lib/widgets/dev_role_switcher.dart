import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dogs_life/features/user_profiles/providers/user_profile_provider.dart';

class DevRoleSwitcher extends ConsumerWidget {
  final List<String> allRoles;
  const DevRoleSwitcher({super.key, this.allRoles = const ['guest', 'adopter', 'volunteer', 'staff', 'manager', 'admin']});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);

    if (!kDebugMode) return const SizedBox.shrink(); // Debug only!

    return profileAsync.maybeWhen(
      data: (profile) {
        if (profile == null) return const SizedBox.shrink();
        final currentRole = profile.devRoleOverride ?? profile.roles.first;

        return Card(
          color: Colors.yellow.shade100,
          margin: const EdgeInsets.symmetric(vertical: 16),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('Dev Role: ', style: TextStyle(fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: currentRole,
                  items: allRoles.map((role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  )).toList(),
                  onChanged: (role) async {
                    if (role == null) return;
                    final updated = profile.copyWith(devRoleOverride: role);
                    await notifier.saveProfile(updated);
                  },
                ),
                const SizedBox(width: 10),
                const Text('(debug only)', style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}
