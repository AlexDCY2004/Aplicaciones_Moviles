import 'package:flutter/material.dart';

class SizeDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const SizeDropdown({Key? key, required this.value, required this.onChanged, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Tamaño'),
      items: const [
        DropdownMenuItem(value: 'Pequeño', child: Text('Pequeño')),
        DropdownMenuItem(value: 'Mediano', child: Text('Mediano')),
        DropdownMenuItem(value: 'Grande', child: Text('Grande')),
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}
