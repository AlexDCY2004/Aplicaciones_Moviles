import 'package:flutter/material.dart';

import 'view/cajero_compra_view.dart';
import 'view/cajero_historial_view.dart';
import 'view/cajero_home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const CajeroHomeView(),
        '/compra': (context) => const CajeroCompraView(),
        '/historial': (context) => const CajeroHistorialView(),
      },
    );
  }
}