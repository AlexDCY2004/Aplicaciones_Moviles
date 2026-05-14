class CambioCalculo {
	final bool esPosible;
	final int cambioCents;
	final Map<int, int> monedas;

	const CambioCalculo({
		required this.esPosible,
		required this.cambioCents,
		required this.monedas,
	});
}

class MaquinaCambioModel {
	static const List<int> _monedas = [200, 100, 50, 25, 10];

	List<int> get monedasDisponibles => _monedas;

	CambioCalculo calcularCambio({
		required int precioCents,
		required int pagoCents,
	}) {
		if (pagoCents < precioCents) {
			return const CambioCalculo(
				esPosible: false,
				cambioCents: 0,
				monedas: <int, int>{},
			);
		}

		final cambio = pagoCents - precioCents;
		if (cambio == 0) {
			return const CambioCalculo(
				esPosible: true,
				cambioCents: 0,
				monedas: <int, int>{},
			);
		}

		// DP to handle non-canonical coin sets (e.g., 25 and 10).
		final max = cambio;
		const int inf = 1 << 30;
		final dp = List<int>.filled(max + 1, inf);
		final prev = List<int>.filled(max + 1, -1);
		dp[0] = 0;

		for (int amount = 1; amount <= max; amount++) {
			for (final coin in _monedas) {
				final prevAmount = amount - coin;
				if (prevAmount >= 0 && dp[prevAmount] + 1 < dp[amount]) {
					dp[amount] = dp[prevAmount] + 1;
					prev[amount] = coin;
				}
			}
		}

		if (dp[cambio] == inf) {
			return CambioCalculo(
				esPosible: false,
				cambioCents: cambio,
				monedas: const <int, int>{},
			);
		}

		final monedas = <int, int>{};
		int current = cambio;
		while (current > 0) {
			final coin = prev[current];
			if (coin == -1) {
				break;
			}
			monedas[coin] = (monedas[coin] ?? 0) + 1;
			current -= coin;
		}

		return CambioCalculo(
			esPosible: true,
			cambioCents: cambio,
			monedas: monedas,
		);
	}
}
