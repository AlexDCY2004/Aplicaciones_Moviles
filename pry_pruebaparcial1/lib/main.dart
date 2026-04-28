import 'package:flutter/material.dart';
import 'view/numeros_view.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ejercicio 17',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NumerosPage(),
    );
  }
}
