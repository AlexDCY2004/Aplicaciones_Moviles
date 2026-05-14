enum TipoTarifa { porUnidad, fija, porTramos }

class Tramo {
  final double minimo; // inclusive
  final double? maximo; // exclusive if provided, null means open-ended
  final double precioPorUnidad;

  Tramo({required this.minimo, this.maximo, required this.precioPorUnidad});

  factory Tramo.fromJson(Map<String, dynamic> json) => Tramo(
        minimo: (json['minimo'] ?? json['min'] as num).toDouble(),
        maximo: json['maximo'] != null ? (json['maximo'] as num).toDouble() : (json['max'] != null ? (json['max'] as num).toDouble() : null),
        precioPorUnidad: (json['precioPorUnidad'] ?? json['pricePerUnit'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'minimo': minimo,
        'maximo': maximo,
        'precioPorUnidad': precioPorUnidad,
      };
}

class Tarifa {
  final TipoTarifa tipo;
  final double precio; // usado para `porUnidad` o `fija` como base
  final List<Tramo>? tramos;
  final double cargoFijo; // cargo fijo mensual/servicio

  Tarifa({
    required this.tipo,
    required this.precio,
    this.tramos,
    this.cargoFijo = 0.0,
  });

  factory Tarifa.fromJson(Map<String, dynamic> json) => Tarifa(
        tipo: TipoTarifa.values.firstWhere((e) => e.toString() == (json['tipo'] ?? json['type'])),
        precio: (json['precio'] ?? json['price'] as num).toDouble(),
        tramos: json['tramos'] != null
            ? (json['tramos'] as List).map((e) => Tramo.fromJson(e)).toList()
            : (json['tiers'] != null ? (json['tiers'] as List).map((e) => Tramo.fromJson(e)).toList() : null),
        cargoFijo: json['cargoFijo'] != null
            ? (json['cargoFijo'] as num).toDouble()
            : (json['fixedCharge'] != null ? (json['fixedCharge'] as num).toDouble() : 0.0),
      );

  Map<String, dynamic> toJson() => {
        'tipo': tipo.toString(),
        'precio': precio,
        'tramos': tramos?.map((t) => t.toJson()).toList(),
        'cargoFijo': cargoFijo,
      };
}
