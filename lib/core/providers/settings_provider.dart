import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsState {
  final bool someFlag;
  const SettingsState({this.someFlag = false});
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void toggleFlag() => state = SettingsState(someFlag: !state.someFlag);
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
        (ref) => SettingsNotifier());
