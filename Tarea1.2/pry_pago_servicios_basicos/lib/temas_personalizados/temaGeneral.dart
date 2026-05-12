import 'package:flutter/material.dart';
import 'esquemaColor.dart';
import 'tipografia.dart';
import 'temaAppbar.dart';
import 'temaBotones.dart';
import 'temaFormularios.dart';

class TemaPersonal {
  static final ThemeData claro = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: ColoresPersonal.primario,
      secondary: ColoresPersonal.secundario,
      background: ColoresPersonal.fondo,
      error: ColoresPersonal.error,
      onPrimary: ColoresPersonal.textoClaro,
      onSecondary: ColoresPersonal.textoOscuro,
      onBackground: ColoresPersonal.textoOscuro,
      onError: ColoresPersonal.textoClaro,
    ),
    textTheme: TipografiaPersonal.texto,
    appBarTheme: TemaAppbarPersonal.estilo,
    elevatedButtonTheme: TemaBotonesPersonal.botonPrincipal,
    outlinedButtonTheme: TemaBotonesPersonal.botonSecundario,
    inputDecorationTheme: TemaFormulariosPersonal.campos,
    scaffoldBackgroundColor: ColoresPersonal.fondo,
  );

  // Optional: dark theme variant
  static final ThemeData oscuro = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: ColoresPersonal.primario,
      secondary: ColoresPersonal.acento,
      background: const Color(0xFF0B1020),
      error: ColoresPersonal.error,
      onPrimary: ColoresPersonal.textoClaro,
      onSecondary: ColoresPersonal.textoClaro,
    ),
    textTheme: TipografiaPersonal.texto,
    appBarTheme: TemaAppbarPersonal.estilo.copyWith(backgroundColor: ColoresPersonal.primario),
    elevatedButtonTheme: TemaBotonesPersonal.botonPrincipal,
    outlinedButtonTheme: TemaBotonesPersonal.botonSecundario,
  );
}
