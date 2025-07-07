import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/events/services/event_service.dart';
import 'package:dogsLife/features/events/models/event.dart';

void main() {
  test('getEventById returns null for unknown', () async {
    final event = await EventService.getEventById('notfound');
    expect(event, isNull);
  });

  test('addEvent returns without error', () async {
    final event = Event(
      id: 'test',
      name: 'Test Event',
      description: 'A test event',
      dateTime: DateTime.now(),
      location: 'Test Location',
      photoUrls: [],
      status: 'active',
      rsvpList: [],
    );
    await EventService.addEvent(event);
  });
}
