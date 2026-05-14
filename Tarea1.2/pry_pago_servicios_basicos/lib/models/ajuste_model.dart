class Ajuste {
  final String id;
  final String nombre;
  final double monto; // si esPorcentaje==true entonces es porcentaje (ej. 5.0 -> 5%)
  final bool esPorcentaje;
  final String? descripcion;

  Ajuste({
    required this.id,
    required this.nombre,
    required this.monto,
    this.esPorcentaje = false,
    this.descripcion,
  });

  factory Ajuste.fromJson(Map<String, dynamic> json) => Ajuste(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        monto: (json['monto'] as num).toDouble(),
        esPorcentaje: json['esPorcentaje'] as bool? ?? false,
        descripcion: json['descripcion'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'monto': monto,
        'esPorcentaje': esPorcentaje,
        'descripcion': descripcion,
      };
}
