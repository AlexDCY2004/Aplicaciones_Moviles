class Policy {
  String? id; 
  String code;
  String client;
  String insuranceType;
  DateTime startDate;
  DateTime endDate;
  double insuredValue;

  Policy({
    this.id,
    required this.code,
    required this.client,
    required this.insuranceType,
    required this.startDate,
    required this.endDate,
    required this.insuredValue,
  });

  // Mapeamos lo que viene de MockAPI en español a las variables de Flutter
  factory Policy.fromJson(Map<String, dynamic> json) => Policy(
        id: json['id']?.toString(),
        code: json['codigo'] ?? '',
        client: json['cliente'] ?? '',
        insuranceType: json['tipoSeguro'] ?? '',
        startDate: DateTime.parse(json['fechaInicio']),
        endDate: DateTime.parse(json['fechaVencimiento']),
        insuredValue: (json['valorAsegurado'] as num).toDouble(),
      );

  // Convertimos las variables de Flutter al formato en español que espera MockAPI
  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'codigo': code,
        'cliente': client,
        'tipoSeguro': insuranceType,
        'fechaInicio': startDate.toIso8601String(),
        'fechaVencimiento': endDate.toIso8601String(),
        'valorAsegurado': insuredValue,
      };
}