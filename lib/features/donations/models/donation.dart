// lib/features/donations/models/donation.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'donation.freezed.dart';
part 'donation.g.dart';

/// Data model for a donation record (used for Firestore, API, UI, etc)
@freezed
class Donation with _$Donation {
  /// Main Donation factory
  const factory Donation({
    required String id,                // Firestore doc id
    required double amount,            // Amount in local currency (e.g., NZD)
    required String donorName,         // Name of donor (required)
    String? donorEmail,                // Optional, for receipt/contact
    String? message,                   // Optional message from donor
    DateTime? date,                    // Date of donation (nullable for legacy/quick add)
    String? paymentMethod,             // e.g. 'Credit Card', 'Bank Transfer'
    String? receiptUrl,                // If a receipt was issued/provided
    @Default('pending') String status, // 'pending', 'completed', 'failed', etc.
  }) = _Donation;

  /// Factory for deserializing from JSON (for Firestore/REST)
  factory Donation.fromJson(Map<String, dynamic> json) => _$DonationFromJson(json);

  /// Factory for creating Donation from Firestore DocumentSnapshot
  factory Donation.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Donation.fromJson({...doc.data() ?? {}, 'id': doc.id});
}

/// Extension for Firestore serialization (keeps 'id' out of doc data)
extension DonationFirestoreX on Donation {
  /// Serializes for Firestore—removes 'id' (it’s the doc key)
  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id');
    return json;
  }
}
