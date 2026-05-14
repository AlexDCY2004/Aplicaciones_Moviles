import '../models/modelos.dart';

class AjusteController {
  final List<Ajuste> _descuentos = [];
  final List<Ajuste> _recargos = [];

  AjusteController() {
    _inicializarAjustesPorDefecto();
  }

  void _inicializarAjustesPorDefecto() {
    _descuentos.add(Ajuste(id: 'd_pronto', nombre: 'Pronto pago', monto: 5.0, esPorcentaje: true));
    _recargos.add(Ajuste(id: 'r_mora', nombre: 'Mora', monto: 10.0, esPorcentaje: true));
  }

  List<Ajuste> obtenerDescuentos() => List.unmodifiable(_descuentos);
  List<Ajuste> obtenerRecargos() => List.unmodifiable(_recargos);

  Ajuste? buscarPorId(String id) {
    try {
      return _descuentos.firstWhere((a) => a.id == id);
    } catch (_) {
      try {
        return _recargos.firstWhere((a) => a.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  bool esDescuento(String id) => _descuentos.any((a) => a.id == id);
  bool esRecargo(String id) => _recargos.any((a) => a.id == id);
}
