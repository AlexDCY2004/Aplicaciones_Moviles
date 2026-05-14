// Artículo individual con precio y cantidad
class Articulo {
  final double precioUnitario;
  final int cantidad;

  Articulo({required this.precioUnitario, required this.cantidad});

  double get total => precioUnitario * cantidad;
}

// Venta de un cliente (múltiples artículos)
class Venta {
  final List<Articulo> articulos;
  final DateTime fecha;

  Venta({required this.articulos, DateTime? fecha}) : fecha = fecha ?? DateTime.now();

  double get total => articulos.fold(0.0, (suma, art) => suma + art.total);
}

// Información de un día completado
class DiaCerrado {
  final int numeroDia;
  final double totalVentas;

  DiaCerrado({required this.numeroDia, required this.totalVentas});
}

// Caja principal - gestiona ventas y días
class CajeroModel {
  int numeroDiaActual = 1;           // Número de día (1, 2, 3...)
  List<Venta> ventasDelDia = [];     // Ventas del día actual
  List<DiaCerrado> diasCerrados = []; // Histórico de días anteriores
  bool cajaCerrada = false;          // Solo se cierra cuando presiona "Finalizar día"

  double get totalDelDia =>
      ventasDelDia.fold(0.0, (suma, venta) => suma + venta.total);

  void agregarVenta(Venta venta) {
    if (cajaCerrada) throw StateError('La caja está cerrada');
    ventasDelDia.add(venta);
  }

  void finalizarDia() {
    // Guarda el día actual en el histórico
    diasCerrados.add(DiaCerrado(
      numeroDia: numeroDiaActual,
      totalVentas: totalDelDia,
    ));
    ventasDelDia = [];  // Limpiar historial del día
    cajaCerrada = true;
  }

  void iniciarNuevoDia() {
    numeroDiaActual++;
    ventasDelDia = [];
    cajaCerrada = false;
  }
}

