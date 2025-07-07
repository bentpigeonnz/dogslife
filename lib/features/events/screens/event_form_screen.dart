import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/event.dart';
import '../providers/events_provider.dart';
import 'package:dogs_life/services/permission_service.dart';
import 'package:dogs_life/core/providers/role_provider.dart';

class EventFormScreen extends ConsumerStatefulWidget {
  final String? eventId;
  const EventFormScreen({super.key, this.eventId});

  @override
  ConsumerState<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends ConsumerState<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  DateTime? _date;
  List<String> _photoUrls = [];
  String _status = 'upcoming';

  @override
  void initState() {
    super.initState();
    if (widget.eventId != null) _loadEvent();
  }

  Future<void> _loadEvent() async {
    final service = ref.read(eventServiceProvider);
    final event = await service.getEventById(widget.eventId!);
    if (event != null) {
      _titleController.text = event.title;
      _descController.text = event.description ?? '';
      _locationController.text = event.location ?? '';
      _date = event.date;
      _photoUrls = List<String>.from(event.photoUrls);
      _status = event.status;
      setState(() {});
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;
    final service = ref.read(eventServiceProvider);
    final event = Event(
      id: widget.eventId ?? '',
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      date: _date ?? DateTime.now(),
      location: _locationController.text.trim(),
      photoUrls: _photoUrls,
      status: _status,
      // organizerId, attendees, and activityLog set elsewhere
    );
    if (widget.eventId == null) {
      await service.addEvent(event);
    } else {
      await service.updateEvent(event);
    }
    if (context.mounted) context.go('/events');
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider).value ?? 'guest';
    final canEdit = PermissionService.canManageEvents(role);

    if (!canEdit) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Form')),
        body: const Center(child: Text('You do not have permission to add or edit events.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.eventId == null ? 'Add Event' : 'Edit Event')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => (v == null || v.isEmpty) ? 'Event title required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
              ),
              const SizedBox(height: 10),
              // Date picker
              ListTile(
                title: Text(_date == null
                    ? 'Select Date'
                    : 'Date: ${_date!.toLocal()}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _date ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setState(() => _date = picked);
                },
              ),
              // TODO: Add MultiPhotoPickerField when ready
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                value: _status,
                items: ['upcoming', 'completed', 'archived']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _status = v ?? 'upcoming'),
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text(widget.eventId == null ? 'Add Event' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
