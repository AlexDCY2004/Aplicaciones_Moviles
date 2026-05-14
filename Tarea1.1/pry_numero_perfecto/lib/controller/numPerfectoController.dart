import '../model/numPerfectoModel.dart';

class NumPerfectoController {
	String procesarNumero(String s) {
		if (s.isEmpty) return 'Por favor ingrese un número';

		final n = int.tryParse(s);
		if (n == null) return 'Por favor ingrese un número entero válido';
		if (n <= 0) return 'Ingrese un entero positivo';

		final r = NumPerfectoModel.analizarNumero(n);
		final bool esPerfecto = r['esPerfecto'] as bool;
		final List<int> divisores = List<int>.from(r['divisores'] as List);
		final int suma = r['suma'] as int;

		if (esPerfecto) {
			return 'El número $n es PERFECTO. Divisores: ${divisores.join(', ')} (suma $suma)';
		} else {
			return 'El número $n no es perfecto. Divisores: ${divisores.join(', ')} (suma $suma)';
		}
	}
}

