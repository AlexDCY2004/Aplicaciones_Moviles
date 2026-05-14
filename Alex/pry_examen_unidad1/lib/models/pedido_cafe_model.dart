class PedidoCafeModelo {
  String nombreCliente;
  String producto; // 'Café', 'Capuchino', 'Chocolate'
  String tamano; // 'Pequeño','Mediano','Grande'
  int cantidad;
  double subtotal;
  double iva;
  double total;

  PedidoCafeModelo({
    required this.nombreCliente,
    required this.producto,
    required this.tamano,
    required this.cantidad,
    this.subtotal = 0.0,
    this.iva = 0.0,
    this.total = 0.0,
  });

  Map<String, dynamic> toJson() => {
        'nombreCliente': nombreCliente,
        'producto': producto,
        'tamano': tamano,
        'cantidad': cantidad,
        'subtotal': subtotal,
        'iva': iva
      };

  static PedidoCafeModelo fromJson(Map<String, dynamic> json) => PedidoCafeModelo(
        nombreCliente: json['nombreCliente'] ?? '',
        producto: json['producto'] ?? '',
        tamano: json['tamano'] ?? '',
        cantidad: json['cantidad'] ?? 0,
        subtotal: (json['subtotal'] ?? 0).toDouble(),
        iva: (json['iva'] ?? 0).toDouble(),
        total: (json['total'] ?? 0).toDouble(),
      );
}
