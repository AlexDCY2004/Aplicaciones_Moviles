import 'package:flutter/material.dart';

import '../controller/maquina_cambio_controller.dart';

class ResultadoCambioPage extends StatelessWidget {
  final CambioViewData data;

  const ResultadoCambioPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final cambioLabel = MaquinaCambioController.formatCurrency(data.cambioCents);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultado del Cambio'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Cambio total: $cambioLabel'),
        ),
      ),
    );
  }
}
