import 'package:flutter/material.dart';
import 'esquemaColor.dart';

class TemaBotonesPersonal {
  static final ElevatedButtonThemeData botonPrincipal = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: ColoresPersonal.acento,
      foregroundColor: ColoresPersonal.textoOscuro,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  static final OutlinedButtonThemeData botonSecundario = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: ColoresPersonal.textoOscuro,
      backgroundColor: ColoresPersonal.acento,
      side: BorderSide(color: ColoresPersonal.acento, width: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );
}
