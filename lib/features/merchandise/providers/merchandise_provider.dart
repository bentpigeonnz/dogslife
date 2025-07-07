import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/merchandise_item.dart';
import '../services/merchandise_service.dart';

final merchServiceProvider = Provider((ref) => MerchandiseService());

final merchItemProvider = AsyncNotifierProvider.family<MerchItemAsyncNotifier, MerchItem?, String>(
  MerchItemAsyncNotifier.new,
);

class MerchItemAsyncNotifier extends FamilyAsyncNotifier<MerchItem?, String> {
  @override
  Future<MerchItem?> build(String itemId) async {
    final service = ref.read(merchServiceProvider);
    return await service.getItemById(itemId);
  }
}

final merchItemStreamProvider = StreamProvider.family<MerchItem?, String>((ref, id) {
  return ref.read(merchServiceProvider).streamItemById(id);
});

final allMerchItemsStreamProvider = StreamProvider<List<MerchItem>>((ref) {
  return ref.read(merchServiceProvider).streamAllItems();
});
