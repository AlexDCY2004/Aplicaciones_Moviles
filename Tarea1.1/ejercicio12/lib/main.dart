import 'package:flutter/material.dart';

import 'view/home_page_view.dart';

void main() {
  runApp(const CambioApp());
}

class CambioApp extends StatelessWidget {
  const CambioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Maquina de Cambio',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8FCBFF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFEAF6FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF8FCBFF),
          foregroundColor: Color(0xFF0D2B45),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomePage(),
    );
  }
}
