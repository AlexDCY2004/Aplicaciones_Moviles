import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CajaTextoAtom extends StatelessWidget {
  final TextEditingController controlador;
  final String placeholder;
  final TextInputType teclado;
  final bool soloNumeros;
  final List<TextInputFormatter>? inputFormatters;

  const CajaTextoAtom({Key? key, required this.controlador, this.placeholder = '', this.teclado = TextInputType.text, this.soloNumeros = false, this.inputFormatters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TextInputFormatter> formatters = [];
    if (soloNumeros) {
      // Allow digits and decimal point only
      formatters.add(FilteringTextInputFormatter.allow(RegExp(r'[0-9\.]')));
    }
    if (inputFormatters != null) formatters.addAll(inputFormatters!);

    return TextField(
      controller: controlador,
      keyboardType: teclado,
      inputFormatters: formatters.isNotEmpty ? formatters : null,
      decoration: InputDecoration(border: const OutlineInputBorder(), hintText: placeholder),
    );
  }
}
