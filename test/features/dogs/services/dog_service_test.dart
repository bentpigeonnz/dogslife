import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogs_life/features/dogs/models/dog.dart';
import 'package:dogs_life/features/dogs/providers/dog_service_provider.dart';

import '../mocks/mock_dog_service.dart';

// You can use MockDogService from your previous test/mocks, or quickly stub it here.

void main() {
  group('DogService CRUD', () {
    late ProviderContainer container;
    late MockDogService mockService;

    setUp(() {
      mockService = MockDogService();
      container = ProviderContainer(
        overrides: [
          dogServiceProvider.overrideWithValue(mockService),
        ],
      );
    });

    tearDown(() => container.dispose());

    test('Create dog', () async {
      final dog = Dog(
        id: 'dog1',
        name: 'Buddy',
        ageYears: 2,
        ageMonths: 3,
        gender: DogGender.male,
        breed: 'Labrador',
        description: 'A lovely dog!',
        photoUrls: [],
        medicalStatus: 'Healthy',
        vaccinations: [],
        microchipNumber: '123ABC',
        microchipRegistry: 'NZ',
        adoptionStatus: AdoptionStatus.available,
        intakeDate: DateTime(2023, 1, 1),
      );

      await container.read(dogServiceProvider).addDog(dog);

      expect(mockService._dogs.length, 1);
      expect(mockService._dogs.first.name, 'Buddy');
    });

    test('Read dog by ID', () async {
      // Add fake data
      final dog = Dog(
        id: 'dog2',
        name: 'Max',
        ageYears: 1,
        ageMonths: 0,
        gender: DogGender.male,
        breed: 'Border Collie',
        description: '',
        photoUrls: [],
        medicalStatus: 'Healthy',
        vaccinations: [],
        microchipNumber: '',
        microchipRegistry: '',
        adoptionStatus: AdoptionStatus.available,
        intakeDate: DateTime(2023, 1, 1),
      );
      mockService._dogs.add(dog);

      final result = await container.read(dogServiceProvider).getDogById('dog2');
      expect(result, isNotNull);
      expect(result!.name, 'Max');
    });

    test('Update dog', () async {
      final dog = Dog(
        id: 'dog3',
        name: 'Rex',
        ageYears: 4,
        ageMonths: 0,
        gender: DogGender.male,
        breed: 'German Shepherd',
        description: '',
        photoUrls: [],
        medicalStatus: 'Healthy',
        vaccinations: [],
        microchipNumber: '',
        microchipRegistry: '',
        adoptionStatus: AdoptionStatus.available,
        intakeDate: DateTime(2023, 1, 1),
      );
      mockService._dogs.add(dog);

      final updatedDog = dog.copyWith(name: 'Rexy');
      await container.read(dogServiceProvider).updateDog(updatedDog);

      expect(mockService._dogs.first.name, 'Rexy');
    });

    test('Delete dog', () async {
      final dog = Dog(
        id: 'dog4',
        name: 'Spot',
        ageYears: 3,
        ageMonths: 5,
        gender: DogGender.female,
        breed: 'Dalmatian',
        description: '',
        photoUrls: [],
        medicalStatus: 'Healthy',
        vaccinations: [],
        microchipNumber: '',
        microchipRegistry: '',
        adoptionStatus: AdoptionStatus.available,
        intakeDate: DateTime(2023, 1, 1),
      );
      mockService._dogs.add(dog);

      await container.read(dogServiceProvider).deleteDog('dog4');
      expect(mockService._dogs, isEmpty);
    });

    test('List all dogs', () async {
      mockService._dogs.addAll([
        Dog(
          id: 'dog5',
          name: 'Fido',
          ageYears: 2,
          ageMonths: 2,
          gender: DogGender.male,
          breed: 'Mastiff',
          description: '',
          photoUrls: [],
          medicalStatus: 'Healthy',
          vaccinations: [],
          microchipNumber: '',
          microchipRegistry: '',
          adoptionStatus: AdoptionStatus.available,
          intakeDate: DateTime(2023, 1, 1),
        ),
        Dog(
          id: 'dog6',
          name: 'Lassie',
          ageYears: 5,
          ageMonths: 6,
          gender: DogGender.female,
          breed: 'Collie',
          description: '',
          photoUrls: [],
          medicalStatus: 'Healthy',
          vaccinations: [],
          microchipNumber: '',
          microchipRegistry: '',
          adoptionStatus: AdoptionStatus.adopted,
          intakeDate: DateTime(2022, 5, 5),
        ),
      ]);

      final allDogs = await container.read(dogServiceProvider).getAllDogs();
      expect(allDogs.length, 2);
      expect(allDogs.any((d) => d.name == 'Fido'), isTrue);
      expect(allDogs.any((d) => d.name == 'Lassie'), isTrue);
    });

    // Add more tests: error handling, permission checks, etc.
  });
}
