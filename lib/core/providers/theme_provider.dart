import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/material.dart';

// This provider controls the app's theme (light/dark/system)
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
