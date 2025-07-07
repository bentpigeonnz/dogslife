import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/merchandise/models/merchandise.dart';

void main() {
  test('Merchandise serializes/deserializes', () {
    final merch = Merchandise(
      id: 'm1',
      name: 'Dog Collar',
      description: 'A strong collar',
      price: 24.99,
      stock: 12,
      photoUrls: ['collar.png'],
    );
    final json = merch.toJson();
    final merch2 = Merchandise.fromJson(json);
    expect(merch2.name, 'Dog Collar');
  });
}
