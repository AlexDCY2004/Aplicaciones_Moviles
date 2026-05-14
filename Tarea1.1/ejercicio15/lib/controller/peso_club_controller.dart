import '../model/peso_club_model.dart';

class PesoClubViewData {
  final bool esValido;
  final String mensaje;
  final List<PesoPersonaResultado> resultados;

  const PesoClubViewData({
    required this.esValido,
    required this.mensaje,
    required this.resultados,
  });
}

class PesoClubController {
  static const int basculasPorPersona = 10;
  final PesoClubModel _model = PesoClubModel();

  PesoClubViewData calcularPesoPersona({
    required String nombre,
    required String pesoAnteriorStr,
    required List<String> pesosBasculas,
  }) {
    final pesoAnterior = _parseDouble(pesoAnteriorStr);
    if (pesoAnterior == null || pesoAnterior <= 0) {
      return _error('Peso anterior no valido para $nombre.');
    }

    if (pesosBasculas.length != basculasPorPersona) {
      return _error('Se requieren $basculasPorPersona basculas.');
    }

    final pesos = <double>[];
    for (int j = 0; j < pesosBasculas.length; j++) {
      final peso = _parseDouble(pesosBasculas[j]);
      if (peso == null || peso <= 0) {
        final indice = j + 1;
        return _error('Bascula $indice no valida.');
      }
      pesos.add(peso);
    }

    final input = PesoPersonaInput(
      nombre: nombre,
      pesoAnterior: pesoAnterior,
      pesos: pesos,
    );

    final resultados = _model.calcular([input]);
    return PesoClubViewData(
      esValido: true,
      mensaje: 'Calculado correctamente.',
      resultados: resultados,
    );
  }

  PesoClubViewData calcularPesoClub({
    required List<String> nombres,
    required List<String> pesosAnteriores,
    required List<List<String>> pesosBasculas,
  }) {
    if (nombres.length != pesosAnteriores.length ||
        nombres.length != pesosBasculas.length) {
      return _error('Datos incompletos para las personas.');
    }

    final personas = <PesoPersonaInput>[];

    for (int i = 0; i < nombres.length; i++) {
      final nombre = nombres[i];
      final pesoAnterior = _parseDouble(pesosAnteriores[i]);
      if (pesoAnterior == null || pesoAnterior <= 0) {
        return _error('Peso anterior no valido para $nombre.');
      }

      final pesosTexto = pesosBasculas[i];
      if (pesosTexto.length != basculasPorPersona) {
        return _error('Se requieren $basculasPorPersona basculas para $nombre.');
      }

      final pesos = <double>[];
      for (int j = 0; j < pesosTexto.length; j++) {
        final peso = _parseDouble(pesosTexto[j]);
        if (peso == null || peso <= 0) {
          final indice = j + 1;
          return _error('Bascula $indice no valida para $nombre.');
        }
        pesos.add(peso);
      }

      personas.add(
        PesoPersonaInput(
          nombre: nombre,
          pesoAnterior: pesoAnterior,
          pesos: pesos,
        ),
      );
    }

    final resultados = _model.calcular(personas);
    return PesoClubViewData(
      esValido: true,
      mensaje: 'Resultados calculados correctamente.',
      resultados: resultados,
    );
  }

  static String formatKg(double value) {
    return '${value.toStringAsFixed(2)} kg';
  }

  PesoClubViewData _error(String mensaje) {
    return PesoClubViewData(
      esValido: false,
      mensaje: mensaje,
      resultados: const [],
    );
  }

  double? _parseDouble(String input) {
    final cleaned = input.trim().replaceAll(',', '.');
    if (cleaned.isEmpty) {
      return null;
    }
    return double.tryParse(cleaned);
  }
}
