import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogs_life/features/dogs/screens/dog_list_screen.dart';
import 'package:dogs_life/features/dogs/providers/all_dogs_stream_provider.dart';
import 'package:dogs_life/features/dogs/models/dog.dart';

void main() {
  testWidgets('DogListScreen displays dogs', (tester) async {
    // Use a fake stream provider for dogs
    final testDogs = [
      Dog(
        id: 'dog1',
        name: 'Buddy',
        breed: 'Labrador',
        ageYears: 3,
        ageMonths: 6,
        gender: DogGender.male,
        description: 'Friendly dog',
        photoUrls: [],
      )
    ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          allDogsStreamProvider.overrideWith((_) => Stream.value(testDogs)),
        ],
        child: const MaterialApp(home: DogListScreen()),
      ),
    );

    expect(find.text('Buddy'), findsOneWidget);
    expect(find.text('Labrador'), findsOneWidget);
  });
}
