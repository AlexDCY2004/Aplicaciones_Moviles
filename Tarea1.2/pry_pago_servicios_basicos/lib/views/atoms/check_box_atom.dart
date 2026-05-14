import 'package:flutter/material.dart';

class CheckboxAtom extends StatelessWidget {
  final bool valor;
  final ValueChanged<bool?> onChanged;
  final String etiqueta;

  const CheckboxAtom({Key? key, required this.valor, required this.onChanged, this.etiqueta = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: valor, onChanged: onChanged),
        if (etiqueta.isNotEmpty) Text(etiqueta),
      ],
    );
  }
}
