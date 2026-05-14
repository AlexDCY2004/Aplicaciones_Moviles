import '../model/bisiesto.model.dart';

class BisiestoController {
  String verificarAnio(String input) {
    int? anio = int.tryParse(input);

    if (anio == null) {
      return "Por favor, ingresa un número válido.";
    }

    if (anio < 0) {
      return "El año no puede ser negativo.";
    }

    bool resultado = BisiestoModel.esBisiesto(anio);

    return resultado
        ? "El año $anio ES bisiesto (tiene 366 días)."
        : "El año $anio NO es bisiesto (tiene 365 días).";
  }
}