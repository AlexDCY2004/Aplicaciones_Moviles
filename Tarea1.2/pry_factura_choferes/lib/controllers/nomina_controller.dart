import '../models/chofer_model.dart';

class NominaController {
  final List<ChoferModel> _choferes = [];

  List<ChoferModel> get choferes => List.unmodifiable(_choferes);
  int get totalRegistrados => _choferes.length;
  bool get puedeRegistrar => _choferes.length < 5;

  // Validar datos del chofer
  String? validarChofer(ChoferModel chofer) {
    if (chofer.nombre.trim().isEmpty) return 'El nombre es requerido';
    if (chofer.sueldoPorHora <= 0) return 'El sueldo debe ser mayor a 0';
    for (var h in chofer.horasPorDia) {
      if (h < 0 || h > 24) return 'Las horas deben estar entre 0 y 24';
    }
    return null;
  }

  // Registrar un chofer
  bool registrarChofer(ChoferModel chofer) {
    if (!puedeRegistrar) return false;
    _choferes.add(chofer);
    return true;
  }

  // Total que pagará la empresa
  double calcularTotalEmpresa() {
    return _choferes.fold(0.0, (suma, c) => suma + c.sueldoSemanal);
  }

  // Chofer que trabajó más horas el día lunes (índice 0)
  String choferMasHorasLunes() {
    if (_choferes.isEmpty) return 'Sin datos';
    ChoferModel mejor = _choferes[0];
    for (var c in _choferes) {
      if (c.horasPorDia[0] > mejor.horasPorDia[0]) mejor = c;
    }
    return '${mejor.nombre} (${mejor.horasPorDia[0].toStringAsFixed(1)} hrs)';
  }

  // Limpiar todos los registros
  void limpiar() => _choferes.clear();
}
