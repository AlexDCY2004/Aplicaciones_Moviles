class ChoferModel {
  String nombre;
  List<double> horasPorDia; // 6 días: Lun, Mar, Mié, Jue, Vie, Sáb
  double sueldoPorHora;
  bool recibeBono; // CheckBox
  String tipoJornada; // RadioButton: 'Diurna' o 'Nocturna'

  ChoferModel({
    required this.nombre,
    required this.horasPorDia,
    required this.sueldoPorHora,
    this.recibeBono = false,
    this.tipoJornada = 'Diurna',
  });

  // Total de horas trabajadas en la semana
  double get totalHoras => horasPorDia.fold(0.0, (suma, h) => suma + h);

  // Sueldo semanal con bonificaciones
  double get sueldoSemanal {
    double sueldo = totalHoras * sueldoPorHora;
    if (tipoJornada == 'Nocturna') sueldo *= 1.15; // +15% jornada nocturna
    if (recibeBono) sueldo *= 1.10; // +10% bono
    return sueldo;
  }
}
