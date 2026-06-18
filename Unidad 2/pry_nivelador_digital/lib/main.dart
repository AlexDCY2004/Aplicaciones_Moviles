import 'package:flutter/material.dart';
import 'views/leveler_view.dart'; // Importación con el nombre original en inglés

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: 'Digital Leveler',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      // Apuntamos a la vista original en inglés: LevelerView
      home: const LevelerView(), 
    );
  }
}