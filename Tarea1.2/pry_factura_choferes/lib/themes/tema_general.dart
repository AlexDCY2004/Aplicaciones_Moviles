import 'package:flutter/material.dart';
import 'esquema_color.dart';
import 'tema_botones.dart';
import 'tipografia.dart';
import 'tema_appbar.dart';
import 'tema_formularios.dart';

class TemaGeneral {
  static ThemeData claro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: ColoresApp.primario,
      secondary: ColoresApp.secundario,
      background: ColoresApp.fondo,
      onPrimary: ColoresApp.textoClaro,
      onSecondary: Colors.white
    ),
    textTheme: TipografiaApp.texto,
    appBarTheme: TemaAppBar.estilo,
    elevatedButtonTheme: TemaBotones.botonPrincipal,
    outlinedButtonTheme: TemaBotones.botonSecundario,
    inputDecorationTheme: TemaFormularios.camposTexto,
    scaffoldBackgroundColor: ColoresApp.fondo
  );
}