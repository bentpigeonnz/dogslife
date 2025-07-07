// test/features/dogs/mocks/mock_dog_service.dart
import 'package:dogs_life/features/dogs/models/dog.dart';

class MockDogService {
  final List<Dog> _dogs = [
    Dog(
      id: 'dog1',
      name: 'Buddy',
      breed: 'Labrador',
      ageYears: 3,
      ageMonths: 6,
      gender: DogGender.male,
      description: 'Friendly dog',
      photoUrls: ['https://example.com/buddy.jpg'],
    ),
    Dog(
      id: 'dog2',
      name: 'Molly',
      breed: 'Poodle',
      ageYears: 2,
      ageMonths: 0,
      gender: DogGender.female,
      description: 'Smart poodle',
      photoUrls: [],
    ),
  ];

  Future<List<Dog>> getAllDogs() async => List.from(_dogs);

  Future<Dog?> getDogById(String id) async =>
      _dogs.firstWhere((d) => d.id == id, orElse: () => null);

  Future<void> addDog(Dog dog) async {
    _dogs.add(dog);
  }

  Future<void> updateDog(Dog updated) async {
    final idx = _dogs.indexWhere((d) => d.id == updated.id);
    if (idx != -1) _dogs[idx] = updated;
  }

  Stream<List<Dog>> streamAllDogs() async* {
    yield List.from(_dogs);
  }

  Stream<Dog?> streamDogById(String id) async* {
    yield _dogs.firstWhere((d) => d.id == id, orElse: () => null);
  }
}
