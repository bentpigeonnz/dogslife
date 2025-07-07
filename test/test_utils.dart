// test/test_utils.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

ProviderContainer makeProviderContainer({
  List<Override> overrides = const [],
}) {
  return ProviderContainer(overrides: overrides);
}

void disposeContainer(ProviderContainer container) {
  container.dispose();
}
