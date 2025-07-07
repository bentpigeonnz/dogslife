// lib/features/dogs/screens/dog_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dog_stream_provider.dart';
import 'package:dogs_life/core/providers/role_provider.dart';
import 'package:dogs_life/services/permission_service.dart';
import 'package:dogs_life/widgets/multi_photo_picker_field.dart';

// Your custom picker

class DogDetailScreen extends ConsumerWidget {
  final String dogId;
  const DogDetailScreen({super.key, required this.dogId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dogAsync = ref.watch(dogStreamProvider(dogId));
    final role = ref.watch(roleProvider).value ?? 'guest';
    final canEdit = PermissionService.canManageDogs(role);

    return Scaffold(
      appBar: AppBar(title: const Text('Dog Details')),
      body: dogAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (dog) {
          if (dog == null) return const Center(child: Text('Dog not found.'));
          return Padding(
            padding: const EdgeInsets.all(18),
            child: ListView(
              children: [
                MultiPhotoPickerField(
                  initialUrls: dog.photoUrls,
                  canEdit: canEdit,
                  onChanged: canEdit
                      ? (urls) {
                    // TODO: Call provider/service to update dog photo URLs
                  }
                      : (_) {},
                  id: dog.id,
                  folder: 'dogs',
                  maxImages: 8,
                  placeholderAsset: "assets/images/placeholder_dog.png",
                ),
                const SizedBox(height: 18),
                Text(dog.name, style: Theme.of(context).textTheme.headlineSmall),
                // ... the rest of the fields
                if (canEdit)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    onPressed: () => context.go('/dogs/${dog.id}/edit'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
