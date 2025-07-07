import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:dogsLife/features/dogs/widgets/dog_card.dart';
import 'package:dogsLife/features/dogs/models/dog.dart';

void main() {
  testWidgets('DogCard displays dog name and breed', (WidgetTester tester) async {
    final dog = Dog(
      id: 'd1',
      name: 'Lucky',
      ageYears: 3,
      ageMonths: 4,
      gender: DogGender.male,
      breed: 'Beagle',
      description: '',
      photoUrls: [],
      medicalStatus: 'Healthy',
      vaccinations: [],
      microchipNumber: 'abc',
      microchipRegistry: 'Reg',
      adoptionStatus: AdoptionStatus.available,
      intakeDate: DateTime.now(),
    );
    await tester.pumpWidget(MaterialApp(home: DogCard(dog: dog)));
    expect(find.text('Lucky'), findsOneWidget);
    expect(find.text('Beagle'), findsOneWidget);
  });
}
