import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service for managing Vaccines in Firestore.
class FirestoreVaccineService {
  final CollectionReference _vaccinesCollection =
  FirebaseFirestore.instance.collection('vaccines');

  /// Fetch all vaccines as a list of Map\<String, String>\.
  Future<List<Map<String, String>>> getVaccines() async {
    try {
      final querySnapshot = await _vaccinesCollection.get();
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'productName': data['productName']?.toString() ?? '',
          'manufacturer': data['manufacturer']?.toString() ?? '',
          'name': data['name']?.toString() ?? '',
          'description': data['description']?.toString() ?? '',
        };
      }).where((vaccine) => vaccine['name']!.isNotEmpty).toList();
    } catch (e) {
      debugPrint('Error fetching vaccines: $e');
      return [];
    }
  }

  /// Add a new vaccine to Firestore.
  Future<void> addVaccine({
    required String productName,
    required String manufacturer,
    required String name,
    required String description,
  }) async {
    try {
      await _vaccinesCollection.add({
        'productName': productName,
        'manufacturer': manufacturer,
        'name': name,
        'description': description,
      });
    } catch (e) {
      debugPrint('Error adding vaccine: $e');
    }
  }

  /// Delete a vaccine by document ID.
  Future<void> deleteVaccine(String docId) async {
    try {
      await _vaccinesCollection.doc(docId).delete();
    } catch (e) {
      debugPrint('Error deleting vaccine: $e');
    }
  }
}
