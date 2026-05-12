import 'tarifaModel.dart';

class Servicio {
  final String id;
  final String nombre;
  final String unidad; // e.g., "m3", "kWh", "mes"
  final Tarifa tarifa;

  Servicio({
    required this.id,
    required this.nombre,
    required this.unidad,
    required this.tarifa,
  });

  factory Servicio.fromJson(Map<String, dynamic> json) => Servicio(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        unidad: json['unidad'] as String,
        tarifa: Tarifa.fromJson(json['tarifa'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'unidad': unidad,
        'tarifa': tarifa.toJson(),
      };
}
