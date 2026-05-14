import 'package:flutter/material.dart';

import 'view/home_page_view.dart';

void main() {
  runApp(const PesoClubApp());
}

class PesoClubApp extends StatelessWidget {
  const PesoClubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Club de Peso',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7DB6FF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF1F6FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7DB6FF),
          foregroundColor: Color(0xFF0D2B45),
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const HomePage(),
    );
  }
}
