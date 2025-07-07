import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogsLife/features/adoptions/providers/adoption_provider.dart';
import 'package:dogsLife/features/adoptions/models/adoption.dart';

class FakeAdoptionService {
  static Adoption fakeAdoption = Adoption(
    id: 'a1',
    dogId: 'd1',
    applicantId: 'u1',
    status: 'pending',
    comments: 'Excited!',
    appliedAt: DateTime(2024, 1, 1),
  );
  static Future<Adoption?> getAdoptionById(String id) async => fakeAdoption;
}

void main() {
  test('adoptionProvider returns fake adoption', () async {
    final container = ProviderContainer(overrides: [
      adoptionProvider.overrideWithProvider((id) => AsyncValue.data(FakeAdoptionService.fakeAdoption)),
    ]);
    final adoption = await container.read(adoptionProvider('a1').future);
    expect(adoption?.status, 'pending');
  });

  test('allAdoptionsStreamProvider returns list with fake adoption', () async {
    final container = ProviderContainer(overrides: [
      allAdoptionsStreamProvider.overrideWith((ref) => Stream.value([FakeAdoptionService.fakeAdoption])),
    ]);
    final list = await container.read(allAdoptionsStreamProvider.future);
    expect(list.first.id, 'a1');
  });
}
