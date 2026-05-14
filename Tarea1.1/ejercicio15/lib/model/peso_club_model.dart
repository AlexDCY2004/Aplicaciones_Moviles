class PesoPersonaInput {
  final String nombre;
  final double pesoAnterior;
  final List<double> pesos;

  const PesoPersonaInput({
    required this.nombre,
    required this.pesoAnterior,
    required this.pesos,
  });
}

class PesoPersonaResultado {
  final String nombre;
  final double pesoAnterior;
  final double promedio;
  final double diferencia;
  final bool subio;

  const PesoPersonaResultado({
    required this.nombre,
    required this.pesoAnterior,
    required this.promedio,
    required this.diferencia,
    required this.subio,
  });
}

class PesoClubModel {
  List<PesoPersonaResultado> calcular(List<PesoPersonaInput> personas) {
    final resultados = <PesoPersonaResultado>[];

    for (final persona in personas) {
      final suma = persona.pesos.fold<double>(0, (acc, item) => acc + item);
      final promedio = suma / persona.pesos.length;
      final diferencia = promedio - persona.pesoAnterior;

      resultados.add(
        PesoPersonaResultado(
          nombre: persona.nombre,
          pesoAnterior: persona.pesoAnterior,
          promedio: promedio,
          diferencia: diferencia,
          subio: diferencia > 0,
        ),
      );
    }

    return resultados;
  }
}
