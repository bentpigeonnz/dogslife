import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogs_life/features/dogs/screens/dog_detail_screen.dart';
import 'package:dogs_life/features/dogs/providers/dog_provider.dart';
import 'package:dogs_life/features/dogs/providers/dog_service_provider.dart';
import '../mocks/mock_dog_service.dart';

// Mock RoleProvider (since RBAC guards the UI)
final testRoleProvider = Provider<String>((ref) => 'admin');

void main() {
  testWidgets('DogDetailScreen displays dog details', (tester) async {
    final mockService = MockDogService();
    final dogId = 'dog1';

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dogServiceProvider.overrideWithValue(mockService),
          dogProvider(dogId).overrideWith((ref) async => mockService.getDogById(dogId)),
          // Add your RoleProvider override here if needed for RBAC logic
          // roleProvider.overrideWith((ref) => AsyncValue.data('admin')),
        ],
        child: MaterialApp(
          home: DogDetailScreen(dogId: dogId),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // The dog should appear
    expect(find.text('Buddy'), findsOneWidget);
    expect(find.text('Labrador'), findsOneWidget);

    // Check for RBAC-guarded UI
    expect(find.widgetWithText(ElevatedButton, 'Edit'), findsOneWidget);
  });

  testWidgets('DogDetailScreen shows not found for missing dog', (tester) async {
    final mockService = MockDogService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dogServiceProvider.overrideWithValue(mockService),
          dogProvider('missing').overrideWith((ref) async => null),
        ],
        child: MaterialApp(
          home: DogDetailScreen(dogId: 'missing'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Dog not found.'), findsOneWidget);
  });
}
