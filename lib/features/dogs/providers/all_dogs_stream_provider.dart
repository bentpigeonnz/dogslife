// lib/features/dogs/providers/all_dogs_stream_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dog.dart';
import 'dog_service_provider.dart';

/// Streams real-time updates for the entire dogs collection.
///
/// Usage: `ref.watch(allDogsStreamProvider)`
final allDogsStreamProvider = StreamProvider<List<Dog>>((ref) {
  final dogService = ref.watch(dogServiceProvider);
  return dogService.streamAllDogs();
});
