import 'package:flutter/material.dart';
import 'esquema_color.dart';

class FondoApp{
  static const BoxDecoration degradadPrincipal= BoxDecoration(
    gradient: LinearGradient(
        colors: [ColoresApp.secundario, ColoresApp.acento],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
    ),
  );

  static const BoxDecoration fondoBlanco = BoxDecoration(
    color: Colors.white,
  );

  static const BoxDecoration fondoGris = BoxDecoration(
    color: ColoresApp.fondo,
  );
}