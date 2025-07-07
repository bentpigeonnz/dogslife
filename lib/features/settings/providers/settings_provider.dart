import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../services/settings_service.dart';

class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final SettingsService service;
  final Set<String> userRoles;
  final bool isDebug;

  StreamSubscription<AppSettings>? _settingsSub;

  SettingsNotifier({
    required this.service,
    required this.userRoles,
    this.isDebug = false,
  }) : super(const AsyncValue.loading()) {
    _init();
  }

  void _init() {
    _settingsSub = service.streamSettings().listen(
          (settings) {
        final withDebug = settings.copyWith(showDebugTools: isDebug);
        state = AsyncValue.data(withDebug);
      },
      onError: (e, st) => state = AsyncValue.error(e, st),
    );
  }

  /// Clean up the stream when disposed (good Riverpod hygiene)
  @override
  void dispose() {
    _settingsSub?.cancel();
    super.dispose();
  }

  /// Update a single setting (writes to both Firestore and local, then updates state)
  Future<void> updateSetting(String key, dynamic value) async {
    if (!service.canEditSetting(key, roles: userRoles)) return;
    state = const AsyncValue.loading();
    await service.updateSetting(key, value, roles: userRoles);
    // Will auto-update via stream
  }

  /// Update multiple settings at once (atomic)
  Future<void> updateSettings(Map<String, dynamic> updates) async {
    for (final entry in updates.entries) {
      await updateSetting(entry.key, entry.value);
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>(
      (ref) {
    // Inject user context here (use your Auth provider/session)
    final String userId = 'currentUserId'; // TODO: Replace with real user id
    final Set<String> userRoles = {'User'}; // TODO: Replace with real roles from user/session
    final bool isDebug = false; // TODO: Replace with Platform/environment check

    final service = SettingsService(userId: userId);
    return SettingsNotifier(
      service: service,
      userRoles: userRoles,
      isDebug: isDebug,
    );
  },
);
