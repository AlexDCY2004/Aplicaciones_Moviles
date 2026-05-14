import 'package:flutter/material.dart';
import '../../themes/tema_botones.dart';

/// Enum para definir las variantes de estilo del botón según el diseño del sistema.
enum TipoBoton { primario, secundario }

class BotonPersonalizado extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final TipoBoton tipo;

  const BotonPersonalizado({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.tipo = TipoBoton.primario,
  });

  @override
  Widget build(BuildContext context) {
    // Se selecciona el estilo del tema centralizado en TemaBotones
    final style = tipo == TipoBoton.primario
        ? TemaBotones.botonPrincipal.style
        : TemaBotones.botonSecundario.style;

    return SizedBox(
      width: double.infinity,
      child: tipo == TipoBoton.primario
          ? ElevatedButton(
              style: style,
              onPressed: isLoading ? null : onPressed,
              child: _buildChild(),
            )
          : OutlinedButton(
              style: style,
              onPressed: isLoading ? null : onPressed,
              child: _buildChild(),
            ),
    );
  }

  Widget _buildChild() {
    return isLoading
        ? const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Text(text);
  }
}
