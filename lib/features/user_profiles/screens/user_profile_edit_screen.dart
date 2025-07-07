import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:go_router/go_router.dart'; // <-- For context.pop()
import '../models/user_profile.dart';
import '../providers/user_profile_provider.dart';

class UserProfileEditScreen extends ConsumerStatefulWidget {
  const UserProfileEditScreen({super.key});

  @override
  ConsumerState<UserProfileEditScreen> createState() => _UserProfileEditScreenState();
}

class _UserProfileEditScreenState extends ConsumerState<UserProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _displayNameController;
  late TextEditingController _phoneController;
  late TextEditingController _bioController;
  late TextEditingController _addressController;
  late TextEditingController _emergencyNameController;
  late TextEditingController _emergencyPhoneController;
  late TextEditingController _emergencyRelationshipController;
  late TextEditingController _internalNotesController;
  String? _avatarUrl;
  Map<String, bool> _notificationPrefs = {};
  String? _themePref;
  String? _language;
  bool _saving = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyRelationshipController.dispose();
    _internalNotesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider).value;
    _displayNameController = TextEditingController(text: profile?.displayName ?? '');
    _phoneController = TextEditingController(text: profile?.phone ?? '');
    _bioController = TextEditingController(text: profile?.bio ?? '');
    _addressController = TextEditingController(text: profile?.address ?? '');
    _emergencyNameController = TextEditingController(text: profile?.emergencyContact?['name'] ?? '');
    _emergencyPhoneController = TextEditingController(text: profile?.emergencyContact?['phone'] ?? '');
    _emergencyRelationshipController = TextEditingController(text: profile?.emergencyContact?['relationship'] ?? '');
    _internalNotesController = TextEditingController(text: profile?.internalNotes ?? '');
    _avatarUrl = profile?.avatarUrl;
    _notificationPrefs = Map<String, bool>.from(profile?.notificationPrefs ?? {});
    _themePref = profile?.themePref ?? 'system';
    _language = profile?.language ?? 'en';
  }

  // --- Google Linking ---
  Future<void> _linkGoogle(UserProfile profile) async {
    setState(() => _saving = true);
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return;
      final googleAuth = await googleUser.authentication;
      final credential = fb_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final user = fb_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.linkWithCredential(credential);
        // Optionally update profile.socialLinks
        final updatedLinks = Map<String, String>.from(profile.socialLinks ?? {});
        updatedLinks['google'] = googleUser.email;
        await ref.read(userProfileProvider.notifier).saveProfile(profile.copyWith(socialLinks: updatedLinks));
      }
    } catch (e) {
      // Handle error, show snackbar etc.
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _unlinkGoogle(UserProfile profile) async {
    setState(() => _saving = true);
    try {
      final user = fb_auth.FirebaseAuth.instance.currentUser;
      await user?.unlink('google.com');
      final updatedLinks = Map<String, String>.from(profile.socialLinks ?? {});
      updatedLinks.remove('google');
      await ref.read(userProfileProvider.notifier).saveProfile(profile.copyWith(socialLinks: updatedLinks));
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _saving = false);
    }
  }

  // --- Facebook Linking ---
  Future<void> _linkFacebook(UserProfile profile) async {
    setState(() => _saving = true);
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) return;
      final accessToken = result.accessToken;
      final credential = fb_auth.FacebookAuthProvider.credential(accessToken!.token); // <-- this is correct
      final user = fb_auth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.linkWithCredential(credential);
        final updatedLinks = Map<String, String>.from(profile.socialLinks ?? {});
        updatedLinks['facebook'] = user.email ?? '';
        await ref.read(userProfileProvider.notifier).saveProfile(profile.copyWith(socialLinks: updatedLinks));
      }
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _saving = false);
    }
  }

  Future<void> _unlinkFacebook(UserProfile profile) async {
    setState(() => _saving = true);
    try {
      final user = fb_auth.FirebaseAuth.instance.currentUser;
      await user?.unlink('facebook.com');
      final updatedLinks = Map<String, String>.from(profile.socialLinks ?? {});
      updatedLinks.remove('facebook');
      await ref.read(userProfileProvider.notifier).saveProfile(profile.copyWith(socialLinks: updatedLinks));
    } catch (e) {
      // Handle error
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);
    final notifier = ref.read(userProfileProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (profile) {
          if (profile == null) return const Center(child: Text('No profile found.'));
          final isAdmin = profile.isAdmin;
          final isManager = profile.isManager;

          return Padding(
            padding: const EdgeInsets.all(18),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // TODO: Photo picker logic (CameraX/asset)
                      },
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: AssetImage(profile.avatarOrPlaceholder),
                        foregroundImage: (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                            ? NetworkImage(_avatarUrl!)
                            : null,
                        child: (_avatarUrl == null || _avatarUrl!.isEmpty)
                            ? const Icon(Icons.person, size: 48)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(labelText: 'Display Name'),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: (v) => (v != null && v.isNotEmpty && !RegExp(r'^(\+64|0)[2-9]\d{7,9}$').hasMatch(v))
                        ? 'Invalid NZ number'
                        : null,
                  ),
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(labelText: 'Bio/About'),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                    onTap: () async {
                      // TODO: Google Places autocomplete
                    },
                  ),
                  const Divider(),
                  // Preferences
                  SwitchListTile(
                    title: const Text('Adoption Notifications'),
                    value: _notificationPrefs['adoption'] ?? true,
                    onChanged: (v) => setState(() => _notificationPrefs['adoption'] = v),
                  ),
                  SwitchListTile(
                    title: const Text('Event Reminders'),
                    value: _notificationPrefs['event'] ?? true,
                    onChanged: (v) => setState(() => _notificationPrefs['event'] = v),
                  ),
                  SwitchListTile(
                    title: const Text('Marketing'),
                    value: _notificationPrefs['marketing'] ?? false,
                    onChanged: (v) => setState(() => _notificationPrefs['marketing'] = v),
                  ),
                  DropdownButtonFormField<String>(
                    value: _themePref,
                    items: const [
                      DropdownMenuItem(value: 'system', child: Text('System')),
                      DropdownMenuItem(value: 'light', child: Text('Light')),
                      DropdownMenuItem(value: 'dark', child: Text('Dark')),
                    ],
                    onChanged: (v) => setState(() => _themePref = v),
                    decoration: const InputDecoration(labelText: 'Theme'),
                  ),
                  DropdownButtonFormField<String>(
                    value: _language,
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      // Add more languages as needed
                    ],
                    onChanged: (v) => setState(() => _language = v),
                    decoration: const InputDecoration(labelText: 'Language'),
                  ),
                  const Divider(),
                  // Emergency contact (staff/volunteer only)
                  if (profile.isStaff || profile.isVolunteer || isAdmin || isManager) ...[
                    const Text('Emergency Contact', style: TextStyle(fontWeight: FontWeight.bold)),
                    TextFormField(
                      controller: _emergencyNameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextFormField(
                      controller: _emergencyPhoneController,
                      decoration: const InputDecoration(labelText: 'Phone'),
                    ),
                    TextFormField(
                      controller: _emergencyRelationshipController,
                      decoration: const InputDecoration(labelText: 'Relationship'),
                    ),
                  ],
                  // Admin/staff fields
                  if (isAdmin || isManager) ...[
                    const Divider(),
                    TextFormField(
                      controller: _internalNotesController,
                      decoration: const InputDecoration(labelText: 'Internal Notes (admin only)'),
                    ),
                  ],
                  const Divider(),
                  // Social Linking Section
                  const Text('Linked Social Accounts', style: TextStyle(fontWeight: FontWeight.bold)),
                  ListTile(
                    leading: const Icon(Icons.account_circle, color: Colors.blue),
                    title: const Text('Google'),
                    subtitle: Text(profile.socialLinks?['google'] != null ? 'Linked' : 'Not linked'),
                    trailing: _saving
                        ? const CircularProgressIndicator()
                        : profile.socialLinks?['google'] == null
                        ? TextButton(
                      child: const Text('Link'),
                      onPressed: () => _linkGoogle(profile),
                    )
                        : TextButton(
                      child: const Text('Unlink'),
                      onPressed: () => _unlinkGoogle(profile),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.facebook, color: Colors.blueAccent),
                    title: const Text('Facebook'),
                    subtitle: Text(profile.socialLinks?['facebook'] != null ? 'Linked' : 'Not linked'),
                    trailing: _saving
                        ? const CircularProgressIndicator()
                        : profile.socialLinks?['facebook'] == null
                        ? TextButton(
                      child: const Text('Link'),
                      onPressed: () => _linkFacebook(profile),
                    )
                        : TextButton(
                      child: const Text('Unlink'),
                      onPressed: () => _unlinkFacebook(profile),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text('Save Changes'),
                    onPressed: _saving
                        ? null
                        : () async {
                      if (!_formKey.currentState!.validate()) return;
                      final updated = profile.copyWith(
                        displayName: _displayNameController.text,
                        phone: _phoneController.text,
                        bio: _bioController.text,
                        address: _addressController.text,
                        avatarUrl: _avatarUrl,
                        notificationPrefs: _notificationPrefs,
                        themePref: _themePref ?? 'system',
                        language: _language ?? 'en',
                        emergencyContact: {
                          'name': _emergencyNameController.text,
                          'phone': _emergencyPhoneController.text,
                          'relationship': _emergencyRelationshipController.text,
                        },
                        internalNotes: (isAdmin || isManager)
                            ? _internalNotesController.text
                            : null,
                      );
                      await notifier.saveProfile(updated);
                      if (context.mounted) context.pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
