import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/event.dart';
import '../services/event_service.dart';

// Service provider for DI/testability
final eventServiceProvider = Provider<EventService>((ref) => EventService());

// One event by ID (family provider)
final eventProvider = FutureProvider.family<Event?, String>((ref, eventId) {
  final service = ref.read(eventServiceProvider);
  return service.getEventById(eventId);
});

// Stream of one event
final eventStreamProvider = StreamProvider.family<Event?, String>((ref, eventId) {
  final service = ref.read(eventServiceProvider);
  return service.streamEventById(eventId);
});

// Stream of all events
final allEventsStreamProvider = StreamProvider<List<Event>>((ref) {
  final service = ref.read(eventServiceProvider);
  return service.streamAllEvents();
});

// Stream of events filtered by status (e.g. 'upcoming')
final eventsByStatusProvider = StreamProvider.family<List<Event>, String>((ref, status) {
  final service = ref.read(eventServiceProvider);
  return service.streamAllEvents(status: status);
});
