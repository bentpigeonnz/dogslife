// lib/features/dogs/providers/dog_service_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/dog_service.dart';

/// Provides a singleton instance of DogService for all dog logic and CRUD.
///
/// Use `ref.watch(dogServiceProvider)` anywhere for Firestore/Storage access.
/// In tests, you can override this provider with a mock or fake.
final dogServiceProvider = Provider<DogService>((ref) => DogService());