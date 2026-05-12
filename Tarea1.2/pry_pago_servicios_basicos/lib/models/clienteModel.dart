class Cliente {
  final String id;
  final String nombre;
  final String direccion;
  final String telefono;
  final String? correo;
  final DateTime creadoEn;

  Cliente({
    required this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    this.correo,
    DateTime? creadoEn,
  }) : creadoEn = creadoEn ?? DateTime.now();

  factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: (json['id'] ?? json['Id']) as String,
        nombre: (json['nombre'] ?? json['name']) as String,
        direccion: (json['direccion'] ?? json['address']) as String,
        telefono: (json['telefono'] ?? json['phone']) as String,
        correo: (json['correo'] ?? json['email']) as String?,
        creadoEn: json['creadoEn'] != null
            ? DateTime.parse(json['creadoEn'] as String)
            : (json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now()),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'direccion': direccion,
        'telefono': telefono,
        'correo': correo,
        'creadoEn': creadoEn.toIso8601String(),
      };

  Cliente copyWith({
    String? id,
    String? nombre,
    String? direccion,
    String? telefono,
    String? correo,
  }) {
    return Cliente(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      correo: correo ?? this.correo,
      creadoEn: creadoEn,
    );
  }
}
