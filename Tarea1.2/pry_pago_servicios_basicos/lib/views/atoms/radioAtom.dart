import 'package:flutter/material.dart';

class RadioAtom<T> extends StatelessWidget {
  final T valor;
  final T grupoValor;
  final ValueChanged<T?> onChanged;
  final String etiqueta;

  const RadioAtom({Key? key, required this.valor, required this.grupoValor, required this.onChanged, this.etiqueta = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [Radio<T>(value: valor, groupValue: grupoValor, onChanged: onChanged), Text(etiqueta)]);
  }
}
