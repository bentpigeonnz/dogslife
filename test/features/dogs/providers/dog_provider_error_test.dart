import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogsLife/features/dogs/providers/dog_provider.dart';

void main() {
  test('dogProvider emits error if DogService throws', () async {
    final container = ProviderContainer(overrides: [
      dogProvider.overrideWithProvider(
            (id) => throw Exception('Failed to load dog'),
      ),
    ]);
    expect(
          () => container.read(dogProvider('fail').future),
      throwsA(isA<Exception>()),
    );
  });
}
