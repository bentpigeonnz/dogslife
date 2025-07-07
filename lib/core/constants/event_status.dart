enum EventStatus { scheduled, ongoing, completed, canceled }

const Map<EventStatus, String> kEventStatusLabels = {
  EventStatus.scheduled: 'Scheduled',
  EventStatus.ongoing: 'Ongoing',
  EventStatus.completed: 'Completed',
  EventStatus.canceled: 'Canceled',
};
