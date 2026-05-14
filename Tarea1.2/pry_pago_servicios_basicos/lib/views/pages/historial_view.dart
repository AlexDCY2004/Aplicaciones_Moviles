
import 'package:flutter/material.dart';

import '../../controllers/singletons.dart';
import '../../temas_personalizados/esquema_Color.dart';

class HistorialView extends StatelessWidget {
  const HistorialView({super.key});

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
    final pagos = pagoControllerSingleton
        .obtenerPagos()
        .where((p) => p.servicioId != 's_basura')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de pagos'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Volver al inicio',
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false),
          ),
        ],
      ),
      body: pagos.isEmpty
          ? const Center(child: Text('No hay pagos registrados'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: pagos.length,
              itemBuilder: (c, i) {
                final p = pagos[i];
                final cliente = clienteControllerSingleton.buscarPorId(p.clienteId);
                final servicio = servicioControllerSingleton.obtenerPorId(p.servicioId);
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 14.0),
                      child: Row(children: [
                        const Icon(Icons.receipt_long, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Pago del ${servicio?.nombre ?? p.servicioId}', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 6),
                            Text('${cliente?.nombre ?? p.clienteId}'),
                            const SizedBox(height: 4),
                            Text(p.fecha.toLocal().toString().split('.').first, style: TextStyle(color: Colors.grey[700], fontSize: 13)),
                          ]),
                        ),
                        const SizedBox(width: 12),
                        Column(children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(color: ColoresPersonal.acento.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                            child: Text(fmtMoney(p.total), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    final serv = servicio;
                                    final cli = cliente;
                                    final subtotal = p.subtotal;
                                    final cargoFijo = serv?.tarifa.cargoFijo ?? 0.0;
                                    final tasa = serv?.id == 's_agua' ? subtotal * 0.386 : 0.0;
                                    final cargoBasura = serv?.id == 's_agua' ? servicioControllerSingleton.obtenerPorId('s_basura')?.tarifa.cargoFijo ?? 0.0 : 0.0;
                                    final comercializacion = serv?.id == 's_energia' ? 1.41 : 0.0;
                                    final bomberos = serv?.id == 's_energia' ? 2.0 : 0.0;
                                    final alumbrado = serv?.id == 's_energia' ? subtotal * 0.105 : 0.0;
                                    final cargoInternet15 = serv?.id == 's_internet' ? subtotal * 0.15 : 0.0;
                                    final cargoTV15 = serv?.id == 's_tv' ? subtotal * 0.15 : 0.0;
                                    final streamingPrecio = p.streamingPrecio ?? 0.0;
                                    final ivaStreaming = streamingPrecio > 0 ? streamingPrecio * 0.15 : 0.0;
                                    String fmtN(num? v) {
                                      if (v == null) return '-';
                                      var s = v.toStringAsFixed(2);
                                      s = s.replaceAll(RegExp(r'0+$'), '');
                                      s = s.replaceAll(RegExp(r'\.$'), '');
                                      return s;
                                    }

                                    final maxWidth = MediaQuery.of(ctx).size.width * 0.6;

                                    return Dialog(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: MediaQuery.of(ctx).size.height * 0.85),
                                        child: SingleChildScrollView(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text('Detalle del pago', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                            const SizedBox(height: 12),
                                            ListTile(title: const Text('Servicio'), subtitle: Text(serv?.nombre ?? '-')),
                                            if (serv?.id == 's_internet' && p.operadora != null && p.operadora!.isNotEmpty) ListTile(title: const Text('Operadora'), subtitle: Text(p.operadora!)),
                                            ListTile(title: const Text('Cliente'), subtitle: Text(cli?.nombre ?? '-')),
                                            ListTile(title: const Text('Fecha'), subtitle: Text(p.fecha.toLocal().toString())),
                                            ListTile(title: const Text('Consumo'), subtitle: Text('${fmtN(p.consumo)} ${serv?.unidad ?? ''}')),
                                            ListTile(title: const Text('Subtotal consumo'), subtitle: Text(fmtMoney(subtotal))),
                                            if (cargoFijo > 0) ListTile(title: const Text('Cargo fijo (servicio)'), subtitle: Text(fmtMoney(cargoFijo))),
                                            if (comercializacion > 0) ListTile(title: const Text('Comercialización'), subtitle: Text(fmtMoney(comercializacion))),
                                            if (bomberos > 0) ListTile(title: const Text('Bomberos'), subtitle: Text(fmtMoney(bomberos))),
                                            if (alumbrado > 0) ListTile(title: const Text('Alumbrado público (10.5%)'), subtitle: Text(fmtMoney(alumbrado))),
                                            if (cargoInternet15 > 0) ListTile(title: const Text('Cargo adicional Internet (15%)'), subtitle: Text(fmtMoney(cargoInternet15))),
                                            if (cargoTV15 > 0) ListTile(title: const Text('Cargo adicional TV (15%)'), subtitle: Text(fmtMoney(cargoTV15))),
                                            if (streamingPrecio > 0) ListTile(title: Text('Streaming (${p.streamingNombre ?? 'Streaming'})'), subtitle: Text(fmtMoney(streamingPrecio))),
                                            if (ivaStreaming > 0) ListTile(title: const Text('IVA streaming (15%)'), subtitle: Text(fmtMoney(ivaStreaming))),
                                            if (cargoBasura > 0) ListTile(title: const Text('Cargo basura'), subtitle: Text(fmtMoney(cargoBasura))),
                                            if (tasa > 0) ListTile(title: const Text('Tasa saneamiento (38.6%)'), subtitle: Text(fmtMoney(tasa))),
                                            if (p.descuentos.isNotEmpty) ...[
                                              const Divider(),
                                              const Text('Descuentos', style: TextStyle(fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 8),
                                              ...p.descuentos.map((d) {
                                                final monto = d.esPorcentaje ? subtotal * (d.monto / 100.0) : d.monto;
                                                return ListTile(title: Text(d.nombre), subtitle: Text(d.esPorcentaje ? '${d.monto}% = ${fmtMoney(monto)}' : fmtMoney(monto)));
                                              }).toList(),
                                            ],
                                            if (p.recargos.isNotEmpty) ...[
                                              const Divider(),
                                              const Text('Recargos', style: TextStyle(fontWeight: FontWeight.w600)),
                                              const SizedBox(height: 8),
                                              ...p.recargos.map((r) {
                                                final monto = r.esPorcentaje ? subtotal * (r.monto / 100.0) : r.monto;
                                                return ListTile(title: Text(r.nombre), subtitle: Text(r.esPorcentaje ? '${r.monto}% = ${fmtMoney(monto)}' : fmtMoney(monto)));
                                              }).toList(),
                                            ],
                                            const SizedBox(height: 8),
                                            ListTile(title: const Text('Total pagado'), subtitle: Text(fmtMoney(p.total), style: const TextStyle(fontWeight: FontWeight.w700))),
                                            const SizedBox(height: 8),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cerrar')),
                                            )
                                          ]),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: const Text('Visualizar'),
                          )
                        ])
                      ]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
