// lib/features/dogs/providers/dog_stream_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dog.dart';
import 'dog_service_provider.dart';

/// Streams live updates for a single dog document by ID.
///
/// Usage: `ref.watch(dogStreamProvider(dogId))`
/// Will update UI as soon as the dog record changes.
final dogStreamProvider = StreamProvider.family<Dog?, String>((ref, dogId) {
  final dogService = ref.watch(dogServiceProvider);
  return dogService.streamDogById(dogId);
});
