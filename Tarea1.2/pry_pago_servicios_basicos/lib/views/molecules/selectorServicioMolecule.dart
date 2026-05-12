import 'package:flutter/material.dart';
import '../atoms/etiquetaAtom.dart';

class SelectorServicioMolecule extends StatelessWidget {
  final List<String> servicios;
  final String? seleccionado;
  final ValueChanged<String?> onChanged;

  const SelectorServicioMolecule({Key? key, required this.servicios, this.seleccionado, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const EtiquetaAtom(texto: 'Tipo de servicio'),
      ...servicios.map((s) => ListTile(
            title: Text(s),
            leading: Radio<String>(value: s, groupValue: seleccionado, onChanged: onChanged),
          ))
    ]);
  }
}
