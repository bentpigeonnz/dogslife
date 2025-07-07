import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/settings_provider.dart';

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Settings')),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Settings error: $e')),
        data: (settings) {
          final notifier = ref.read(settingsProvider.notifier);

          return ListView(
            children: [
              SwitchListTile(
                title: const Text('Enable All Notifications'),
                value: settings.notificationsEnabled,
                onChanged: (val) {
                  notifier.updateSetting('notificationsEnabled', val);
                },
              ),
              SwitchListTile(
                title: const Text('Marketing Notifications'),
                value: settings.marketingOptIn,
                onChanged: (val) {
                  notifier.updateSetting('marketingOptIn', val);
                },
              ),
              // You can expand with more notification prefs here, e.g.:
              // - event reminders
              // - app updates
              // - critical alerts
              // ...based on your latest model fields!
            ],
          );
        },
      ),
    );
  }
}
