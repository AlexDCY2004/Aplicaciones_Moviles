import 'package:flutter/material.dart';
import 'temas_personalizados/index.dart';
import 'views/pages/nuevo_pago_view.dart';
import 'views/pages/resumen_pago_view.dart';
import 'views/pages/registro_cliente_view.dart';
import 'views/pages/historial_view.dart';
import 'views/pages/clientes_list_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pago de servicios básicos',
      debugShowCheckedModeBanner: false,
      theme: TemaPersonal.claro,
      darkTheme: TemaPersonal.oscuro,
      // Force light theme regardless of device settings
      themeMode: ThemeMode.light,
      home: Builder(builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Inicio')),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: Text(
                    'Bienvenido al sistema de pago de servicios básicos',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text('Registrar clientes'),
                  onPressed: () => Navigator.pushNamed(context, '/registro'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(200, 48)),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.group),
                  label: const Text('Ver clientes'),
                  onPressed: () => Navigator.pushNamed(context, '/clientes'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(200, 48)),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Pagar servicios básicos'),
                  onPressed: () => Navigator.pushNamed(context, '/nuevo'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.history),
                  label: const Text('Historial de pagos'),
                  onPressed: () => Navigator.pushNamed(context, '/historial'),
                  style: ElevatedButton.styleFrom(minimumSize: const Size(200, 48)),
                ),
              ],
            ),
          ),
        ),
      )),
      routes: {
        // Open NuevoPagoView with hideOtros=true when launched from main
        '/nuevo': (context) => NuevoPagoView(hideOtros: true),
        '/registro': (context) => const RegistroClienteView(),
        '/clientes': (context) => const ClientesListView(),
        '/historial': (context) => const HistorialView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/resumen') {
          final args = settings.arguments as Map<String, dynamic>?;
          return MaterialPageRoute(builder: (c) => ResumenPagoView(resumenArgs: args));
        }
        return null;
      },
    );
  }
}


