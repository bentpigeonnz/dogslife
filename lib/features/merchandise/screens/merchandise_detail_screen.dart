// lib/features/merchandise/screens/merchandise_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/merchandise_provider.dart';
import '../../../core/providers/role_provider.dart';
import '../../../services/permission_service.dart';

class MerchandiseDetailScreen extends ConsumerWidget {
  final String merchId;
  const MerchandiseDetailScreen({super.key, required this.merchId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final merchAsync = ref.watch(merchItemProvider(merchId));
    final role = ref.watch(roleProvider).value ?? 'guest';
    final canManage = PermissionService.canManageMerchandise(role);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          if (canManage && merchAsync.value != null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => context.go('/merchandise/$merchId/edit'),
            ),
        ],
      ),
      body: merchAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (item) {
          if (item == null) return const Center(child: Text('Not found.'));
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (item.imageUrls.isNotEmpty)
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: item.imageUrls.length,
                    itemBuilder: (_, idx) => Image.network(item.imageUrls[idx], fit: BoxFit.contain),
                  ),
                )
              else
                Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Icon(Icons.shopping_bag, size: 100),
                ),
              const SizedBox(height: 18),
              Text(item.name, style: Theme.of(context).textTheme.headlineSmall),
              if (!item.isActive)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Chip(
                    label: Text('Inactive'),
                    backgroundColor: Colors.grey,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 22)),
                  if (item.salePrice != null && item.salePrice! < item.price)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        '\$${item.salePrice!.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 22),
                      ),
                    ),
                  if (item.stock == 0)
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Chip(
                        label: Text('Out of Stock'),
                        backgroundColor: Colors.redAccent,
                        labelStyle: TextStyle(color: Colors.white),
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (item.category.isNotEmpty)
                Text('Category: ${item.category}', style: const TextStyle(color: Colors.grey)),
              if (item.description != null && item.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(item.description!),
                ),
              const Divider(height: 36),
              if (item.variants.isNotEmpty) ...[
                const Text('Available Variants:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...item.variants.map((v) => ListTile(
                  title: Text(v.name),
                  subtitle: Text('\$${v.price} | Stock: ${v.stock}'),
                  trailing: v.isActive ? null : const Icon(Icons.cancel, color: Colors.grey),
                )),
                const Divider(height: 36),
              ],
              Text('In Stock: ${item.stock}', style: const TextStyle(fontWeight: FontWeight.bold)),
              if (canManage)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Delete Merchandise?'),
                            content: const Text('This cannot be undone.'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          final service = ref.read(merchServiceProvider);
                          await service.deleteItem(item.id, actor: role);
                          if (context.mounted) context.go('/merchandise');
                        }
                      },
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      onPressed: () => context.go('/merchandise/${item.id}/edit'),
                    ),
                  ],
                ),
              if (!canManage)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Add to Cart'),
                    onPressed: item.stock > 0 ? () {/* TODO: Integrate cart logic */} : null,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
