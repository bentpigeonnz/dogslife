// lib/features/notifications/providers/notifications_stream_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/notification_model.dart';
import 'notifications_service_provider.dart';

/// Real-time stream: all notifications (admin/global)
final notificationsStreamProvider = StreamProvider<List<NotificationModel>>((ref) {
  final service = ref.watch(notificationServiceProvider);
  return service.streamAllNotifications();
});

/// Real-time stream: notifications for a given user
final userNotificationsStreamProvider = StreamProvider.family<List<NotificationModel>, String>((ref, userId) {
  final service = ref.watch(notificationServiceProvider);
  return service.streamUserNotifications(userId: userId);
});

/// Real-time stream: notifications filtered by status (sent, delivered, read, etc.)
final notificationsByStatusProvider = StreamProvider.family<List<NotificationModel>, String>((ref, status) {
  final service = ref.watch(notificationServiceProvider);
  return service.streamNotificationsByStatus(status: status);
});

/// Real-time stream: UNREAD notifications for a given user
final unreadUserNotificationsProvider = StreamProvider.family<List<NotificationModel>, String>((ref, userId) {
  final service = ref.watch(notificationServiceProvider);
  return service.streamUnreadUserNotifications(userId: userId);
});
