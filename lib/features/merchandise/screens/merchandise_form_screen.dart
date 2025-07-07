// lib/features/merchandise/screens/merchandise_form_screen.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/merchandise_item.dart';
import '../providers/merchandise_provider.dart';
import '../../../core/providers/role_provider.dart';
import '../../../services/permission_service.dart';

// Plug in your actual MultiPhotoPicker widget import here
// import '../../../widgets/multi_photo_picker_field.dart';

class MerchandiseFormScreen extends ConsumerStatefulWidget {
  final String? merchId;
  const MerchandiseFormScreen({super.key, this.merchId});

  @override
  ConsumerState<MerchandiseFormScreen> createState() => _MerchandiseFormScreenState();
}

class _MerchandiseFormScreenState extends ConsumerState<MerchandiseFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _stockController = TextEditingController();
  final _saleEndsAtController = TextEditingController();

  List<String> _imageUrls = [];
  List<MerchVariant> _variants = [];
  bool _isActive = true;

  MerchItem? _editing;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.merchId != null) _loadMerch();
  }

  Future<void> _loadMerch() async {
    setState(() => _loading = true);
    final service = ref.read(merchServiceProvider);
    final item = await service.getItemById(widget.merchId!);
    if (item != null) {
      _editing = item;
      _nameController.text = item.name;
      _descController.text = item.description ?? '';
      _categoryController.text = item.category;
      _priceController.text = item.price.toString();
      _salePriceController.text = item.salePrice?.toString() ?? '';
      _saleEndsAtController.text = item.saleEndsAt?.toIso8601String() ?? '';
      _stockController.text = item.stock.toString();
      _imageUrls = List<String>.from(item.imageUrls);
      _variants = List<MerchVariant>.from(item.variants);
      _isActive = item.isActive;
    }
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final role = ref.read(roleProvider).value ?? 'guest';
      final canManage = PermissionService.canManageMerchandise(role);
      if (!canManage) {
        setState(() => _error = 'No permission to create or edit merchandise.');
        return;
      }

      final item = MerchItem(
        id: widget.merchId ?? '',
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        price: double.parse(_priceController.text),
        salePrice: _salePriceController.text.isNotEmpty
            ? double.tryParse(_salePriceController.text)
            : null,
        saleEndsAt: _saleEndsAtController.text.isNotEmpty
            ? DateTime.tryParse(_saleEndsAtController.text)
            : null,
        imageUrls: _imageUrls,
        isActive: _isActive,
        category: _categoryController.text.trim(),
        stock: int.tryParse(_stockController.text) ?? 0,
        variants: _variants,
        createdAt: _editing?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final service = ref.read(merchServiceProvider);
      if (widget.merchId == null) {
        await service.addItem(item, actor: role);
      } else {
        await service.updateItem(item, actor: role);
      }
      if (context.mounted) context.go('/merchandise');
    } catch (e) {
      setState(() => _error = e.toString());
    }
    setState(() => _loading = false);
  }

  void _addOrEditVariant({MerchVariant? variant}) async {
    final isEdit = variant != null;
    final nameCtrl = TextEditingController(text: variant?.name ?? '');
    final priceCtrl = TextEditingController(
      text: variant?.price.toString() ?? _priceController.text,
    );
    final stockCtrl = TextEditingController(
      text: variant?.stock.toString() ?? '',
    );
    final imgCtrl = TextEditingController(text: variant?.imageUrl ?? '');

    final result = await showDialog<MerchVariant>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(isEdit ? 'Edit Variant' : 'Add Variant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name (e.g. XL / Blue)')),
            TextFormField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            TextFormField(controller: stockCtrl, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
            TextFormField(controller: imgCtrl, decoration: const InputDecoration(labelText: 'Image URL'), keyboardType: TextInputType.url),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, MerchVariant(
                id: variant?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                name: nameCtrl.text.trim(),
                price: double.tryParse(priceCtrl.text) ?? 0,
                stock: int.tryParse(stockCtrl.text) ?? 0,
                imageUrl: imgCtrl.text.trim().isNotEmpty ? imgCtrl.text.trim() : null,
                isActive: true,
              ));
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        if (isEdit) {
          final idx = _variants.indexWhere((v) => v.id == variant.id);
          if (idx != -1) _variants[idx] = result;
        } else {
          _variants.add(result);
        }
      });
    }
  }

  Widget _buildVariantsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Variants', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add'),
              onPressed: () => _addOrEditVariant(),
            ),
          ],
        ),
        ..._variants.map((v) => ListTile(
          title: Text(v.name),
          subtitle: Text('\$${v.price} | Stock: ${v.stock}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () => _addOrEditVariant(variant: v)),
              IconButton(icon: const Icon(Icons.delete), onPressed: () => setState(() => _variants.remove(v))),
            ],
          ),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider).value ?? 'guest';
    final canManage = PermissionService.canManageMerchandise(role);

    if (!canManage) {
      return Scaffold(
        appBar: AppBar(title: const Text('Merchandise Form')),
        body: const Center(child: Text('You do not have permission to manage merchandise.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.merchId == null ? 'Add Merchandise' : 'Edit Merchandise')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  color: Colors.red[100],
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              SwitchListTile(
                title: const Text('Active/Available'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Name required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Category (optional)'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(labelText: 'Price (NZD)'),
                      keyboardType: TextInputType.number,
                      validator: (v) => (v == null || double.tryParse(v) == null) ? 'Enter a valid price' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _salePriceController,
                      decoration: const InputDecoration(labelText: 'Sale Price (if any)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(labelText: 'Stock'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _saleEndsAtController,
                      decoration: const InputDecoration(labelText: 'Sale Ends At (yyyy-mm-dd)'),
                      keyboardType: TextInputType.datetime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // ---- Images picker placeholder ----
              // TODO: Integrate MultiPhotoPickerField here for real images!
              Container(
                height: 120,
                color: Colors.grey[200],
                child: const Center(child: Text('Image Picker goes here')),
              ),
              const SizedBox(height: 18),
              _buildVariantsSection(),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(widget.merchId == null ? 'Add Merchandise' : 'Save Changes'),
                onPressed: _save,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
