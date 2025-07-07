// lib/features/events/models/event.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'event.freezed.dart';
part 'event.g.dart';

/// Event model for fundraisers, adoption days, etc.
@freezed
class Event with _$Event {
  const factory Event({
    required String id,                          // Firestore document id
    required String title,                       // Title of the event
    String? description,                         // Optional description
    required DateTime date,                      // Date & time of event
    String? location,                            // Where is it?
    @Default([]) List<String> photoUrls,         // Photo/gallery URLs
    @Default('upcoming') String status,          // 'upcoming', 'completed', 'archived'
    String? organizerId,                         // User ID of the organizer
    @Default([]) List<String> attendees,         // User IDs of attendees
    @Default([]) List<String> tags,              // E.g. ['fundraiser', 'training']
    @Default([]) List<Map<String, dynamic>> activityLog, // Audit/history log
  }) = _Event;

  /// Create Event from JSON (for Firestore/REST/API)
  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);

  /// Factory for Event from Firestore document (with .id injected)
  factory Event.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) =>
      Event.fromJson({...doc.data() ?? {}, 'id': doc.id});
}

/// Firestore extension for serialization (never store 'id' in doc)
extension EventFirestoreX on Event {
  Map<String, dynamic> toFirestore() {
    final data = toJson();
    data.remove('id');
    return data;
  }
}
