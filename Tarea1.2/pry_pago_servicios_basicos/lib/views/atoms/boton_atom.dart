import 'package:flutter/material.dart';

class BotonAtom extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const BotonAtom({Key? key, required this.texto, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, child: Text(texto));
  }
}
