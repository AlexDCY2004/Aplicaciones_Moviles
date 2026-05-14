import 'package:flutter/material.dart';
import '../atomos/campos_texto_personalizado.dart';

/// Molécula: Agrupa el listado iterativo de cuadros de texto de las horas
class GrupoHoras extends StatelessWidget {
  final List<TextEditingController> controladores;

  const GrupoHoras({super.key, required this.controladores});

  @override
  Widget build(BuildContext context) {
    final dias = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 100,
          child: CamposTextoPersonalizado(
            label: dias[index],
            hint: '0',
            controller: controladores[index],
          ),
        );
      }),
    );
  }
}
