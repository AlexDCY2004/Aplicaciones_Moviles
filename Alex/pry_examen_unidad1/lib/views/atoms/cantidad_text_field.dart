import 'package:flutter/material.dart';

class CantidadTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CantidadTextField({Key? key, required this.controller, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Cantidad',
        border: OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
