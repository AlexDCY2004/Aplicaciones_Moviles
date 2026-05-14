import 'package:flutter/material.dart';
import '../../models/pedido_cafe_model.dart';
import '../molecules/pedido_form.dart';

class VistaCafe extends StatelessWidget {
  const VistaCafe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cafetería'),
        centerTitle: true,
        actions: [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PedidoForm(onPedidoProcesado: (PedidoCafeModelo p) {
          Navigator.pushNamed(context, '/notaVentaCafe', arguments: p);
        }),
      ),
    );
  }
}
