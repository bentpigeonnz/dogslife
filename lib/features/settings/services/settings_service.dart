import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import '../models/app_settings.dart';

class SettingsService {
  final String userId;
  final _firestore = FirebaseFirestore.instance;
  final _remoteConfig = FirebaseRemoteConfig.instance;

  SettingsService({required this.userId});

  /// Stream settings: merges Firestore, local, .env, remote config feature flags
  Stream<AppSettings> streamSettings() async* {
    final local = await _getLocalSettings();
    final envFlags = _getEnvFeatureFlags();
    final remoteFlags = await _getRemoteConfigFeatureFlags();

    final firestoreStream = _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('main')
        .snapshots()
        .map((snap) =>
    snap.exists ? AppSettings.fromJson(snap.data() ?? {}) : AppSettings());

    await for (final firestoreSettings in firestoreStream) {
      // Merge Firestore (authoritative) with local (fallback)
      final merged = _mergeSettings(firestoreSettings, local);

      // Always merge in feature flags (env & remote config)
      yield merged.copyWith(
        featureFlags: {
          ...envFlags,
          ...remoteFlags,
          ...merged.featureFlags,
        },
      );
    }
  }

  /// Update setting: updates both Firestore and local (for offline/device speed)
  Future<void> updateSetting(String key, dynamic value, {required Set<String> roles}) async {
    if (!canEditSetting(key, roles: roles)) return;
    // Load current settings from Firestore
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('main');
    final doc = await docRef.get();
    final remoteSettings = doc.exists
        ? AppSettings.fromJson(doc.data() ?? {})
        : AppSettings();

    final updated = _updateAppSettings(remoteSettings, key, value);
    await docRef.set(updated.toJson(), SetOptions(merge: true));
    await saveLocalSetting(key, value);
  }

  /// Save a setting locally
  Future<void> saveLocalSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    } else {
      await prefs.setString(key, value.toString());
    }
  }

  /// Get local settings (returns partial, for merge)
  Future<AppSettings> _getLocalSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return AppSettings(
      themeMode: prefs.getString('themeMode') ?? 'system',
      language: prefs.getString('language') ?? 'en',
      notificationsEnabled: prefs.getBool('notificationsEnabled') ?? true,
      // Add more as needed for local/device-specific settings
    );
  }

  /// Merge Firestore settings with local fallback for null/default values
  AppSettings _mergeSettings(AppSettings remote, AppSettings local) {
    return remote.copyWith(
      themeMode: _pick(remote.themeMode, local.themeMode, 'system'),
      language: _pick(remote.language, local.language, 'en'),
      notificationsEnabled: remote.notificationsEnabled ?? local.notificationsEnabled,
      marketingOptIn: remote.marketingOptIn ?? local.marketingOptIn,
      // Add more as needed for new fields
      custom: {...local.custom, ...remote.custom},
    );
  }

  /// Utility: pick non-default, else fallback, else default
  T _pick<T>(T? primary, T? fallback, T def) {
    if (primary == null) return fallback ?? def;
    if (primary is String && primary.isEmpty) return fallback ?? def;
    return primary;
  }

  /// Get feature flags from .env
  Map<String, bool> _getEnvFeatureFlags() {
    final envVars = dotenv.env;
    final flags = <String, bool>{};
    envVars.forEach((key, value) {
      if (key.startsWith('FEATURE_FLAG_')) {
        flags[key.replaceFirst('FEATURE_FLAG_', '').toLowerCase()] =
            value.toLowerCase() == 'true';
      }
    });
    return flags;
  }

  /// Get feature flags from Firebase Remote Config
  Future<Map<String, bool>> _getRemoteConfigFeatureFlags() async {
    await _remoteConfig.fetchAndActivate();
    final flags = <String, bool>{};
    _remoteConfig.getAll().forEach((key, value) {
      if (key.startsWith('feature_flag_')) {
        flags[key.replaceFirst('feature_flag_', '').toLowerCase()] =
            value.asBool();
      }
    });
    return flags;
  }

  /// Update a settings object with a key/value (for any field, extensible!)
  AppSettings _updateAppSettings(AppSettings settings, String key, dynamic value) {
    switch (key) {
      case 'themeMode':
        return settings.copyWith(themeMode: value as String);
      case 'language':
        return settings.copyWith(language: value as String);
      case 'notificationsEnabled':
        return settings.copyWith(notificationsEnabled: value as bool);
      case 'marketingOptIn':
        return settings.copyWith(marketingOptIn: value as bool);
    // ...extend as you add new fields!
      default:
        final custom = Map<String, dynamic>.from(settings.custom);
        custom[key] = value;
        return settings.copyWith(custom: custom);
    }
  }

  /// Check RBAC (admin can edit any, user can edit own, certain settings are admin-only)
  bool canEditSetting(String key, {required Set<String> roles}) {
    if (roles.contains('Admin')) return true;
    if (['appVersion', 'buildNumber', 'legalUrl', 'copyright'].contains(key)) {
      return false;
    }
    return true;
  }

  /// For debug/dev tool visibility
  bool showDebugTools({bool isDebug = false}) => isDebug;
}
