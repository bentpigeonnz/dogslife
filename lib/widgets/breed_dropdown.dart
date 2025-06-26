import 'package:flutter/material.dart';
import '../../services/firestore/firestore_breed_service.dart';

class BreedDropdown extends StatefulWidget {
  final String? selectedBreed;
  final Function(String) onChanged;

  const BreedDropdown({
    super.key,
    required this.selectedBreed,
    required this.onChanged,
  });

  @override
  State<BreedDropdown> createState() => _BreedDropdownState();
}

class _BreedDropdownState extends State<BreedDropdown> {
  final FirestoreBreedService _breedService = FirestoreBreedService();
  List<String> _breeds = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBreeds();
  }

  Future<void> _loadBreeds() async {
    final breeds = await _breedService.getBreeds();
    setState(() {
      _breeds = breeds;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const CircularProgressIndicator();
    }

    return DropdownButtonFormField<String>(
      value: widget.selectedBreed,
      decoration: const InputDecoration(
        labelText: 'Select Breed',
        border: OutlineInputBorder(),
      ),
      items: _breeds.map((breed) {
        return DropdownMenuItem<String>(
          value: breed,
          child: Text(breed),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          widget.onChanged(value);
        }
      },
    );
  }
}
