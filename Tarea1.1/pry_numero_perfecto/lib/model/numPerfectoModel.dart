class NumPerfectoModel {
	static Map<String, dynamic> analizarNumero(int n) {
		if (n <= 0) {
			return {'esPerfecto': false, 'divisores': <int>[], 'suma': 0};
		}

		final divisores = <int>[];

		if (n > 1) divisores.add(1);

		final limite = n ~/ 2; // simple y suficiente para números pequeños
		for (int i = 2; i <= limite; i++) {
			if (n % i == 0) divisores.add(i);
		}

		final suma = divisores.fold<int>(0, (sumaParcial, divisor) => sumaParcial + divisor);
		final esPerfecto = suma == n;

		return {'esPerfecto': esPerfecto, 'divisores': divisores, 'suma': suma};
	}
}

