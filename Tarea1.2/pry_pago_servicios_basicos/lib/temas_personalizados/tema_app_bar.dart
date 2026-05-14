import 'package:flutter/material.dart';
import 'esquema_Color.dart';

class TemaAppbarPersonal {
  static final AppBarTheme estilo = AppBarTheme(
    backgroundColor: ColoresPersonal.primario,
    foregroundColor: ColoresPersonal.textoClaro,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
    iconTheme: const IconThemeData(color: Colors.white),
  );
}
