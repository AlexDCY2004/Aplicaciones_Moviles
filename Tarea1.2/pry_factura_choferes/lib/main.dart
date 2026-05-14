import 'package:flutter/material.dart';
import 'views/vista_nomina.dart';
import 'views/vista_reporte.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Factura Choferes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/nomina',
      routes: {
        '/nomina': (context) => const VistaNomina(),
        // Usamos pushNamed para ir al reporte como pide la rubrica
        '/reporte': (context) => const VistaReporte(),
      },
    );
  }
}
