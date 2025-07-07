import 'package:flutter_test/flutter_test.dart';
import 'package:dogsLife/features/events/models/event.dart';

void main() {
  test('Event serializes/deserializes', () {
    final event = Event(
      id: 'e1',
      name: 'Open Day',
      description: 'Shelter Open House',
      dateTime: DateTime(2024, 8, 10, 12, 0),
      location: 'Shelter HQ',
      photoUrls: ['url'],
      status: 'active',
      rsvpList: [],
    );
    final json = event.toJson();
    final event2 = Event.fromJson(json);
    expect(event2.name, 'Open Day');
  });
}
