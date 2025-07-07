import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/dogs/models/dog.dart';

void main() {
  test('Dog serializes/deserializes to JSON', () {
    final dog = Dog(
      id: 'd1',
      name: 'Buddy',
      ageYears: 2,
      ageMonths: 6,
      gender: DogGender.male,
      breed: 'Labrador',
      description: 'Friendly and energetic.',
      photoUrls: ['url1', 'url2'],
      medicalStatus: 'Healthy',
      vaccinations: [],
      microchipNumber: '12345',
      microchipRegistry: 'NZ PetReg',
      adoptionStatus: AdoptionStatus.available,
      intakeDate: DateTime(2023, 5, 10),
    );
    final json = dog.toJson();
    final dog2 = Dog.fromJson(json);
    expect(dog2.name, 'Buddy');
    expect(dog2.breed, 'Labrador');
  });
}
