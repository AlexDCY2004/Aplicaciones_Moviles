import 'package:flutter/material.dart';
import '../atoms/checkboxAtom.dart';
import '../../models/ajusteModel.dart';

class ResumenAjustesMolecule extends StatelessWidget {
  final List<Ajuste> ajustes;
  final Set<String> seleccionados;
  final ValueChanged<String> onToggle;

  const ResumenAjustesMolecule({Key? key, required this.ajustes, required this.seleccionados, required this.onToggle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String fmtNum(num v) {
      var s = v.toStringAsFixed(2);
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
      return s;
    }

    return Column(
      children: ajustes.map((a) {
        final activo = seleccionados.contains(a.id);
        final montoStr = a.esPorcentaje ? '${fmtNum(a.monto)}%' : fmtNum(a.monto);
        return CheckboxAtom(valor: activo, onChanged: (_) => onToggle(a.id), etiqueta: '${a.nombre} ($montoStr)');
      }).toList(),
    );
  }
}
