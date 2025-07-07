// lib/features/merchandise/screens/merchandise_list_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/merchandise_provider.dart';
import '../../../core/providers/role_provider.dart';
import '../../../services/permission_service.dart';

class MerchandiseListScreen extends ConsumerWidget {
  const MerchandiseListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(allMerchItemsStreamProvider);
    final role = ref.watch(roleProvider).value ?? 'guest';
    final canManage = PermissionService.canManageMerchandise(role);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop Merchandise'),
        actions: [
          if (canManage)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Add Merchandise',
              onPressed: () => context.go('/merchandise/add'),
            ),
        ],
      ),
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('No merchandise available.'));
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, idx) {
              final item = items[idx];
              return ListTile(
                leading: item.imageUrls.isNotEmpty
                    ? Image.network(item.imageUrls.first, width: 56, height: 56, fit: BoxFit.cover)
                    : const Icon(Icons.shopping_bag, size: 36),
                title: Row(
                  children: [
                    Text(item.name),
                    if (!item.isActive)
                      const Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Chip(
                          label: Text('Inactive'),
                          backgroundColor: Colors.grey,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text('\$${item.price.toStringAsFixed(2)}'),
                    if (item.salePrice != null && item.salePrice! < item.price)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          '\$${item.salePrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    if (item.stock == 0)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Chip(
                          label: Text('Out of Stock'),
                          backgroundColor: Colors.redAccent,
                          labelStyle: TextStyle(color: Colors.white),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/merchandise/${item.id}'),
              );
            },
          );
        },
      ),
      floatingActionButton: canManage
          ? FloatingActionButton(
        onPressed: () => context.go('/merchandise/add'),
        tooltip: 'Add New Merchandise',
        child: const Icon(Icons.add),
      )
          : null,
    );
  }
}
