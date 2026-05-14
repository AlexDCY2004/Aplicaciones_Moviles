import 'package:flutter/material.dart';

/// Átomo reutilizable: grupo de RadioButtons genérico.
class RadioButtonPersonalizado<T> extends StatelessWidget {
  final String titulo;
  final List<T> opciones;
  final T valorSeleccionado;
  final ValueChanged<T?> onChanged;
  final String Function(T) etiqueta;

  const RadioButtonPersonalizado({
    super.key,
    required this.titulo,
    required this.opciones,
    required this.valorSeleccionado,
    required this.onChanged,
    required this.etiqueta,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        ...opciones.map((opcion) => RadioListTile<T>(
              title: Text(etiqueta(opcion)),
              value: opcion,
              groupValue: valorSeleccionado,
              onChanged: onChanged,
              dense: true,
              contentPadding: EdgeInsets.zero,
            )),
      ],
    );
  }
}
