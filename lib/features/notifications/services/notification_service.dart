// lib/features/notifications/services/notification_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notification_model.dart';

class NotificationService {
  final CollectionReference<NotificationModel> _notificationsRef =
  FirebaseFirestore.instance
      .collection('notifications')
      .withConverter<NotificationModel>(
    fromFirestore: (snap, _) => NotificationModel.fromFirestore(snap),
    toFirestore: (notif, _) => notif.toFirestore(),
  );

  /// Create a single notification (returns doc ID)
  Future<String?> createNotification(NotificationModel notification) async {
    final doc = await _notificationsRef.add(notification);
    return doc.id;
  }

  /// Get a single notification by ID (returns null if not found)
  Future<NotificationModel?> getNotificationById(String id) async {
    final doc = await _notificationsRef.doc(id).get();
    return doc.data();
  }

  /// Stream a single notification by ID (real-time updates)
  Stream<NotificationModel?> streamNotificationById(String id) {
    return _notificationsRef.doc(id).snapshots().map((doc) => doc.data());
  }

  /// Update a notification
  Future<void> updateNotification(NotificationModel notification) async {
    await _notificationsRef.doc(notification.id).set(notification, SetOptions(merge: true));
  }

  /// Delete a notification by ID
  Future<void> deleteNotification(String notificationId) async {
    await _notificationsRef.doc(notificationId).delete();
  }

  /// Stream all notifications (admin/global)
  Stream<List<NotificationModel>> streamAllNotifications() {
    return _notificationsRef.orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).whereType<NotificationModel>().toList());
  }

  /// Stream notifications for a specific user
  Stream<List<NotificationModel>> streamUserNotifications({required String userId}) {
    return _notificationsRef
        .where('recipientIds', arrayContains: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).whereType<NotificationModel>().toList());
  }

  /// Stream notifications filtered by status
  Stream<List<NotificationModel>> streamNotificationsByStatus({required String status}) {
    return _notificationsRef
        .where('status', isEqualTo: status)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).whereType<NotificationModel>().toList());
  }

  /// Stream unread notifications for a user
  Stream<List<NotificationModel>> streamUnreadUserNotifications({required String userId}) {
    return _notificationsRef
        .where('recipientIds', arrayContains: userId)
        .where('status', isEqualTo: 'unread')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).whereType<NotificationModel>().toList());
  }

  /// Mark a notification as read
  Future<void> markAsRead(String notificationId) async {
    await _notificationsRef.doc(notificationId).update({'status': 'read'});
  }

  /// Bulk send notifications (returns list of new doc IDs)
  Future<List<String>> bulkSend(List<NotificationModel> notifications) async {
    final batch = FirebaseFirestore.instance.batch();
    final ids = <String>[];
    for (final notif in notifications) {
      final docRef = _notificationsRef.doc();
      batch.set(docRef, notif);
      ids.add(docRef.id);
    }
    await batch.commit();
    return ids;
  }
}
