// lib/features/notifications/providers/notifications_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import 'notifications_service_provider.dart'; // <- Import the single source of service

/// Get a single notification by id (one-shot fetch)
final notificationProvider = FutureProvider.family<NotificationModel?, String>((ref, id) {
  return ref.watch(notificationServiceProvider).getNotificationById(id);
});

/// Stream a single notification by id (real-time updates)
final notificationStreamProvider = StreamProvider.family<NotificationModel?, String>((ref, id) {
  return ref.watch(notificationServiceProvider).streamNotificationById(id);
});

/// All notifications for a user (real-time)
final userNotificationsProvider = StreamProvider.family<List<NotificationModel>, String>((ref, userId) {
  // Always pass userId as a **named argument** for clarity and safety!
  return ref.watch(notificationServiceProvider).streamUserNotifications(userId: userId);
});

/// All notifications (admin/global view, real-time)
final allNotificationsProvider = StreamProvider<List<NotificationModel>>((ref) {
  return ref.watch(notificationServiceProvider).streamAllNotifications();
});
