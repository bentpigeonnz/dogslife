import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dogs_life/core/providers/role_provider.dart';
import 'package:dogs_life/services/permission_service.dart';
import '../providers/dog_service_provider.dart';
import '../models/dog.dart';
import 'package:dogs_life/widgets/multi_photo_picker_field.dart'; // <-- Make sure this import is correct!

class DogFormScreen extends ConsumerStatefulWidget {
  final String? dogId;
  const DogFormScreen({super.key, this.dogId});

  @override
  ConsumerState<DogFormScreen> createState() => _DogFormScreenState();
}

class _DogFormScreenState extends ConsumerState<DogFormScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _error;

  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  int? _ageYears;
  int? _ageMonths;
  String _gender = 'unknown';
  final _descController = TextEditingController();
  List<String> _photoUrls = [];
  DateTime? _intakeDate; // <-- New

  @override
  void initState() {
    super.initState();
    if (widget.dogId != null) {
      _loadDog();
    } else {
      _intakeDate = DateTime.now();
    }
  }

  Future<void> _loadDog() async {
    setState(() => _loading = true);
    try {
      final dogService = ref.read(dogServiceProvider);
      final dog = await dogService.getDogById(widget.dogId!);
      if (dog != null) {
        _nameController.text = dog.name;
        _breedController.text = dog.breed ?? '';
        _ageYears = dog.ageYears;
        _ageMonths = dog.ageMonths;
        _gender = dog.gender.toString().split('.').last;
        _descController.text = dog.description ?? '';
        _photoUrls = List<String>.from(dog.photoUrls);
        _intakeDate = dog.intakeDate;
      }
    } catch (e) {
      _error = e.toString();
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _saveDog() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final dogService = ref.read(dogServiceProvider);
      final now = DateTime.now();
      final newDog = Dog(
        id: widget.dogId ?? '',
        name: _nameController.text.trim(),
        breed: _breedController.text.trim(),
        ageYears: _ageYears,
        ageMonths: _ageMonths,
        gender: DogGender.values.firstWhere(
              (g) => g.toString().split('.').last == _gender,
          orElse: () => DogGender.unknown,
        ),
        description: _descController.text.trim(),
        photoUrls: _photoUrls,
        intakeDate: _intakeDate ?? now, // <-- Always pass intakeDate!
      );

      if (widget.dogId == null) {
        await dogService.addDog(newDog);
      } else {
        await dogService.updateDog(newDog);
      }

      if (!mounted) return;
      context.go('/dogs');
    } catch (e) {
      setState(() => _error = e.toString());
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(roleProvider).value ?? 'guest';
    final canEdit = PermissionService.canManageDogs(role);

    if (!canEdit) {
      return Scaffold(
        appBar: AppBar(title: const Text('Dog Form')),
        body: const Center(child: Text('You do not have permission to add or edit dogs.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.dogId == null ? 'Add Dog' : 'Edit Dog')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_error != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  color: Colors.red[100],
                  child: Text(_error!, style: const TextStyle(color: Colors.red)),
                ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Dog name is required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _breedController,
                decoration: const InputDecoration(labelText: 'Breed'),
                validator: (v) => (v == null || v.isEmpty) ? 'Breed is required' : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: _ageYears?.toString(),
                      decoration: const InputDecoration(labelText: 'Age (Years)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _ageYears = int.tryParse(v),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      initialValue: _ageMonths?.toString(),
                      decoration: const InputDecoration(labelText: 'Age (Months)'),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => _ageMonths = int.tryParse(v),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _gender,
                items: ['male', 'female', 'unknown']
                    .map((g) => DropdownMenuItem(
                  value: g,
                  child: Text(g[0].toUpperCase() + g.substring(1)),
                ))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v ?? 'unknown'),
                decoration: const InputDecoration(labelText: 'Gender'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              MultiPhotoPickerField(
                initialUrls: _photoUrls,
                onChanged: canEdit ? (urls) => setState(() => _photoUrls = urls) : (_) {},
                id: widget.dogId ?? DateTime.now().millisecondsSinceEpoch.toString(),
                folder: "dogs",
                canEdit: canEdit,
                maxImages: 8,
                placeholderAsset: "assets/images/placeholder_dog.png",
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: canEdit ? _saveDog : null,
                child: Text(widget.dogId == null ? 'Add Dog' : 'Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
