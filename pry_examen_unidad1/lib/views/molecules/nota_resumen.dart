import 'package:flutter/material.dart';
import '../../models/pedido_cafe_model.dart';

class NotaResumen extends StatelessWidget {
  final PedidoCafeModelo pedido;

  const NotaResumen({Key? key, required this.pedido}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cliente: ${pedido.nombreCliente}', style: const TextStyle(fontSize: 16)) ,
        const SizedBox(height: 8),
        Text('Producto: ${pedido.producto} (${pedido.tamano})'),
        Text('Cantidad: ${pedido.cantidad}'),
        const Divider(),
        Text('Subtotal: \$${pedido.subtotal.toStringAsFixed(2)} (USD)'),
        Text('IVA (15%): \$${pedido.iva.toStringAsFixed(2)} (USD)'),
        const SizedBox(height: 8),
        Text('Total a pagar: \$${pedido.total.toStringAsFixed(2)} (USD)', style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
