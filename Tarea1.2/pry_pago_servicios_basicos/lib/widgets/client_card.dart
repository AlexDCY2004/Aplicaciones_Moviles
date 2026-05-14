import 'package:flutter/material.dart';

class ClientCard extends StatelessWidget {
  final String nombre;
  final String direccion;
  final String telefono;
  final String email;

  const ClientCard({
    super.key,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.email,
  });

  Widget _buildField(String label, String value, TextStyle labelStyle, TextStyle valueStyle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 2),
        Text(value, style: valueStyle),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context)
        .textTheme
        .labelSmall
        ?.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[700]) ??
      const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey);
    final valueStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16) ??
      const TextStyle(fontSize: 16);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('Nombre', nombre, labelStyle, valueStyle),
            const SizedBox(height: 8),
            _buildField('Dirección', direccion, labelStyle, valueStyle),
            const SizedBox(height: 8),
            _buildField('Teléfono', telefono, labelStyle, valueStyle),
            const SizedBox(height: 8),
            _buildField('Email', email, labelStyle, valueStyle),
          ],
        ),
      ),
    );
  }
}
