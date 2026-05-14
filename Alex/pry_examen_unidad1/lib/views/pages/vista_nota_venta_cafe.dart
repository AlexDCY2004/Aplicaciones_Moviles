import 'package:flutter/material.dart';
import '../../models/pedido_cafe_model.dart';
import '../molecules/nota_resumen.dart';
import '../atoms/primary_button.dart';

class VistaNotaVentaCafe extends StatelessWidget {
  const VistaNotaVentaCafe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final PedidoCafeModelo pedido = (args is PedidoCafeModelo)
        ? args
        : PedidoCafeModelo(nombreCliente: '', producto: '', tamano: '', cantidad: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Nota de venta'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: pedido.cantidad > 0
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  NotaResumen(pedido: pedido),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Comprar otro Café',
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, '/cafe', (route) => false);
                    },
                  ),
                ],
              )
            : const Text('Pedido inválido'),
      ),
    );
  }
}
