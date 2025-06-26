import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service for managing Breeds in Firestore.
class FirestoreBreedService {
  final CollectionReference _breedsCollection =
  FirebaseFirestore.instance.collection('breeds');

  /// Fetch all breeds as a List of Strings.
  Future<List<String>> getBreeds() async {
    try {
      final querySnapshot = await _breedsCollection.get();
      return querySnapshot.docs
          .map((doc) => doc['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    } catch (e) {
      debugPrint('Error fetching breeds: $e');
      return [];
    }
  }

  /// Add a new breed to Firestore.
  Future<void> addBreed(String breed) async {
    try {
      await _breedsCollection.add({'name': breed});
    } catch (e) {
      debugPrint('Error adding breed: $e');
    }
  }

  /// Delete a breed by document ID.
  Future<void> deleteBreed(String docId) async {
    try {
      await _breedsCollection.doc(docId).delete();
    } catch (e) {
      debugPrint('Error deleting breed: $e');
    }
  }
}
