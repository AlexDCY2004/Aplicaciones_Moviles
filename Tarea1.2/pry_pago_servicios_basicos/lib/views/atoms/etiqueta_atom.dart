import 'package:flutter/material.dart';

class EtiquetaAtom extends StatelessWidget {
  final String texto;
  final TextStyle? estilo;

  const EtiquetaAtom({Key? key, required this.texto, this.estilo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(texto, style: estilo ?? const TextStyle(fontSize: 16));
  }
}
