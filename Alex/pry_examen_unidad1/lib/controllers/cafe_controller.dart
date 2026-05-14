import '../models/pedido_cafe_model.dart';

class CafeController {
  static const double IVA_RATE = 0.15;

  final Map<String, Map<String, double>> preciosPorProductoTamano = {
    'Café': {
      'Pequeño': 1.50,
      'Mediano': 1.80, 
      'Grande': 2.10,
    },
    'Capuchino': {
      'Pequeño': 2.30,
      'Mediano': 2.40,
      'Grande': 2.50,
    },
    'Chocolate': {
      'Pequeño': 3.50,
      'Mediano': 4.12,
      'Grande': 4.75,
    },
  };

  void validarPedido(PedidoCafeModelo pedido) {
    final nombre = pedido.nombreCliente.trim();
    if (nombre.isEmpty) throw ArgumentError('Nombre del cliente requerido');
    final nombreRegex = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$");
    if (!nombreRegex.hasMatch(nombre)) throw ArgumentError('Nombre inválido: solo letras y espacios');
    if (!preciosPorProductoTamano.containsKey(pedido.producto)) throw ArgumentError('Producto inválido');
    if (!(preciosPorProductoTamano[pedido.producto]?.containsKey(pedido.tamano) ?? false)) throw ArgumentError('Tamaño inválido');
    if (pedido.cantidad <= 0) throw ArgumentError('La cantidad debe ser mayor que cero');
  }

  // Validadores por campo para uso en la UI (devuelven mensaje de error o null).
  String? validarNombreField(String? value) {
    final nombre = value?.trim() ?? '';
    if (nombre.isEmpty) return 'Requerido';
    final nombreRegexFull = RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ\s]+$");
    if (!nombreRegexFull.hasMatch(nombre)) return 'Solo letras y espacios';
    return null;
  }

  String? validarCantidadField(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Requerido';
    // Solo dígitos, sin decimales ni signos
    if (!RegExp(r'^\d+$').hasMatch(v)) return 'Solo números enteros';
    final n = int.tryParse(v);
    if (n == null) return 'Número inválido';
    if (n <= 0) return 'La cantidad debe ser mayor que cero';
    return null;
  }

  String? validarProductoField(String? value) {
    if (value == null || value.isEmpty) return 'Seleccione un producto';
    if (!preciosPorProductoTamano.containsKey(value)) return 'Producto inválido';
    return null;
  }

  String? validarTamanoField(String? value) {
    if (value == null || value.isEmpty) return 'Seleccione un tamaño';
    // Si producto no viene aquí, asumimos tamaños válidos globales
    final valid = ['Pequeño', 'Mediano', 'Grande'];
    if (!valid.contains(value)) return 'Tamaño inválido';
    return null;
  }

  double precioUnitario(String producto, String tamano) {
    return preciosPorProductoTamano[producto]?[tamano] ?? 0.0;
  }

  PedidoCafeModelo procesarPedido(PedidoCafeModelo pedido) {
    validarPedido(pedido);
    final unit = precioUnitario(pedido.producto, pedido.tamano);
    pedido.subtotal = unit * pedido.cantidad;
    pedido.iva = pedido.subtotal * IVA_RATE;
    pedido.total = pedido.subtotal + pedido.iva;
    return pedido;
  }
}
