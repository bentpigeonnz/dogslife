import 'package:shared_preferences/shared_preferences.dart';

/// [SharedPrefsService] - A wrapper for reading/writing app settings and tokens.
///
/// Keeps all shared_preferences access in one place.
/// This service should be injected via Riverpod for testability and single source of truth.
///
class SharedPrefsService {
  SharedPreferences? _prefs;

  /// Call this at app start (or lazy-load below).
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save theme mode (e.g., 'light', 'dark', 'system')
  Future<void> setThemeMode(String mode) async {
    await _ensurePrefs();
    await _prefs!.setString('theme_mode', mode);
  }

  /// Get current theme mode, or null if not set.
  Future<String?> getThemeMode() async {
    await _ensurePrefs();
    return _prefs!.getString('theme_mode');
  }

  /// Save last used role (for dev tools, onboarding, etc)
  Future<void> setLastRole(String role) async {
    await _ensurePrefs();
    await _prefs!.setString('last_role', role);
  }

  Future<String?> getLastRole() async {
    await _ensurePrefs();
    return _prefs!.getString('last_role');
  }

  /// Save onboarding complete flag
  Future<void> setOnboardingComplete(bool complete) async {
    await _ensurePrefs();
    await _prefs!.setBool('onboarding_complete', complete);
  }

  Future<bool> isOnboardingComplete() async {
    await _ensurePrefs();
    return _prefs!.getBool('onboarding_complete') ?? false;
  }

  /// Utility to clear all prefs (for logout, debugging, etc)
  Future<void> clearAll() async {
    await _ensurePrefs();
    await _prefs!.clear();
  }

  /// Private helper to ensure _prefs is initialized
  Future<void> _ensurePrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
}
