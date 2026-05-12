import '../models/modelos.dart';
import 'servicioController.dart';
import 'ajusteController.dart';

class PagoController {
  final List<Pago> _pagos = [];
  final ServicioController servicioController;
  final AjusteController ajusteController;

  PagoController({required this.servicioController, required this.ajusteController});

  List<Pago> obtenerPagos() => List.unmodifiable(_pagos);

  /// Calcula subtotal según la tarifa del servicio y el consumo/provided base.
  double calcularSubtotal(Servicio servicio, double consumo, {double valorBase = 0.0}) {
    final tarifa = servicio.tarifa;
    switch (tarifa.tipo) {
      case TipoTarifa.porUnidad:
        final precioUnit = tarifa.precio;
        // Return consumption-based subtotal (exclude cargoFijo here)
        return consumo * precioUnit;
      case TipoTarifa.fija:
        // If a valorBase was provided (e.g., Internet), use it as subtotal
        if (valorBase > 0) return valorBase;
        return tarifa.precio;
      case TipoTarifa.porTramos:
        final tramos = tarifa.tramos;
        if (tramos == null || tramos.isEmpty) return consumo * tarifa.precio + tarifa.cargoFijo;

        // Progressive/tranche billing: compute overlap of each tramo with [0, consumo]
        final sorted = [...tramos]..sort((a, b) => a.minimo.compareTo(b.minimo));
        double subtotal = 0.0;

        for (var tramo in sorted) {
          final lower = tramo.minimo;
          final upper = tramo.maximo ?? double.infinity;
          if (consumo <= lower) continue; // no overlap
          final overlapUpper = consumo < upper ? consumo : upper;
          final unitsInTramo = overlapUpper - lower;
          if (unitsInTramo > 0) subtotal += unitsInTramo * tramo.precioPorUnidad;
        }

        // Return only the consumption-based subtotal (without cargo fijo)
        return subtotal;
    }
    // Fallback por seguridad (no debería alcanzarse si enum está completo)
  }

  /// Calcula descuentos y recargos y devuelve un mapa con subtotal, descuentos, recargos y total.
  Map<String, double> calcularTotal(Servicio servicio, double consumo, List<String> ajustesSeleccionados, {double valorBase = 0.0, double streamingPrecio = 0.0, String? streamingNombre}) {
    final subtotal = calcularSubtotal(servicio, consumo, valorBase: valorBase);
    final cargoFijo = servicio.tarifa.cargoFijo;
    // tasa (alcantarillado/saneamiento) = 38.6% del subtotal (consumo) - applies only to Agua
    final tasa = servicio.id == 's_agua' ? subtotal * 0.386 : 0.0;
    // Cargo de basura: si existe el servicio 's_basura, su cargo fijo se agrega al total (only for Agua)
    final basuraServicio = servicioController.obtenerPorId('s_basura');
    final cargoBasura = basuraServicio?.tarifa.cargoFijo ?? 0.0;

    // Charges specific to Energia (Luz)
    double comercializacion = 0.0;
    double bomberos = 0.0;
    if (servicio.id == 's_energia') {
      comercializacion = 1.41;
      bomberos = 2.00;
    }
    // Alumbrado público (10.5% del subtotal) aplica para Energía
    double alumbrado = 0.0;
    if (servicio.id == 's_energia') {
      alumbrado = subtotal * 0.105;
    }
    // Cargo adicional para Internet: 15% del subtotal
    double cargoInternet15 = 0.0;
    if (servicio.id == 's_internet') {
      cargoInternet15 = subtotal * 0.15;
    }

    // Cargo adicional para TV: 15% del subtotal de TV
    double cargoTV15 = 0.0;
    if (servicio.id == 's_tv') {
      cargoTV15 = subtotal * 0.15;
    }

    // Cargo adicional para Streaming (servicio separado): 15% del subtotal
    double cargoStreaming15 = 0.0;
    if (servicio.id == 's_streaming') {
      cargoStreaming15 = subtotal * 0.15;
    }

    // Streaming: si se proporcionó streamingPrecio, añadir su IVA 15% y sumarlo al total
    double ivaStreaming = 0.0;
    if (streamingPrecio > 0) {
      ivaStreaming = streamingPrecio * 0.15;
    }

    double totalDescuentos = 0.0;
    double totalRecargos = 0.0;

    for (final id in ajustesSeleccionados) {
      final ajuste = ajusteController.buscarPorId(id);
      if (ajuste == null) continue;
      // Discounts/recargos are calculated over the consumo subtotal
      final monto = ajuste.esPorcentaje ? subtotal * (ajuste.monto / 100.0) : ajuste.monto;
      if (ajusteController.esDescuento(id)) {
        totalDescuentos += monto;
      } else if (ajusteController.esRecargo(id)) {
        totalRecargos += monto;
      }
    }

    // If the current service is Agua, include the basura cargo as an additional fixed cost
    final aplicaBasura = servicio.id == 's_agua';
    final total = subtotal + cargoFijo + tasa + (aplicaBasura ? cargoBasura : 0.0) + comercializacion + bomberos + alumbrado + cargoInternet15 + cargoTV15 + cargoStreaming15 + streamingPrecio + ivaStreaming - totalDescuentos + totalRecargos;
    return {
      'subtotal': subtotal,
      'cargoFijo': cargoFijo,
      'tasa': tasa,
      'cargoBasura': aplicaBasura ? cargoBasura : 0.0,
      'comercializacion': comercializacion,
      'bomberos': bomberos,
      'alumbrado': alumbrado,
      'cargoInternet15': cargoInternet15,
      'cargoTV15': cargoTV15,
      'cargoStreaming15': cargoStreaming15,
      'streamingPrecio': streamingPrecio,
      'ivaStreaming': ivaStreaming,
      'streamingNombre': streamingNombre != null ? 1.0 : 0.0,
      'descuentos': totalDescuentos,
      'recargos': totalRecargos,
      'total': total
    };
  }

  Pago guardarPago({required String clienteId, required Servicio servicio, required double consumo, List<String> ajustesSeleccionados = const [], double valorBase = 0.0, String? formaPago = 'efectivo', String? operadora, String? streamingNombre, double? streamingPrecio}) {
    final resumen = calcularTotal(servicio, consumo, ajustesSeleccionados, valorBase: valorBase, streamingPrecio: streamingPrecio ?? 0.0, streamingNombre: streamingNombre);
    final pago = Pago(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      clienteId: clienteId,
      servicioId: servicio.id,
      consumo: consumo,
      valorBase: valorBase,
      subtotal: resumen['subtotal']!,
      operadora: operadora,
      streamingNombre: streamingNombre,
      streamingPrecio: streamingPrecio,
      descuentos: ajustesSeleccionados.where((id) => ajusteController.esDescuento(id)).map((id) => ajusteController.buscarPorId(id)!).toList(),
      recargos: ajustesSeleccionados.where((id) => ajusteController.esRecargo(id)).map((id) => ajusteController.buscarPorId(id)!).toList(),
      total: resumen['total']!,
      fecha: DateTime.now(),
      //formaPago: formaPago,
    );
    _pagos.add(pago);
    return pago;
  }
}
