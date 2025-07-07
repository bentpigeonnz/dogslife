// lib/features/dogs/models/dog.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'dog.freezed.dart';
part 'dog.g.dart';

/// Enum for dog gender with clear values
enum DogGender { male, female, unknown }

@freezed
class Dog with _$Dog {
  /// The main Dog data model
  const factory Dog({
    required String id,
    required String name,
    String? breed,
    int? ageYears,
    int? ageMonths,
    String? description,
    @Default([]) List<String> photoUrls,
    String? medicalStatus,
    @Default([]) List<Map<String, dynamic>> vaccinations,
    String? microchipNumber,
    String? microchipRegistry,
    @Default('available') String adoptionStatus, // Use 'available', 'pending', 'adopted', etc.
    required DateTime intakeDate,
    @Default(DogGender.unknown) DogGender gender,
    String? notes,
  }) = _Dog;

  /// Factory constructor to create Dog from JSON (for API and Firestore)
  factory Dog.fromJson(Map<String, dynamic> json) => _$DogFromJson(json);

  /// Factory constructor to create Dog from Firestore DocumentSnapshot
  factory Dog.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Dog.fromJson({...doc.data() ?? {}, 'id': doc.id});
}

/// Extension to add Firestore serialization for Dog
extension DogFirestoreX on Dog {
  /// Convert Dog instance to Firestore map (removes the 'id')
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Never store Firestore doc IDs inside the doc data
    return json;
  }
}
