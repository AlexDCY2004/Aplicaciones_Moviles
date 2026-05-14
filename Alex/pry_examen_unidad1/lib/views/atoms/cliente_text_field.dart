import 'package:flutter/material.dart';

class ClienteTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const ClienteTextField({Key? key, required this.controller, this.validator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'Nombre del cliente',
        border: OutlineInputBorder(),
      ),
      // Validación delegada desde `PedidoForm` vía `CafeController`
      validator: validator,
    );
  }
}
