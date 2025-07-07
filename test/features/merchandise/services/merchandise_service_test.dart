import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/merchandise/services/merchandise_service.dart';
import 'package:dogsLife/features/merchandise/models/merchandise.dart';

void main() {
  test('getMerchById returns null for unknown', () async {
    final merch = await MerchandiseService.getMerchById('badid');
    expect(merch, isNull);
  });

  test('addMerch returns without error', () async {
    final merch = Merchandise(
      id: 'test',
      name: 'Test Merch',
      description: 'A merch item',
      price: 99.9,
      stock: 5,
      photoUrls: [],
    );
    await MerchandiseService.addMerch(merch);
  });
}
