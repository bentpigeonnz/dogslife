import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/notification_model.dart';
import '../providers/notifications_provider.dart';
import 'package:dogs_life/features/notifications/screens/notifications_detail_screen.dart';

class NotificationsListScreen extends ConsumerWidget {
  final String userId;
  const NotificationsListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(userNotificationsProvider(userId));
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (list) => list.isEmpty
            ? const Center(child: Text('No notifications'))
            : ListView.builder(
          itemCount: list.length,
          itemBuilder: (_, i) {
            final n = list[i];
            return ListTile(
              title: Text(n.title),
              subtitle: Text(n.body),
              trailing: n.status == NotificationStatus.unread
                  ? const Icon(Icons.markunread, color: Colors.blue)
                  : null,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => NotificationDetailScreen(notificationId: n.id))),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to notification creation screen
        },
        child: const Icon(Icons.add_alert),
      ),
    );
  }
}
