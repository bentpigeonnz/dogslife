// lib/features/dogs/providers/all_dogs_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dog.dart';
import 'dog_service_provider.dart';

/// Provides a one-time (static) list of all dogs from Firestore.
///
/// Usage: `ref.watch(allDogsProvider)`
final allDogsProvider = FutureProvider<List<Dog>>((ref) async {
  final dogService = ref.watch(dogServiceProvider);
  return await dogService.getAllDogs();
});
