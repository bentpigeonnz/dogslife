import 'package:flutter/material.dart';
import '../../../services/firestore/firestore_breed_service.dart';
import '../../../services/firestore/firestore_vaccine_service.dart';

/// Admin Management Screen for managing Breeds and Vaccines.
class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  final FirestoreBreedService _breedService = FirestoreBreedService();
  final FirestoreVaccineService _vaccineService = FirestoreVaccineService();

  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _manufacturerController = TextEditingController();
  final TextEditingController _vaccineNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<String> _breeds = [];
  List<Map<String, String>> _vaccines = [];

  @override
  void initState() {
    super.initState();
    _loadBreeds();
    _loadVaccines();
  }

  Future<void> _loadBreeds() async {
    final breeds = await _breedService.getBreeds();
    setState(() {
      _breeds = breeds;
    });
  }

  Future<void> _loadVaccines() async {
    final vaccines = await _vaccineService.getVaccines();
    setState(() {
      _vaccines = vaccines;
    });
  }

  Future<void> _addBreed() async {
    final breed = _breedController.text.trim();
    if (breed.isEmpty) return;

    await _breedService.addBreed(breed);
    _breedController.clear();
    _loadBreeds();
  }

  Future<void> _deleteBreed(String docId) async {
    await _breedService.deleteBreed(docId);
    _loadBreeds();
  }

  Future<void> _addVaccine() async {
    final productName = _productNameController.text.trim();
    final manufacturer = _manufacturerController.text.trim();
    final name = _vaccineNameController.text.trim();
    final description = _descriptionController.text.trim();

    if (productName.isEmpty || manufacturer.isEmpty || name.isEmpty) return;

    await _vaccineService.addVaccine(
      productName: productName,
      manufacturer: manufacturer,
      name: name,
      description: description,
    );

    _productNameController.clear();
    _manufacturerController.clear();
    _vaccineNameController.clear();
    _descriptionController.clear();
    _loadVaccines();
  }

  Future<void> _deleteVaccine(String docId) async {
    await _vaccineService.deleteVaccine(docId);
    _loadVaccines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Management')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Breeds', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _breedController,
                    decoration: const InputDecoration(labelText: 'New Breed'),
                  ),
                ),
                IconButton(onPressed: _addBreed, icon: const Icon(Icons.add)),
              ],
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _breeds.length,
              itemBuilder: (context, index) {
                final breed = _breeds[index];
                return ListTile(
                  title: Text(breed),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteBreed(breed),
                  ),
                );
              },
            ),
            const Divider(height: 32),
            const Text('Vaccines', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: _productNameController, decoration: const InputDecoration(labelText: 'Product Name')),
            TextField(controller: _manufacturerController, decoration: const InputDecoration(labelText: 'Manufacturer')),
            TextField(controller: _vaccineNameController, decoration: const InputDecoration(labelText: 'Vaccine Name')),
            TextField(controller: _descriptionController, decoration: const InputDecoration(labelText: 'Description')),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: _addVaccine, child: const Text('Add Vaccine')),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _vaccines.length,
              itemBuilder: (context, index) {
                final vaccine = _vaccines[index];
                return ListTile(
                  title: Text('${vaccine['productName']} - ${vaccine['name']}'),
                  subtitle: Text('${vaccine['manufacturer']} - ${vaccine['description']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteVaccine(vaccine['docId'] ?? ''),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
