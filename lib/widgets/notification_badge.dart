import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../features/notifications/models/notification_model.dart';
import '../features/notifications/providers/notifications_stream_provider.dart';

class NotificationBadge extends ConsumerWidget {
  final String userId;
  final VoidCallback? onTap;
  const NotificationBadge({super.key, required this.userId, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAsync = ref.watch(notificationsStreamProvider);
    return notifsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const Icon(Icons.notifications),
      data: (list) {
        final unreadCount = list.where((n) => n.status == NotificationStatus.unread).length;
        return Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: onTap,
            ),
            if (unreadCount > 0)
              Positioned(
                right: 6, top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  child: Text('$unreadCount', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
          ],
        );
      },
    );
  }
}
