import 'package:flutter/material.dart';

class AddressAutocompleteField extends StatelessWidget {
  final TextEditingController controller;
  final String label;

  const AddressAutocompleteField({
    super.key,
    required this.controller,
    this.label = 'Address',
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.location_on),
      ),
      onTap: () {
        // Google Places autocomplete temporarily disabled
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Address autocomplete is temporarily disabled.'),
          ),
        );
      },
    );
  }
}
