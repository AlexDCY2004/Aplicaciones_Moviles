import 'ajuste_model.dart';

class Pago {
  final String id;
  final String clienteId;
  final String servicioId;
  final double consumo; // unidades o valor base
  final double valorBase; // valor base explícito opcional
  final double subtotal;
  final String? operadora;
  final String? streamingNombre;
  final double? streamingPrecio;
  final List<Ajuste> descuentos;
  final List<Ajuste> recargos;
  final double total;
  final DateTime fecha;
  final String formaPago;

  Pago({
    required this.id,
    required this.clienteId,
    required this.servicioId,
    required this.consumo,
    this.valorBase = 0.0,
    required this.subtotal,
    this.operadora,
    this.streamingNombre,
    this.streamingPrecio,
    this.descuentos = const [],
    this.recargos = const [],
    required this.total,
    DateTime? fecha,
    this.formaPago = 'efectivo',
  }) : fecha = fecha ?? DateTime.now();

  factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        id: json['id'] as String,
        clienteId: json['clienteId'] as String,
        servicioId: json['servicioId'] as String,
        consumo: (json['consumo'] as num).toDouble(),
        valorBase: json['valorBase'] != null ? (json['valorBase'] as num).toDouble() : 0.0,
        subtotal: (json['subtotal'] as num).toDouble(),
        operadora: json['operadora'] as String?,
        streamingNombre: json['streamingNombre'] as String?,
        streamingPrecio: json['streamingPrecio'] != null ? (json['streamingPrecio'] as num).toDouble() : null,
        descuentos: json['descuentos'] != null
            ? (json['descuentos'] as List).map((e) => Ajuste.fromJson(e)).toList()
            : [],
        recargos: json['recargos'] != null
            ? (json['recargos'] as List).map((e) => Ajuste.fromJson(e)).toList()
            : [],
        total: (json['total'] as num).toDouble(),
        fecha: json['fecha'] != null ? DateTime.parse(json['fecha'] as String) : DateTime.now(),
        formaPago: json['formaPago'] as String? ?? 'efectivo',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'clienteId': clienteId,
        'servicioId': servicioId,
        'consumo': consumo,
        'valorBase': valorBase,
        'subtotal': subtotal,
        'operadora': operadora,
        'streamingNombre': streamingNombre,
        'streamingPrecio': streamingPrecio,
        'descuentos': descuentos.map((d) => d.toJson()).toList(),
        'recargos': recargos.map((d) => d.toJson()).toList(),
        'total': total,
        'fecha': fecha.toIso8601String(),
        'formaPago': formaPago,
      };
}
