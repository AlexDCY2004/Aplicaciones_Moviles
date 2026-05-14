import 'package:flutter/material.dart';
import '../controller/num_perfecto_controller.dart';

class NumberField extends StatelessWidget {
	final TextEditingController controller;
	final String hint;
	const NumberField({super.key, required this.controller, required this.hint});

	@override
	Widget build(BuildContext context) => TextField(
				controller: controller,
				keyboardType: TextInputType.number,
				decoration: InputDecoration(labelText: hint, border: OutlineInputBorder()),
			);
}

class PrimaryButton extends StatelessWidget {
	final String text;
	final VoidCallback onPressed;
	const PrimaryButton({super.key, required this.text, required this.onPressed});

	@override
	Widget build(BuildContext context) => ElevatedButton(onPressed: onPressed, child: Text(text));
}

class ResultText extends StatelessWidget {
	final String text;
	const ResultText({super.key, required this.text});

	@override
	Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
}

class NumPerfectoCard extends StatefulWidget {
	const NumPerfectoCard({super.key});

	@override
	State<NumPerfectoCard> createState() => _NumPerfectoCardState();
}

class _NumPerfectoCardState extends State<NumPerfectoCard> {
	final _numController = TextEditingController();
	final _controller = NumPerfectoController();
	String _resultado = '';

	void _calcular() {
		setState(() {
			_resultado = _controller.procesarNumero(_numController.text);
		});
	}

	@override
	Widget build(BuildContext context) {
		return Card(
			margin: const EdgeInsets.symmetric(vertical: 10),
			child: Padding(
				padding: const EdgeInsets.all(16),
				child: Column(
					children: [
						const Text('Ingrese un número entero positivo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
						const SizedBox(height: 10),
						NumberField(controller: _numController, hint: 'Número N'),
						const SizedBox(height: 10),
						PrimaryButton(text: 'Verificar', onPressed: _calcular),
						const SizedBox(height: 12),
						ResultText(text: _resultado),
					],
				),
			),
		);
	}
}

class NumPerfectoPage extends StatelessWidget {
	const NumPerfectoPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Número Perfecto')),
			body: const Padding(padding: EdgeInsets.all(16), child: NumPerfectoCard()),
		);
	}
}

