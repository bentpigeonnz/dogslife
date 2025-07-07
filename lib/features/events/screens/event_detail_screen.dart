import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/events_provider.dart';
import 'package:dogs_life/core/providers/role_provider.dart';
import 'package:dogs_life/services/permission_service.dart';

class EventDetailScreen extends ConsumerWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventProvider(eventId));
    final role = ref.watch(roleProvider).value ?? 'guest';
    final userId = ''; // TODO: Get from userProvider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: PermissionService.canManageEvents(role)
                ? () => context.go('/events/$eventId/edit')
                : null,
          ),
        ],
      ),
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (event) {
          if (event == null) return const Center(child: Text('Event not found'));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (event.photoUrls.isNotEmpty)
                SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: event.photoUrls.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (ctx, i) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(event.photoUrls[i], width: 180, height: 180, fit: BoxFit.cover),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
              Text(event.date.toLocal().toString(), style: TextStyle(color: Colors.grey[700])),
              const SizedBox(height: 8),
              Text(event.description ?? ''),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Location: ${event.location ?? "TBA"}'),
                  Chip(label: Text(event.status)),
                ],
              ),
              const Divider(height: 24),
              Text('Attendees (${event.attendees.length}):'),
              Wrap(
                spacing: 6,
                children: event.attendees.map((id) => Chip(label: Text(id))).toList(),
              ),
              const Divider(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.event_available),
                label: const Text('RSVP'),
                onPressed: userId.isEmpty ? null : () {
                  // TODO: ref.read(eventServiceProvider).rsvpEvent(eventId, userId)
                },
              ),
              if (PermissionService.canManageEvents(role))
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    // TODO: Delete event
                  },
                ),
              const Divider(height: 24),
              Text('Activity Log:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...event.activityLog.map((log) => Text(
                '[${log['timestamp']}] ${log['action']} by ${log['actor']}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              )),
            ],
          );
        },
      ),
    );
  }
}
