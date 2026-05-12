import 'package:flutter/material.dart';

class ProductDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const ProductDropdown({Key? key, required this.value, required this.onChanged, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Producto'),
      items: const [
        DropdownMenuItem(value: 'Café', child: Text('Café')),
        DropdownMenuItem(value: 'Capuchino', child: Text('Capuchino')),
        DropdownMenuItem(value: 'Chocolate', child: Text('Chocolate')),
      ],
      onChanged: onChanged,
      validator: validator,
    );
  }
}
