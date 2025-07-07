import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';
import 'package:dogs_life/widgets/dev_role_switcher.dart';
// for kDebugMode

class UserProfileViewScreen extends ConsumerWidget {
  const UserProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          profileAsync.maybeWhen(
            data: (profile) => profile != null
                ? _RoleBadge(profile: profile)
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
          profileAsync.maybeWhen(
            data: (profile) => profile != null
                ? IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.push('/profile/edit'),
            )
                : const SizedBox.shrink(),
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error loading profile: $e')),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found.'));
          }
          final isAdmin = profile.isAdmin;
          final isManager = profile.isManager;
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundImage: AssetImage(profile.avatarOrPlaceholder),
                  foregroundImage: (profile.avatarUrl != null && profile.avatarUrl!.isNotEmpty)
                      ? NetworkImage(profile.avatarUrl!)
                      : null,
                  child: (profile.avatarUrl == null || profile.avatarUrl!.isEmpty)
                      ? const Icon(Icons.person, size: 48)
                      : null,
                ),
              ),
              const SizedBox(height: 16),
              _Field('Display Name', profile.displayOrEmail),
              _Field('Email', profile.email),
              _Field('Phone', profile.phone ?? 'Not set'),
              _Field('Bio/About', profile.bio ?? 'Not set'),
              _Field('Address', profile.address ?? 'Not set'),
              const Divider(),
              _Field('Role(s)', profile.roles.join(', ')),
              if (profile.rbacMeta != null)
                _Field('RBAC Meta', 'Assigned: ${profile.rbacMeta?['assignedAt'] ?? '-'} by ${profile.rbacMeta?['assignedBy'] ?? '-'}'),
              _Field('Account Status', profile.accountStatus),
              _Field('Created', profile.createdAt.toIso8601String().replaceFirst('T', ' ').split('.').first),
              if (profile.lastLogin != null)
                _Field('Last Login', profile.lastLogin!.toIso8601String().replaceFirst('T', ' ').split('.').first),
              const Divider(),
              _Field('Theme', profile.themePref),
              _Field('Language', profile.language),
              _Field('Notifications', profile.notificationPrefs.entries.map((e) => '${e.key}: ${e.value ? "On" : "Off"}').join(', ')),
              _Field('Privacy', profile.privacySettings.isNotEmpty ? profile.privacySettings.toString() : 'Default'),
              if (profile.emergencyContact != null)
                _Field(
                  'Emergency Contact',
                  '${profile.emergencyContact?['name'] ?? ''} '
                      '(${profile.emergencyContact?['relationship'] ?? ''}) - '
                      '${profile.emergencyContact?['phone'] ?? ''}',
                ),
              if (profile.socialLinks != null && profile.socialLinks!.isNotEmpty)
                _Field('Social Accounts', profile.socialLinks!.entries.map((e) => '${e.key}: ${e.value}').join(', ')),
              if (isAdmin || isManager) ...[
                const Divider(),
                _Field('Internal Notes', profile.internalNotes ?? 'None'),
                _Field('Admin Flags', profile.adminFlags?.entries.map((e) => '${e.key}: ${e.value ? "Yes" : "No"}').join(', ') ?? 'None'),
                _Field('Role History', profile.roleHistory.map((e) => '${e['role'] ?? '-'} (${e['assignedAt'] ?? '-'})').join(', ')),
                _Field('Linked Shelter', profile.linkedShelterId ?? 'None'),
                _Field('Audit Log', profile.auditLog.length.toString()),
              ],
              if (isAdmin || isManager)
                ExpansionTile(
                  title: const Text('Technical / Integration'),
                  children: [
                    _Field('FCM Tokens', profile.fcmTokens.join(', ')),
                    _Field('App Versions', profile.appVersions.join(', ')),
                    _Field('Devices', profile.deviceInfo.length.toString()),
                    _Field('Remote Config Flags', profile.remoteConfigFlags.entries.map((e) => '${e.key}: ${e.value}').join(', ')),
                  ],
                ),
              const SizedBox(height: 24),
              // DevRoleSwitcher widget at the bottom:
              const DevRoleSwitcher(),
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label),
      subtitle: Text(value),
      dense: true,
    );
  }
}

class _RoleBadge extends StatelessWidget {
  final UserProfile profile;
  const _RoleBadge({required this.profile});

  @override
  Widget build(BuildContext context) {
    final color = profile.isAdmin
        ? Colors.red
        : profile.isManager
        ? Colors.blue
        : profile.isStaff
        ? Colors.green
        : Colors.grey;
    final role = profile.roles.isNotEmpty ? profile.roles.first.toUpperCase() : 'GUEST';
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(role, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }
}

// The DevRoleSwitcher widget is imported from widgets/dev_role_switcher.dart and should not be redeclared here.
