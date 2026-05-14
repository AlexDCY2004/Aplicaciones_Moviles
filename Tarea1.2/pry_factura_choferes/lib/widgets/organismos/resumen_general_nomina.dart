import 'package:flutter/material.dart';
import '../atomos/etiqueta_resultado.dart';

/// Organismo: Agrupa el consolidado y el cálculo macro de la vista
class ResumenGeneralNomina extends StatelessWidget {
  final double totalPagar;
  final String choferMasHoras;

  const ResumenGeneralNomina({
    super.key,
    required this.totalPagar,
    required this.choferMasHoras,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      margin: const EdgeInsets.only(top: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen General', 
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)
            ),
            const Divider(),
            EtiquetaResultado(
              titulo: 'Total General a Pagar',
              valor: '\$${totalPagar.toStringAsFixed(2)}',
            ),
            EtiquetaResultado(
              titulo: 'Chofer con más horas el lunes',
              valor: choferMasHoras,
            ),
          ],
        ),
      ),
    );
  }
}
