// lib/features/notifications/providers/notification_service_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

/// Dependency injection for NotificationService
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
