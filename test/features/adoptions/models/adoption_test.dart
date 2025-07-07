import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/adoptions/models/adoption.dart';

void main() {
  test('Adoption serializes/deserializes', () {
    final adoption = Adoption(
      id: 'a1',
      dogId: 'd1',
      applicantId: 'u1',
      status: 'pending',
      comments: 'Excited to adopt!',
      appliedAt: DateTime(2024, 3, 2),
    );
    final json = adoption.toJson();
    final adoption2 = Adoption.fromJson(json);
    expect(adoption2.dogId, 'd1');
  });
}
