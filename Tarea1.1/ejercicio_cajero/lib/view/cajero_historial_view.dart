import 'package:flutter/material.dart';

import '../controller/cajero_controller.dart';

class CajeroHistorialView extends StatelessWidget {
  const CajeroHistorialView({super.key});

  CajeroController _getController(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    return args as CajeroController;
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _getController(context);
    final ventasDelDia = ctrl.ventasDelDia();
    final diasPasados = ctrl.historicoDelDias();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de ventas'),
        backgroundColor: Colors.red[700],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(height: 18),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  color: Colors.red[50],
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Historial del dia actual',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 150,
                          child: ventasDelDia.isEmpty
                              ? const Center(child: Text('No hay ventas en este dia'))
                              : ListView.builder(
                                  itemCount: ventasDelDia.length,
                                  itemBuilder: (context, i) {
                                    final venta = ventasDelDia[i];
                                    return Card(
                                      child: ListTile(
                                        title: Text('Venta ${i + 1} - \$${venta.total.toStringAsFixed(2)}'),
                                        subtitle: Text('${venta.articulos.length} articulos'),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  color: Colors.amber[50],
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Historico de dias',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 200,
                          child: diasPasados.isEmpty
                              ? const Center(child: Text('No hay dias cerrados'))
                              : ListView.builder(
                                  itemCount: diasPasados.length,
                                  itemBuilder: (context, i) {
                                    final dia = diasPasados[i];
                                    return Card(
                                      child: ListTile(
                                        title: Text('Dia ${dia.numeroDia} - \$${dia.totalVentas.toStringAsFixed(2)}'),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Regresar'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
