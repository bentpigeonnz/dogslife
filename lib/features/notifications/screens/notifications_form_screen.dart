import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/notification_model.dart';
import '../providers/notifications_service_provider.dart';

// ---- Firestore Structure Example for Users ----
// Collection: users
// doc: <userId>
// fields:
//   - name: String
//   - email: String
//   - roles: List<String> (e.g., ["Admin", "Shelter Manager"])
//   - ...other fields

class NotificationFormScreen extends ConsumerStatefulWidget {
  final NotificationModel? initial;
  const NotificationFormScreen({super.key, this.initial});

  @override
  ConsumerState<NotificationFormScreen> createState() => _NotificationFormScreenState();
}

class _NotificationFormScreenState extends ConsumerState<NotificationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  DateTime? _scheduledAt;

  final List<String> _targetUserIds = [];
  String? _selectedRole;
  bool _sendAsSingleDoc = false; // Toggle for single/multi-recipient doc

  // Define your roles or fetch dynamically for prod
  final List<String> _roles = [
    'Admin',
    'Shelter Manager',
    'Adopter',
    'Volunteer',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initial?.title ?? '');
    _bodyController = TextEditingController(text: widget.initial?.body ?? '');
    _scheduledAt = widget.initial?.scheduledAt;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  /// 🟢 Fetch all user IDs for a given role from Firestore (best-practice)
  Future<List<String>> _fetchUserIdsForRole(String role) async {
    // Replace with your real Firestore user fetch logic!
    // Example with cloud_firestore:
    /*
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .where('roles', arrayContains: role)
        .get();
    return snap.docs.map((doc) => doc.id).toList();
    */
    // For demo, use placeholder:
    switch (role) {
      case 'Admin': return ['adminUserId1', 'adminUserId2'];
      case 'Shelter Manager': return ['managerUserId1', 'managerUserId2'];
      case 'Adopter': return ['adopterUserId1', 'adopterUserId2'];
      case 'Volunteer': return ['volunteerUserId1', 'volunteerUserId2'];
      default: return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = ref.read(notificationServiceProvider);

    return Scaffold(
      appBar: AppBar(title: Text(widget.initial == null ? 'Create Notification' : 'Edit Notification')),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Title required' : null,
              ),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(labelText: 'Body'),
                validator: (v) => v == null || v.isEmpty ? 'Body required' : null,
                maxLines: 3,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(_scheduledAt == null
                      ? 'Send now'
                      : 'Scheduled: ${_scheduledAt.toString()}'),
                  IconButton(
                    icon: const Icon(Icons.schedule),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _scheduledAt ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) setState(() => _scheduledAt = picked);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // User entry for direct send (comma-separated)
              Text('Send to specific users (comma-separated user IDs):'),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'userId1,userId2,...',
                ),
                onChanged: (value) {
                  _targetUserIds.clear();
                  if (value.trim().isNotEmpty) {
                    _targetUserIds.addAll(value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty));
                  }
                  setState(() {});
                },
              ),
              const SizedBox(height: 14),
              // Dropdown for role/group send
              DropdownButtonFormField<String>(
                value: _selectedRole,
                decoration: const InputDecoration(
                  labelText: 'Or send to role/group',
                ),
                items: _roles.map((role) =>
                    DropdownMenuItem(value: role, child: Text(role))
                ).toList(),
                onChanged: (value) => setState(() => _selectedRole = value),
              ),
              const SizedBox(height: 14),
              // Toggle: Send as single notification doc with multiple recipients
              SwitchListTile(
                title: const Text('Send as a single notification (multi-recipient)'),
                subtitle: const Text('If enabled, one notification will be created for all selected users/roles. If disabled, one notification per recipient.'),
                value: _sendAsSingleDoc,
                onChanged: (val) => setState(() => _sendAsSingleDoc = val),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  // Determine recipients: merge explicit users & role users
                  List<String> recipients = List.from(_targetUserIds);

                  if (_selectedRole != null && _selectedRole!.isNotEmpty) {
                    final roleUserIds = await _fetchUserIdsForRole(_selectedRole!);
                    recipients.addAll(roleUserIds.where((id) => !recipients.contains(id)));
                  }
                  // Remove any accidental dups
                  recipients = recipients.toSet().toList();

                  final now = DateTime.now();

                  if (_sendAsSingleDoc && recipients.isNotEmpty) {
                    // ----- MULTI-RECIPIENT NOTIFICATION DOC -----
                    final n = NotificationModel(
                      id: widget.initial?.id ?? '',
                      recipientIds: recipients, // <--- main point!
                      title: _titleController.text,
                      body: _bodyController.text,
                      createdAt: now,
                      scheduledAt: _scheduledAt,
                      // ...other fields as needed
                    );
                    if (widget.initial == null) {
                      await notificationService.createNotification(n);
                    } else {
                      await notificationService.updateNotification(n);
                    }
                  } else if (recipients.isNotEmpty) {
                    // ----- INDIVIDUAL NOTIFICATIONS -----
                    final notifications = recipients
                        .map((userId) => NotificationModel(
                      id: widget.initial?.id ?? '',
                      recipientIds: [userId], // or userId: userId,
                      title: _titleController.text,
                      body: _bodyController.text,
                      createdAt: now,
                      scheduledAt: _scheduledAt,
                      // ...other fields as needed
                    ))
                        .toList();
                    await notificationService.bulkSend(notifications);
                  } else if (widget.initial == null) {
                    // Single send to self/one-off/empty (fallback)
                    final n = NotificationModel(
                      id: widget.initial?.id ?? '',
                      recipientIds: [], // or userId: 'placeholder'
                      title: _titleController.text,
                      body: _bodyController.text,
                      createdAt: now,
                      scheduledAt: _scheduledAt,
                    );
                    await notificationService.createNotification(n);
                  } else {
                    // Edit mode
                    final n = widget.initial!.copyWith(
                      title: _titleController.text,
                      body: _bodyController.text,
                      scheduledAt: _scheduledAt,
                    );
                    await notificationService.updateNotification(n);
                  }

                  if (context.mounted) Navigator.of(context).pop();
                },
                child: Text(widget.initial == null ? 'Send' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
