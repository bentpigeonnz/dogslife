import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogs_life/features/dogs/providers/dog_provider.dart';
import '../mocks/mock_dog_service.dart';

void main() {
  group('dogProvider', () {
    late MockDogService mockDogService;

    setUp(() {
      mockDogService = MockDogService();
    });

    test('fetches dog by ID', () async {
      final container = ProviderContainer(overrides: [
        dogServiceProvider.overrideWithValue(mockDogService),
      ]);
      addTearDown(container.dispose);

      final dog = await container.read(dogProvider('dog1').future);

      expect(dog, isNotNull);
      expect(dog!.name, 'Buddy');
    });

    test('returns null for unknown dog', () async {
      final container = ProviderContainer(overrides: [
        dogServiceProvider.overrideWithValue(mockDogService),
      ]);
      addTearDown(container.dispose);

      final dog = await container.read(dogProvider('nonexistent').future);

      expect(dog, isNull);
    });
  });

  group('allDogsStreamProvider', () {
    late MockDogService mockDogService;

    setUp(() {
      mockDogService = MockDogService();
    });

    test('streams all dogs', () async {
      final container = ProviderContainer(overrides: [
        dogServiceProvider.overrideWithValue(mockDogService),
      ]);
      addTearDown(container.dispose);

      final dogsStream = container.read(allDogsStreamProvider.stream);

      final dogs = await dogsStream.first;
      expect(dogs.length, 2);
      expect(dogs.first.name, 'Buddy');
    });
  });
}
