import 'package:flutter/material.dart';
import '../../models/chofer_model.dart';
import '../atomos/etiqueta_resultado.dart';

/// Molécula: Agrupa datos puntuales de un Chofer
class TarjetaChofer extends StatelessWidget {
  final ChoferModel chofer;

  const TarjetaChofer({super.key, required this.chofer});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(chofer.nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            EtiquetaResultado(titulo: 'Horas Semanales:', valor: '${chofer.totalHoras} hrs'),
            EtiquetaResultado(titulo: 'Sueldo Semanal:', valor: '\$${chofer.sueldoSemanal.toStringAsFixed(2)}'),
            EtiquetaResultado(titulo: 'Jornada:', valor: chofer.tipoJornada),
            EtiquetaResultado(titulo: 'Bono:', valor: chofer.recibeBono ? 'Sí' : 'No'),
          ],
        ),
      ),
    );
  }
}
