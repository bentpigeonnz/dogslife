import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogs_life/features/dogs/screens/dog_form_screen.dart';
import 'package:dogs_life/features/dogs/providers/dog_service_provider.dart';
import '../mocks/mock_dog_service.dart';

// You might also need to override other providers (e.g. RBAC)
final testRoleProvider = Provider<String>((ref) => 'admin');

void main() {
  testWidgets('DogFormScreen creates a dog when form is submitted', (tester) async {
    final mockService = MockDogService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dogServiceProvider.overrideWithValue(mockService),
          // Add RBAC or theme overrides as needed
        ],
        child: const MaterialApp(
          home: DogFormScreen(),
        ),
      ),
    );

    // Fill in the form fields
    await tester.enterText(find.byType(TextFormField).at(0), 'Rex');
    await tester.enterText(find.byType(TextFormField).at(2), '3'); // Age (years)
    await tester.enterText(find.byType(TextFormField).at(3), '6'); // Age (months)
    await tester.enterText(find.byType(TextFormField).at(5), 'German Shepherd');

    // Tap "Add Dog"
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Dog'));
    await tester.pumpAndSettle();

    // In a real test, verify navigation or success feedback
    // (Depends how your app signals a successful save)
    // For now, ensure no validation errors
    expect(find.text('Required'), findsNothing);

    // (Optional) Check the mock service
    expect(mockService._dogs.any((d) => d.name == 'Rex'), isTrue);
  });

  testWidgets('DogFormScreen validates empty required fields', (tester) async {
    final mockService = MockDogService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dogServiceProvider.overrideWithValue(mockService),
        ],
        child: const MaterialApp(
          home: DogFormScreen(),
        ),
      ),
    );

    // Tap "Add Dog" without filling anything
    await tester.tap(find.widgetWithText(ElevatedButton, 'Add Dog'));
    await tester.pumpAndSettle();

    // Should show at least one validation error
    expect(find.text('Required'), findsWidgets);
  });
}
