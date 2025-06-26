import 'package:flutter/material.dart';
import '../../services/firestore/firestore_vaccine_service.dart';

class VaccineDropdown extends StatefulWidget {
  final Map<String, String>? selectedVaccine;
  final Function(Map<String, String>) onChanged;

  const VaccineDropdown({
    super.key,
    required this.selectedVaccine,
    required this.onChanged,
  });

  @override
  State<VaccineDropdown> createState() => _VaccineDropdownState();
}

class _VaccineDropdownState extends State<VaccineDropdown> {
  final FirestoreVaccineService _vaccineService = FirestoreVaccineService();
  List<Map<String, String>> _vaccines = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVaccines();
  }

  Future<void> _loadVaccines() async {
    final vaccines = await _vaccineService.getVaccines();
    setState(() {
      _vaccines = vaccines;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const CircularProgressIndicator();
    }

    return DropdownButtonFormField<Map<String, String>>(
      value: widget.selectedVaccine,
      decoration: const InputDecoration(
        labelText: 'Select Vaccine',
        border: OutlineInputBorder(),
      ),
      items: _vaccines.map((vaccine) {
        final display = "${vaccine['productName']} - ${vaccine['manufacturer']} - ${vaccine['name']}";
        return DropdownMenuItem<Map<String, String>>(
          value: vaccine,
          child: Text(display),
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
