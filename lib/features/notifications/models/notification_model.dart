import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

enum NotificationType { info, alert, reminder, broadcast, promotion, custom }
enum NotificationStatus { unread, read, dismissed, snoozed, scheduled }

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    String? userId,                          // Optional: legacy/single-user support
    List<String>? recipientIds,              // Multi-user support!
    required String title,
    required String body,
    @Default(NotificationType.info) NotificationType type,
    @Default(NotificationStatus.unread) NotificationStatus status,
    DateTime? createdAt,
    DateTime? readAt,
    DateTime? scheduledAt,
    DateTime? snoozedUntil,
    String? actionLabel,
    String? actionUrl,
    Map<String, dynamic>? meta,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  factory NotificationModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return NotificationModel.fromJson({
      ...data,
      'id': doc.id,
      'createdAt': (data['createdAt'] as Timestamp?)?.toDate(),
      'readAt': (data['readAt'] as Timestamp?)?.toDate(),
      'scheduledAt': (data['scheduledAt'] as Timestamp?)?.toDate(),
      'snoozedUntil': (data['snoozedUntil'] as Timestamp?)?.toDate(),
      'type': _notificationTypeFromString(data['type']),
      'status': _notificationStatusFromString(data['status']),
    });
  }
}

extension NotificationModelFirestoreX on NotificationModel {
  Map<String, dynamic> toFirestore() {
    final data = toJson();
    data.remove('id');
    return data;
  }
}

// ----- Robust Enum Conversion -----
NotificationType _notificationTypeFromString(dynamic type) {
  if (type is NotificationType) return type;
  final typeStr = (type ?? 'info').toString();
  return NotificationType.values.firstWhere(
          (e) => e.name == typeStr || e.toString().split('.').last == typeStr,
      orElse: () => NotificationType.info);
}

NotificationStatus _notificationStatusFromString(dynamic status) {
  if (status is NotificationStatus) return status;
  final statusStr = (status ?? 'unread').toString();
  return NotificationStatus.values.firstWhere(
          (e) => e.name == statusStr || e.toString().split('.').last == statusStr,
      orElse: () => NotificationStatus.unread);
}
