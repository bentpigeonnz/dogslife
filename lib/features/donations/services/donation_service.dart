import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/donation.dart';

class DonationService {
  static final _donationsRef = FirebaseFirestore.instance.collection('donations');

  static Stream<List<Donation>> streamAllDonations() =>
      _donationsRef.orderBy('date', descending: true).snapshots().map(
            (s) => s.docs.map((doc) => Donation.fromFirestore(doc)).toList(),
      );

  static Stream<Donation?> streamDonationById(String id) =>
      _donationsRef.doc(id).snapshots().map(
            (doc) => doc.exists ? Donation.fromFirestore(doc) : null,
      );

  static Future<Donation?> getDonationById(String id) async {
    final doc = await _donationsRef.doc(id).get();
    return doc.exists ? Donation.fromFirestore(doc) : null;
  }

  static Future<void> addDonation(Donation donation) async {
    await _donationsRef.add(donation.toFirestore());
  }

  static Future<void> updateDonation(Donation donation) async {
    await _donationsRef.doc(donation.id).set(donation.toFirestore());
  }

  static Future<void> deleteDonation(String id) async {
    await _donationsRef.doc(id).delete();
  }
}
