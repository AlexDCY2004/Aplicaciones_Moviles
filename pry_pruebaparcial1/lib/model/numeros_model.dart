class NumerosModel {
  /// Calcula las estadísticas requeridas a partir de una lista de 100 enteros.
  /// Retorna un mapa con los conteos y el promedio.
  static Map<String, dynamic> calcularEstadisticas(List<int> numeros) {
    final menos15 = numeros.where((n) => n < 15).length;
    final mas50 = numeros.where((n) => n > 50).length;
    final entre25y45 = numeros.where((n) => n >= 25 && n <= 45).length;
    final suma = numeros.fold<int>(0, (a, b) => a + b);
    final promedio = numeros.isEmpty ? 0.0 : suma / numeros.length;

    return {
      'menos15': menos15,
      'mas50': mas50,
      'entre25y45': entre25y45,
      'promedio': promedio,
    };
  }
}