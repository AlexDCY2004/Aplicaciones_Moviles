import 'package:flutter/material.dart';
import 'views/pages/vista_cafe.dart';
import 'views/pages/vista_nota_venta_cafe.dart';
import 'themes/app_theme.dart';
import 'views/pages/vista_historial.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cafetería',
      theme: AppTheme.buildTheme(),
      initialRoute: '/cafe',
      routes: {
        '/cafe': (ctx) => const VistaCafe(),
        '/notaVentaCafe': (ctx) => const VistaNotaVentaCafe(),
        '/historial': (ctx) => const VistaHistorial(),
      },
    );
  }
}
