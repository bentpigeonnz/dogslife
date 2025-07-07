import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dog_provider.dart'; // Use the unified dog providers
import 'package:dogs_life/core/providers/role_provider.dart';
import 'package:dogs_life/services/permission_service.dart';

class DogListScreen extends ConsumerWidget {
  const DogListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to all dogs as a stream (Riverpod provider)
    final dogsAsync = ref.watch(allDogsStreamProvider);
    final role = ref.watch(roleProvider).value ?? 'guest';
    final canAddDog = PermissionService.canAddDog(role);

    return Scaffold(
      appBar: AppBar(title: const Text('Available Dogs')),
      body: dogsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (dogs) {
          if (dogs.isEmpty) return const Center(child: Text('No dogs available.'));
          return ListView.builder(
            itemCount: dogs.length,
            itemBuilder: (context, idx) {
              final dog = dogs[idx];
              return ListTile(
                leading: dog.photoUrls.isNotEmpty
                    ? Image.network(dog.photoUrls.first, width: 56, height: 56, fit: BoxFit.cover)
                    : const Icon(Icons.pets, size: 40),
                title: Text(dog.name),
                subtitle: Text(dog.breed ?? 'Unknown breed'), // <-- fix: handles null
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/dogs/${dog.id}'), // GoRouter navigation
              );
            },
          );
        },
      ),
      floatingActionButton: canAddDog
          ? FloatingActionButton(
        onPressed: () => context.go('/dogs/add'),
        tooltip: 'Add Dog',
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
