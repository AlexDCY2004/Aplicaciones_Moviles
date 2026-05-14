import '../model/maquina_cambio_model.dart';

class CambioViewData {
	final bool esValido;
	final String mensaje;
	final int precioCents;
	final int pagoCents;
	final int cambioCents;
	final Map<int, int> monedas;

	const CambioViewData({
		required this.esValido,
		required this.mensaje,
		required this.precioCents,
		required this.pagoCents,
		required this.cambioCents,
		required this.monedas,
	});
}

class MaquinaCambioController {
	static const List<int> monedasOrdenadas = [200, 100, 50, 25, 10];
	final MaquinaCambioModel _model = MaquinaCambioModel();

	CambioViewData calcularCambio(String precioText, String pagoText) {
		final precioCents = parseToCents(precioText);
		if (precioCents == null) {
			return _error('Precio no valido.');
		}
		return calcularCambioConTotal(precioCents, pagoText);
	}

	CambioViewData calcularCambioConTotal(int totalCents, String pagoText) {
		if (!_esMultiploDeCinco(totalCents)) {
			return _error('El total debe ser multiplo de 0.05.');
		}

		final pagoCents = parseToCents(pagoText);
		if (pagoCents == null) {
			return _error('Pago no valido.');
		}
		if (!_esMultiploDeCinco(pagoCents)) {
			return _error('El pago debe ser multiplo de 0.05.');
		}

		if (totalCents <= 0) {
			return _error('El total debe ser mayor a 0.');
		}
		if (pagoCents <= 0) {
			return _error('El pago debe ser mayor a 0.');
		}

		if (pagoCents < totalCents) {
			return _error('El pago es menor al total.');
		}

		final resultado = _model.calcularCambio(
			precioCents: totalCents,
			pagoCents: pagoCents,
		);

		if (!resultado.esPosible) {
			return _error(
				'No es posible dar cambio exacto con las monedas disponibles.',
			);
		}

		return CambioViewData(
			esValido: true,
			mensaje: 'Cambio calculado correctamente.',
			precioCents: totalCents,
			pagoCents: pagoCents,
			cambioCents: resultado.cambioCents,
			monedas: resultado.monedas,
		);
	}

	static String formatCurrency(int cents) {
		final value = cents / 100.0;
		return '\$${value.toStringAsFixed(2)}';
	}

	CambioViewData _error(String mensaje) {
		return CambioViewData(
			esValido: false,
			mensaje: mensaje,
			precioCents: 0,
			pagoCents: 0,
			cambioCents: 0,
			monedas: const <int, int>{},
		);
	}

	int? parseToCents(String input) {
		final cleaned = input.trim().replaceAll(',', '.');
		if (cleaned.isEmpty) {
			return null;
		}
		final parsed = double.tryParse(cleaned);
		if (parsed == null) {
			return null;
		}
		return (parsed * 100).round();
	}

	bool _esMultiploDeCinco(int cents) => cents % 5 == 0;
}
