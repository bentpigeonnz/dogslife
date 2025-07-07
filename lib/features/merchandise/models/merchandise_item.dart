// lib/features/merchandise/models/merchandise_item.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'merchandise_item.freezed.dart';
part 'merchandise_item.g.dart';

@freezed
class MerchVariant with _$MerchVariant {
  const factory MerchVariant({
    required String id,
    required String name,
    required double price,
    @Default(0) int stock,
    String? imageUrl,
    @Default(false) bool isActive,
  }) = _MerchVariant;

  factory MerchVariant.fromJson(Map<String, dynamic> json) =>
      _$MerchVariantFromJson(json);
}

@freezed
class MerchItem with _$MerchItem {
  const factory MerchItem({
    required String id,
    required String name,
    String? description,
    required double price,
    double? salePrice,
    DateTime? saleEndsAt,
    @Default([]) List<String> imageUrls,
    @Default(true) bool isActive,
    @Default('misc') String category,
    @Default(0) int stock,
    @Default([]) List<MerchVariant> variants,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default([]) List<Map<String, dynamic>> activityLog,
  }) = _MerchItem;

  factory MerchItem.fromJson(Map<String, dynamic> json) =>
      _$MerchItemFromJson(json);

  factory MerchItem.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      MerchItem.fromJson({...doc.data() ?? {}, 'id': doc.id});
}

/// 🟢 Firestore save extension for MerchItem
extension MerchItemFirestoreX on MerchItem {
  Map<String, dynamic> toFirestore() {
    final data = toJson();
    data.remove('id'); // id is in doc id, not data
    return data;
  }
}
