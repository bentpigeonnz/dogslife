import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/events_provider.dart';
import 'package:dogs_life/core/providers/role_provider.dart';
import 'package:dogs_life/services/permission_service.dart';

class EventListScreen extends ConsumerWidget {
  const EventListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(allEventsStreamProvider);
    final role = ref.watch(roleProvider).value ?? 'guest';
    final canAdd = PermissionService.canManageEvents(role);

    return Scaffold(
      appBar: AppBar(title: const Text('Events')),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (events) {
          if (events.isEmpty) return const Center(child: Text('No events.'));
          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, idx) {
              final event = events[idx];
              return ListTile(
                leading: event.photoUrls.isNotEmpty
                    ? Image.network(event.photoUrls.first, width: 50, height: 50, fit: BoxFit.cover)
                    : const Icon(Icons.event, size: 40),
                title: Text(event.title),
                subtitle: Text('${event.location ?? ''}\n${event.date.toLocal()}'),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/events/${event.id}'),
              );
            },
          );
        },
      ),
      floatingActionButton: canAdd
          ? FloatingActionButton(
        onPressed: () => context.go('/events/add'),
        tooltip: 'Add Event',
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
