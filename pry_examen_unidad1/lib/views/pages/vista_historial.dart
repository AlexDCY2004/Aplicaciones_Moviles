import 'package:flutter/material.dart';
import '../../services/sales_repository.dart';
import '../../models/pedido_cafe_model.dart';
import '../molecules/nota_resumen.dart';

class VistaHistorial extends StatelessWidget {
  const VistaHistorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ventas = SalesRepository.instance.getAll();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: ventas.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final PedidoCafeModelo p = ventas[index];
          return ListTile(
            title: Text('${p.nombreCliente} — ${p.producto} (${p.tamano})'),
            subtitle: Text('\$${p.total.toStringAsFixed(2)} (USD) • ${p.creadoEn != null ? p.creadoEn!.toLocal().toString() : ''}'),
            onTap: () {
              // mostrar detalle en nueva pantalla usando NotaResumen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Scaffold(
                  appBar: AppBar(title: const Text('Detalle de venta'), centerTitle: true),
                  body: Padding(padding: const EdgeInsets.all(16.0), child: NotaResumen(pedido: p)),
                )),
              );
            },
          );
        },
      ),
    );
  }
}
