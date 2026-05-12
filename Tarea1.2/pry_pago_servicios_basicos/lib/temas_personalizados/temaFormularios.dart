import 'package:flutter/material.dart';
import 'esquemaColor.dart';

class TemaFormulariosPersonal {
  static final InputDecorationTheme campos = InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    labelStyle: TextStyle(color: ColoresPersonal.primario.withOpacity(0.9)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: ColoresPersonal.primario.withOpacity(0.3), width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: ColoresPersonal.acento, width: 2),
    ),
  );
}
