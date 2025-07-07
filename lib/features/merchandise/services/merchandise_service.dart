import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/merchandise_item.dart';

class MerchandiseService {
  final _itemsRef = FirebaseFirestore.instance.collection('merchandise');

  Future<MerchItem?> getItemById(String id) async {
    final doc = await _itemsRef.doc(id).get();
    if (!doc.exists) return null;
    return MerchItem.fromFirestore(doc);
  }

  Stream<MerchItem?> streamItemById(String id) =>
      _itemsRef.doc(id).snapshots().map((doc) => doc.exists ? MerchItem.fromFirestore(doc) : null);

  Stream<List<MerchItem>> streamAllItems() =>
      _itemsRef.orderBy('name').snapshots().map((snap) =>
          snap.docs.map((d) => MerchItem.fromFirestore(d)).toList());

  Future<String?> addItem(MerchItem item, {String? actor}) async {
    final data = item.toFirestore();
    data['activityLog'] = _addAuditLogEntry([], 'Created', actor: actor);
    final doc = await _itemsRef.add(data);
    return doc.id;
  }

  Future<void> updateItem(MerchItem item, {String? actor}) async {
    final oldDoc = await _itemsRef.doc(item.id).get();
    final prevLog = List<Map<String, dynamic>>.from((oldDoc.data()?['activityLog'] ?? []));
    final newLog = _addAuditLogEntry(prevLog, 'Updated', actor: actor);
    await _itemsRef.doc(item.id).set({
      ...item.toFirestore(),
      'activityLog': newLog,
    }, SetOptions(merge: true));
  }

  Future<void> deleteItem(String id, {String? actor}) async {
    final oldDoc = await _itemsRef.doc(id).get();
    final prevLog = List<Map<String, dynamic>>.from((oldDoc.data()?['activityLog'] ?? []));
    await _itemsRef.doc(id).update({'activityLog': _addAuditLogEntry(prevLog, 'Deleted', actor: actor)});
    await _itemsRef.doc(id).delete();
  }

  // ---- Audit log helpers ----
  List<Map<String, dynamic>> _addAuditLogEntry(List<Map<String, dynamic>> log, String action, {String? actor}) {
    final entry = {
      'action': action,
      'actor': actor ?? 'system',
      'timestamp': DateTime.now().toIso8601String(),
    };
    return [entry, ...log];
  }
}
