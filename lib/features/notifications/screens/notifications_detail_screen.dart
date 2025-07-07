import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../providers/notifications_provider.dart';

class NotificationDetailScreen extends ConsumerWidget {
  final String notificationId;
  const NotificationDetailScreen({super.key, required this.notificationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationAsync = ref.watch(notificationProvider(notificationId));
    return Scaffold(
      appBar: AppBar(title: const Text('Notification Detail')),
      body: notificationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (n) => n == null
            ? const Center(child: Text('Not found'))
            : Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(n.title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(n.body),
              const Divider(),
              Text('Type: ${n.type.name}'),
              Text('Status: ${n.status.name}'),
              if (n.scheduledAt != null)
                Text('Scheduled for: ${n.scheduledAt}'),
              if (n.snoozedUntil != null)
                Text('Snoozed until: ${n.snoozedUntil}'),
              // Dismiss, snooze, delete logic via PermissionService & RBAC
            ],
          ),
        ),
      ),
    );
  }
}
