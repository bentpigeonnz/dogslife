import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dogsLife/features/events/providers/event_provider.dart';
import 'package:dogsLife/features/events/models/event.dart';

class FakeEventService {
  static Event fakeEvent = Event(
    id: 'e1',
    name: 'Open Day',
    description: 'Test event',
    dateTime: DateTime(2024, 8, 10, 14, 0),
    location: 'HQ',
    photoUrls: ['url'],
    status: 'active',
    rsvpList: [],
  );
  static Future<Event?> getEventById(String id) async => fakeEvent;
}

void main() {
  test('eventProvider returns fake event', () async {
    final container = ProviderContainer(overrides: [
      eventProvider.overrideWithProvider((id) => AsyncValue.data(FakeEventService.fakeEvent)),
    ]);
    final event = await container.read(eventProvider('e1').future);
    expect(event?.name, 'Open Day');
  });

  test('allEventsStreamProvider returns list with fake event', () async {
    final container = ProviderContainer(overrides: [
      allEventsStreamProvider.overrideWith((ref) => Stream.value([FakeEventService.fakeEvent])),
    ]);
    final list = await container.read(allEventsStreamProvider.future);
    expect(list.first.id, 'e1');
  });
}
