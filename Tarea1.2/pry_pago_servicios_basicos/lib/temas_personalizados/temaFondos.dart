import 'package:flutter/material.dart';
import 'esquemaColor.dart';

class FondoPersonal {
  static final BoxDecoration degradadoPrincipal = BoxDecoration(
    gradient: LinearGradient(
      colors: [ColoresPersonal.primario, ColoresPersonal.acento],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const BoxDecoration fondoBlanco = BoxDecoration(color: Colors.white);
  static BoxDecoration fondoLigero() => const BoxDecoration(color: Color(0xFFF8FAFC));
}
