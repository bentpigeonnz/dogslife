// lib/features/dogs/services/dog_service.dart

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/dog.dart';

/// Service class for all dog-related Firestore/Storage logic.
/// Use dependency injection with Riverpod for testability.
class DogService {
  final CollectionReference<Map<String, dynamic>> _dogsRef;
  final Reference _storageRef;

  DogService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _dogsRef = (firestore ?? FirebaseFirestore.instance).collection('dogs'),
        _storageRef = (storage ?? FirebaseStorage.instance).ref('dog_images');

  /// Get a single dog by Firestore doc ID
  Future<Dog?> getDogById(String dogId) async {
    try {
      final doc = await _dogsRef.doc(dogId).get();
      if (!doc.exists) return null;
      return Dog.fromFirestore(doc);
    } catch (e) {
      // Log, report, or rethrow as needed.
      return null;
    }
  }

  /// Stream a single dog (for live updates)
  Stream<Dog?> streamDogById(String dogId) {
    return _dogsRef.doc(dogId).snapshots().map((doc) {
      if (!doc.exists) return null;
      return Dog.fromFirestore(doc);
    });
  }

  /// Get all dogs, optionally paginated
  Future<List<Dog>> getAllDogs({int? limit, DocumentSnapshot? startAfter}) async {
    try {
      Query<Map<String, dynamic>> query = _dogsRef.orderBy('name');
      if (limit != null) query = query.limit(limit);
      if (startAfter != null) query = query.startAfterDocument(startAfter);
      final snap = await query.get();
      return snap.docs.map((doc) => Dog.fromFirestore(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  /// Stream all dogs (live updates)
  Stream<List<Dog>> streamAllDogs() {
    return _dogsRef.orderBy('name').snapshots().map(
          (snap) => snap.docs.map((doc) => Dog.fromFirestore(doc)).toList(),
    );
  }

  /// Add a new dog, returns new ID
  Future<String?> addDog(Dog dog, {String? actor}) async {
    try {
      final data = dog.toFirestore();
      data['activityLog'] = _addAuditLogEntry([], 'Created', actor: actor);
      final doc = await _dogsRef.add(data);
      return doc.id;
    } catch (e) {
      return null;
    }
  }

  /// Update an existing dog
  Future<bool> updateDog(Dog dog, {String? actor}) async {
    try {
      final oldDoc = await _dogsRef.doc(dog.id).get();
      final prevLog = List<Map<String, dynamic>>.from(
          (oldDoc.data()?['activityLog'] ?? []));
      final newLog = _addAuditLogEntry(prevLog, 'Updated', actor: actor);
      await _dogsRef.doc(dog.id).set({
        ...dog.toFirestore(),
        'activityLog': newLog,
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Delete a dog (with audit log)
  Future<bool> deleteDog(String dogId, {String? actor}) async {
    try {
      final doc = await _dogsRef.doc(dogId).get();
      final prevLog = List<Map<String, dynamic>>.from(
          (doc.data()?['activityLog'] ?? []));
      await _dogsRef.doc(dogId).update({
        'activityLog': _addAuditLogEntry(prevLog, 'Deleted', actor: actor),
      });
      await _dogsRef.doc(dogId).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Uploads a local image file and returns its download URL
  Future<String?> uploadDogImage(String dogId, String localPath) async {
    try {
      final fileName = localPath.split('/').last;
      final ref = _storageRef.child('$dogId/$fileName');
      await ref.putFile(File(localPath));
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  /// Deletes an image from Storage
  Future<bool> deleteDogImage(String url) async {
    try {
      await FirebaseStorage.instance.refFromURL(url).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Batch add multiple dogs
  Future<List<String>> batchAddDogs(List<Dog> dogs, {String? actor}) async {
    final batch = _dogsRef.firestore.batch();
    final addedIds = <String>[];
    try {
      for (final dog in dogs) {
        final doc = _dogsRef.doc();
        batch.set(doc, {
          ...dog.toFirestore(),
          'activityLog': _addAuditLogEntry([], 'BatchCreated', actor: actor)
        });
        addedIds.add(doc.id);
      }
      await batch.commit();
      return addedIds;
    } catch (e) {
      return [];
    }
  }

  /// Batch delete dogs
  Future<void> batchDeleteDogs(List<String> dogIds, {String? actor}) async {
    final batch = _dogsRef.firestore.batch();
    try {
      for (final id in dogIds) {
        final doc = _dogsRef.doc(id);
        batch.update(doc, {
          'activityLog': FieldValue.arrayUnion(
            [_auditLogEntry('BatchDeleted', actor: actor)],
          ),
        });
        batch.delete(doc);
      }
      await batch.commit();
    } catch (e) {
      // Ignore, handle in caller if needed
    }
  }

  // -------- Audit Log Helpers --------

  List<Map<String, dynamic>> _addAuditLogEntry(
      List<Map<String, dynamic>> log, String action,
      {String? actor}) {
    final entry = _auditLogEntry(action, actor: actor);
    return [entry, ...log];
  }

  Map<String, dynamic> _auditLogEntry(String action, {String? actor}) {
    return {
      'action': action,
      'actor': actor ?? 'system',
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
}
