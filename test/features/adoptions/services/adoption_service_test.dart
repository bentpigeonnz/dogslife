import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/adoptions/services/adoption_service.dart';
import 'package:dogsLife/features/adoptions/models/adoption.dart';

void main() {
  test('getAdoptionById returns null for unknown', () async {
    final adoption = await AdoptionService.getAdoptionById('notfound');
    expect(adoption, isNull);
  });

  test('addAdoption returns without error', () async {
    final adoption = Adoption(
      id: 'test',
      dogId: 'dogId',
      applicantId: 'userId',
      status: 'pending',
      comments: '',
      appliedAt: DateTime.now(),
    );
    await AdoptionService.addAdoption(adoption);
    // No error = pass
  });
}
