import 'package:flutter/material.dart';

import '../../controllers/singletons.dart';

class ResumenPagoView extends StatelessWidget {
  final Map<String, dynamic>? resumenArgs;

  const ResumenPagoView({super.key, this.resumenArgs});

  @override
  Widget build(BuildContext context) {
    String fmtNum(num? v) {
      if (v == null) return '-';
      var s = v.toStringAsFixed(2);
      s = s.replaceAll(RegExp(r'0+$'), '');
      s = s.replaceAll(RegExp(r'\.$'), '');
      return s;
    }
    String fmtMoney(num? v) {
      final s = fmtNum(v);
      if (s == '-') return s;
      return '\$' + s;
    }
    final args = resumenArgs ?? ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null) {
      return Scaffold(appBar: AppBar(title: const Text('Resumen de pago')), body: const Center(child: Text('No hay resumen')));
    }

    final resumen = args['resumen'] as Map<String, dynamic>?;
    final clienteId = args['clienteId'] as String?;
    final servicioId = args['servicioId'] as String?;
    final servicioNombre = args['servicioNombre'] as String?;
    final consumo = args['consumo'] as double? ?? 0.0;
    final ajustes = List<String>.from(args['ajustes'] ?? []);
    final operadoraArg = args['operadora'] as String?;
    final valorBaseArg = (args['valorBase'] as num?)?.toDouble() ?? 0.0;
    final streamingNombreArg = args['streamingNombre'] as String?;
    final streamingPrecioArg = (args['streamingPrecio'] as num?)?.toDouble() ?? 0.0;

    final cliente = clienteId != null ? clienteControllerSingleton.buscarPorId(clienteId) : null;
    final servicio = servicioId != null ? servicioControllerSingleton.obtenerPorId(servicioId) : null;

    return Scaffold(
      appBar: AppBar(title: Text(servicioNombre ?? 'Resumen de pago')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (cliente != null) ...[
            Text('Cliente: ${cliente.nombre}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
          ],
          if (servicio != null) ...[
            Text('Servicio: ${servicio.nombre}'),
            if (operadoraArg != null && operadoraArg.isNotEmpty && servicio.id == 's_internet') Text('Operadora: $operadoraArg'),
            Text('Consumo: ${fmtNum(consumo)} ${servicio.unidad}'),
            const SizedBox(height: 12),
          ],
          if (resumen != null) ...[
            Text('Subtotal consumo: ${fmtMoney(resumen['subtotal'] as num?)}'),
            if ((resumen['cargoFijo'] ?? 0) > 0) Text('Cargo fijo: ${fmtMoney(resumen['cargoFijo'] as num?)}'),
            if ((resumen['comercializacion'] ?? 0) > 0) Text('Comercialización: ${fmtMoney(resumen['comercializacion'] as num?)}'),
            if ((resumen['bomberos'] ?? 0) > 0) Text('Bomberos: ${fmtMoney(resumen['bomberos'] as num?)}'),
            if ((resumen['alumbrado'] ?? 0) > 0) Text('Alumbrado público (10.5%): ${fmtMoney(resumen['alumbrado'] as num?)}'),
            if ((resumen['cargoInternet15'] ?? 0) > 0) Text('Cargo adicional Internet (15%): ${fmtMoney(resumen['cargoInternet15'] as num?)}'),
            if ((resumen['cargoTV15'] ?? 0) > 0) Text('Cargo adicional TV (15%): ${fmtMoney(resumen['cargoTV15'] as num?)}'),
            if (streamingPrecioArg > 0) ...[
              Text('Streaming: ${streamingNombreArg ?? 'Streaming'}'),
              Text('Precio streaming: ${fmtMoney(streamingPrecioArg)}'),
              Text('IVA streaming (15%): ${fmtMoney(resumen['ivaStreaming'] as num?)}'),
            ],
            if ((resumen['tasa'] ?? 0) > 0) Text('Tasa saneamiento (38.6%): ${fmtMoney(resumen['tasa'] as num?)}'),
            if ((resumen['cargoBasura'] ?? 0) > 0) Text('Cargo basura: ${fmtMoney(resumen['cargoBasura'] as num?)}'),
            const SizedBox(height: 8),
            Text('Descuentos: ${fmtMoney(resumen['descuentos'] as num?)}'),
            Text('Recargos: ${fmtMoney(resumen['recargos'] as num?)}'),
            const SizedBox(height: 12),
            Text('Total: ${fmtMoney(resumen['total'] as num?)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
          const Spacer(),
          Row(children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (clienteId == null || servicio == null) return;
                  pagoControllerSingleton.guardarPago(
                    clienteId: clienteId,
                    servicio: servicio,
                    consumo: consumo,
                    ajustesSeleccionados: ajustes,
                    valorBase: valorBaseArg,
                    operadora: operadoraArg,
                    streamingNombre: streamingNombreArg,
                    streamingPrecio: streamingPrecioArg,
                  );
                  
                  Navigator.pushNamedAndRemoveUntil(context, '/historial', ModalRoute.withName('/'));
                },
                child: const Text('Confirmar pago'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ),
          ])
        ]),
      ),
    );
  }
}
