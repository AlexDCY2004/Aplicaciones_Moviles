import 'package:ejercicio_cajero/model/cajero_model.dart';

class CajeroController {
  final CajeroModel model = CajeroModel();
  Venta? _ventaActual;
  bool _ventaFinalizada = false;

  String iniciarNuevaVenta() {
    if (model.cajaCerrada) return 'La caja está cerrada. No se puede iniciar una nueva venta.';
    _ventaActual = Venta(articulos: []);
    _ventaFinalizada = false;
    return 'Nueva venta iniciada.';
  }

  String agregarArticulo(double precioUnitario, int cantidad) {
    if (model.cajaCerrada) return 'Error: La caja está cerrada. No se pueden añadir artículos.';
    if (_ventaActual == null) return 'Error: No hay una venta iniciada. Inicia una nueva venta primero.';
    if (_ventaFinalizada) return 'Error: La venta ya fue finalizada. Inicia nueva venta para agregar artículos.';
    
    if (precioUnitario <= 0) return 'Error: El precio debe ser mayor a 0.';
    if (cantidad <= 0) return 'Error: La cantidad debe ser mayor a 0.';
    if (precioUnitario.isNaN || cantidad.isNaN) return 'Error: Ingrese valores numéricos válidos.';

    _ventaActual!.articulos.add(Articulo(precioUnitario: precioUnitario, cantidad: cantidad));
    return 'Artículo añadido.';
  }

  String finalizarVenta() {
    if (_ventaActual == null) return 'Error: No hay una venta en curso.';
    if (_ventaActual!.articulos.isEmpty) return 'Error: La venta no tiene artículos. Agrega al menos un artículo antes de finalizar.';
    try {
      model.agregarVenta(_ventaActual!);
      _ventaFinalizada = true;
      return 'Venta finalizada.';
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  String cancelarVenta() {
    _ventaActual = null;
    return 'Venta cancelada.';
  }

  String finalizarDia() {
    model.finalizarDia();
    return 'Día finalizado.';
  }

  String iniciarNuevoDia() {
    model.iniciarNuevoDia();
    return 'Nuevo día iniciado.';
  }

  List<Venta> ventasDelDia() => model.ventasDelDia;

  List<DiaCerrado> historicoDelDias() => model.diasCerrados;

  double obtenerTotalDelDia() {
    if (model.cajaCerrada && model.diasCerrados.isNotEmpty) {
      return model.diasCerrados.last.totalVentas;
    }
    return model.totalDelDia;
  }

  bool ventaFinalizada() => _ventaFinalizada;

  bool esCajaCerrada() => model.cajaCerrada;

  Venta? obtenerVentaActual() => _ventaActual;

  int obtenerNumeroDia() => model.numeroDiaActual;
}