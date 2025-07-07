// features/adoptions/providers/adoption_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/adoption_service.dart';
import 'package:dogs_life/features/adoptions/models/adoption.dart';


// Single Adoption by ID (family)
final adoptionProvider = AsyncNotifierProvider.family<AdoptionAsyncNotifier, Adoption?, String>(
  AdoptionAsyncNotifier.new,
);

class AdoptionAsyncNotifier extends FamilyAsyncNotifier<Adoption?, String> {
  @override
  Future<Adoption?> build(String adoptionId) {
    return AdoptionService.getAdoptionById(adoptionId);
  }
}

// Real-time stream of a single Adoption (family)
final adoptionStreamProvider = StreamProvider.family<Adoption?, String>(
      (ref, id) => AdoptionService.streamAdoptionById(id),
);

// Real-time stream of all Adoptions
final allAdoptionsStreamProvider = StreamProvider<List<Adoption>>(
      (ref) => AdoptionService.watchAllAdoptions(),
);