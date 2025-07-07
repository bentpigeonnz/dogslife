import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/settings_provider.dart';

class AdvancedSettingsScreen extends ConsumerWidget {
  const AdvancedSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Settings error: $e')),
        data: (settings) {
          final notifier = ref.read(settingsProvider.notifier);
          final isAdmin = notifier.userRoles.contains('Admin');

          return ListView(
            children: [
              if (settings.showDebugTools) ...[
                ListTile(
                  title: const Text('Debug/Developer Tools'),
                  subtitle: const Text('Visible only in debug or admin mode'),
                ),
                SwitchListTile(
                  title: const Text('Enable Debug Tools (Dev Only)'),
                  value: settings.showDebugTools,
                  onChanged: null, // Toggle debug mode only via build mode or admin
                ),
                // Add more debug-only toggles here, if needed
              ],

              if (settings.featureFlags.isNotEmpty) ...[
                const Divider(),
                const ListTile(title: Text('Feature Flags')),
                ...settings.featureFlags.entries.map(
                      (e) => SwitchListTile(
                    title: Text(e.key),
                    value: e.value,
                    onChanged: null, // Remote controlled, read-only for user
                    subtitle: const Text('Set remotely or via .env'),
                  ),
                ),
              ],

              const Divider(),
              ListTile(
                title: const Text('Custom Advanced Setting'),
                subtitle: const Text('Example for extending advanced settings'),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: isAdmin
                    ? () {
                  // Add advanced logic here
                }
                    : null,
                enabled: isAdmin,
              ),

              if (isAdmin) ...[
                const Divider(),
                ListTile(
                  title: const Text('Admin: App Version'),
                  subtitle: Text('${settings.appVersion}+${settings.buildNumber}'),
                  enabled: false,
                ),
                ListTile(
                  title: const Text('Admin: Copyright'),
                  subtitle: Text(settings.copyright),
                  enabled: false,
                ),
                ListTile(
                  title: const Text('Legal URL'),
                  subtitle: Text(settings.legalUrl.isNotEmpty
                      ? settings.legalUrl
                      : 'Not set'),
                  enabled: false,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
