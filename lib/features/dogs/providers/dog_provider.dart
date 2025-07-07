// lib/features/dogs/providers/dog_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dog.dart';
import '../services/dog_service.dart';

/// 1️⃣ Provider for your DogService instance (for dependency injection)
final dogServiceProvider = Provider<DogService>((ref) {
  return DogService(); // Optionally pass Firestore/Storage for mocks/testing
});

/// 2️⃣ Async family provider for a single Dog (by ID)
final dogProvider = FutureProvider.family<Dog?, String>((ref, dogId) {
  final service = ref.watch(dogServiceProvider);
  return service.getDogById(dogId);
});

/// 3️⃣ Stream family provider for real-time updates for a single Dog
final dogStreamProvider = StreamProvider.family<Dog?, String>((ref, dogId) {
  final service = ref.watch(dogServiceProvider);
  return service.streamDogById(dogId);
});

/// 4️⃣ Stream provider for all dogs (real-time list)
final allDogsStreamProvider = StreamProvider<List<Dog>>((ref) {
  final service = ref.watch(dogServiceProvider);
  return service.streamAllDogs();
});
