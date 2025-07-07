import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return settingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Settings error: $e')),
      data: (settings) {
        return ListView(
          children: [
            ListTile(
              title: const Text('Theme'),
              subtitle: Text(settings.themeMode),
              onTap: () {
                // Show theme selection dialog
              },
            ),
            ListTile(
              title: const Text('Language'),
              subtitle: Text(settings.language),
              onTap: () {
                // Show language picker
              },
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: settings.notificationsEnabled,
              onChanged: (val) => ref.read(settingsProvider.notifier)
                  .updateSetting('notificationsEnabled', val),
            ),
            if (settings.featureFlags.isNotEmpty) ...[
              const Divider(),
              const ListTile(title: Text('Feature Flags')),
              ...settings.featureFlags.entries.map((e) => SwitchListTile(
                title: Text(e.key),
                value: e.value,
                onChanged: null, // Feature flags are typically admin/remote-only
              )),
            ],
            if (settings.showDebugTools)
              ListTile(
                title: const Text('Debug Tools'),
                onTap: () {
                  // Show advanced/debug settings
                },
              ),
            // ...add more tiles/groups as needed for privacy, account, etc.
            ListTile(
              title: const Text('Version'),
              subtitle: Text('${settings.appVersion}+${settings.buildNumber}'),
              enabled: false,
            ),
            // About/legal/feedback/etc.
          ],
        );
      },
    );
  }
}
