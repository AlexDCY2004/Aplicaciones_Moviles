import '../model/numeros_model.dart';

class NumerosController {
  /// Procesa el texto de entrada (números separados por espacios/comas/;)
  /// Valida y retorna un string listo para mostrar en la vista.
  String procesarNumeros(String input) {
    if (input.trim().isEmpty) {
      return 'Por favor ingrese los 100 números naturales.';
    }

    final tokens = input.split(RegExp(r'[\s,;]+')).map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    if (tokens.length != 100) {
      return 'Se requieren exactamente 100 números. Encontrados: ${tokens.length}.';
    }

    final numeros = <int>[];
    for (final t in tokens) {
      final n = int.tryParse(t);
      if (n == null) return 'Solo admite numeros naturales: "$t"';
      if (n < 0) return 'Se requieren números naturales (>= 0). Valor inválido: $n';
      numeros.add(n);
    }

    final stats = NumerosModel.calcularEstadisticas(numeros);

    return 'Menores que 15: ${stats['menos15']}\n'
        'Mayores que 50: ${stats['mas50']}\n'
        'Entre 25 y 45: ${stats['entre25y45']}\n'
        'Promedio: ${ (stats['promedio'] as double).toStringAsFixed(2) }';
  }
}
