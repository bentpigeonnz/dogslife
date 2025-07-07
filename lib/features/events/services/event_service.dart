import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {
  // --- Strongly-typed collection with .withConverter<Event> ---
  final CollectionReference<Event> _eventsRef =
  FirebaseFirestore.instance.collection('events').withConverter<Event>(
    fromFirestore: (snapshot, _) => Event.fromFirestore(snapshot),
    toFirestore: (event, _) => event.toFirestore(),
  );

  /// Fetch a single event by ID.
  Future<Event?> getEventById(String eventId) async {
    final doc = await _eventsRef.doc(eventId).get();
    return doc.data();
  }

  /// Listen to a single event in real time.
  Stream<Event?> streamEventById(String eventId) {
    return _eventsRef.doc(eventId).snapshots().map((doc) => doc.data());
  }

  /// List all events, optionally filtered by status or tags.
  Future<List<Event>> getAllEvents({String? status, List<String>? tags}) async {
    Query<Event> query = _eventsRef.orderBy('date');
    if (status != null) query = query.where('status', isEqualTo: status);
    if (tags != null && tags.isNotEmpty) query = query.where('tags', arrayContainsAny: tags);
    final snap = await query.get();
    return snap.docs.map((d) => d.data()).whereType<Event>().toList();
  }

  /// Real-time stream for all events.
  Stream<List<Event>> streamAllEvents({String? status}) {
    Query<Event> query = _eventsRef.orderBy('date');
    if (status != null) query = query.where('status', isEqualTo: status);
    return query.snapshots().map((snap) =>
        snap.docs.map((d) => d.data()).whereType<Event>().toList());
  }

  /// Add new event, with optional actor for audit log.
  Future<String?> addEvent(Event event, {String? actor}) async {
    final data = event.toFirestore();
    data['activityLog'] = _addAuditLogEntry([], 'Created', actor: actor);
    final docRef = await _eventsRef.add(Event.fromJson({...data, 'id': ''}));
    return docRef.id;
  }

  /// Update event, appends to activity log.
  Future<bool> updateEvent(Event event, {String? actor}) async {
    final oldDoc = await _eventsRef.doc(event.id).get();
    final prevLog = List<Map<String, dynamic>>.from(
        (oldDoc.data()?.toFirestore()['activityLog'] ?? []));
    final newLog = _addAuditLogEntry(prevLog, 'Updated', actor: actor);
    await _eventsRef.doc(event.id).set(
      Event.fromJson({
        ...event.toFirestore(),
        'activityLog': newLog,
        'id': event.id,
      }),
      SetOptions(merge: true),
    );
    return true;
  }

  /// Delete event, logs the action.
  Future<bool> deleteEvent(String eventId, {String? actor}) async {
    final doc = await _eventsRef.doc(eventId).get();
    final prevLog = List<Map<String, dynamic>>.from(
        (doc.data()?.toFirestore()['activityLog'] ?? []));
    await _eventsRef.doc(eventId).update({
      'activityLog': _addAuditLogEntry(prevLog, 'Deleted', actor: actor)
    });
    await _eventsRef.doc(eventId).delete();
    return true;
  }

  /// RSVP (add userId to attendees).
  Future<void> rsvpEvent(String eventId, String userId, {String? actor}) async {
    await _eventsRef.doc(eventId).update({
      'attendees': FieldValue.arrayUnion([userId]),
      'activityLog': FieldValue.arrayUnion([_auditLogEntry('RSVP', actor: actor ?? userId)]),
    });
  }

  /// Cancel RSVP (remove userId).
  Future<void> cancelRsvpEvent(String eventId, String userId, {String? actor}) async {
    await _eventsRef.doc(eventId).update({
      'attendees': FieldValue.arrayRemove([userId]),
      'activityLog': FieldValue.arrayUnion([_auditLogEntry('CancelRSVP', actor: actor ?? userId)]),
    });
  }

  // ----- Audit Log Helpers -----
  List<Map<String, dynamic>> _addAuditLogEntry(List<Map<String, dynamic>> log, String action, {String? actor}) {
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
