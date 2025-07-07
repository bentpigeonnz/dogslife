import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    // Core
    @Default('system') String themeMode,         // 'light', 'dark', 'system'
    @Default('en') String language,              // e.g., 'en', 'fr'
    @Default(true) bool notificationsEnabled,
    @Default(true) bool marketingOptIn,
    @Default(false) bool showLegal,
    @Default(false) bool showAbout,
    @Default(false) bool allowFeedback,
    @Default(<String, dynamic>{}) Map<String, dynamic> privacyPrefs,
    @Default('') String accountEmail,
    String? accountDisplayName,
    String? accountAvatarUrl,
    // Feature flags (remote config, .env, or admin)
    @Default(<String, bool>{}) Map<String, bool> featureFlags,
    // Admin/debug/dev tools
    @Default(false) bool showDebugTools,
    // Version, about, and legal
    @Default('1.0.0') String appVersion,
    @Default('') String buildNumber,
    @Default('© 2025 dogsLife') String copyright,
    @Default('') String legalUrl,
    @Default('') String aboutText,
    // Advanced/custom settings
    @Default(<String, dynamic>{}) Map<String, dynamic> custom,
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) => _$AppSettingsFromJson(json);
}
