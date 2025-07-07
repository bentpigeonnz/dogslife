import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/adoption.dart';

class AdoptionService {
  static final _adoptionsRef = FirebaseFirestore.instance.collection('adoptions');

  static Stream<List<Adoption>> watchAllAdoptions() =>
      _adoptionsRef.snapshots().map((s) =>
          s.docs.map((doc) => Adoption.fromFirestore(doc)).toList());

  static Future<Adoption?> getAdoptionById(String id) async {
    final doc = await _adoptionsRef.doc(id).get();
    return doc.exists ? Adoption.fromFirestore(doc) : null;
  }

  static Future<void> addAdoption(Adoption adoption) async {
    await _adoptionsRef.add(adoption.toFirestore());
  }

  static Future<void> updateAdoption(Adoption adoption) async {
    await _adoptionsRef.doc(adoption.id).set(adoption.toFirestore());
  }

  static Future<void> deleteAdoption(String id) async {
    await _adoptionsRef.doc(id).delete();
  }

  static Stream<Adoption?> streamAdoptionById(String id) =>
      _adoptionsRef.doc(id).snapshots().map(
            (doc) => doc.exists ? Adoption.fromFirestore(doc) : null,
      );

}
