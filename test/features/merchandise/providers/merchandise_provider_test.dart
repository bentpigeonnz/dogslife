import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogsLife/features/merchandise/providers/merchandise_provider.dart';
import 'package:dogsLife/features/merchandise/models/merchandise.dart';

class FakeMerchService {
  static Merchandise fakeMerch = Merchandise(
    id: 'm1',
    name: 'T-Shirt',
    description: 'Cotton tee',
    price: 29.0,
    stock: 42,
    photoUrls: ['tshirt.png'],
  );
  static Future<Merchandise?> getMerchById(String id) async => fakeMerch;
}

void main() {
  test('merchandiseProvider returns fake merch', () async {
    final container = ProviderContainer(overrides: [
      merchandiseProvider.overrideWithProvider((id) => AsyncValue.data(FakeMerchService.fakeMerch)),
    ]);
    final merch = await container.read(merchandiseProvider('m1').future);
    expect(merch?.name, 'T-Shirt');
  });

  test('allMerchandiseStreamProvider returns list with fake merch', () async {
    final container = ProviderContainer(overrides: [
      allMerchandiseStreamProvider.overrideWith((ref) => Stream.value([FakeMerchService.fakeMerch])),
    ]);
    final list = await container.read(allMerchandiseStreamProvider.future);
    expect(list.first.name, 'T-Shirt');
  });
}
