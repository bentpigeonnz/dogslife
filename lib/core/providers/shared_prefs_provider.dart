import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/shared_prefs_service.dart';

/// Global provider for [SharedPrefsService].
/// Use this everywhere instead of directly calling SharedPreferences.
final sharedPrefsServiceProvider = Provider<SharedPrefsService>((ref) {
  final service = SharedPrefsService();
  // Optionally call service.init() at app start if you want eager loading
  return service;
});
