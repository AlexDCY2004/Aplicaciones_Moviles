import 'package:flutter/material.dart';
import '../controller/numeros_controller.dart';

class Label extends StatelessWidget {
  final String text;
  const Label(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold));
}

class MultilineNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const MultilineNumberField({super.key, required this.controller, required this.hint});
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: 8,
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

class NumbersCard extends StatefulWidget {
  const NumbersCard({super.key});
  @override
  State<NumbersCard> createState() => _NumbersCardState();
}

class _NumbersCardState extends State<NumbersCard> {
  final _input = TextEditingController();
  final _controller = NumerosController();
  String _resultado = '';

  void _calcular() {
    setState(() {
      _resultado = _controller.procesarNumeros(_input.text);
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
            const Label('Ingrese 100 números naturales'),
            const SizedBox(height: 8),
            MultilineNumberField(controller: _input, hint: 'Separe por espacios, comas o ;'),
            const SizedBox(height: 10),
            PrimaryButton(text: 'Calcular', onPressed: _calcular),
            const SizedBox(height: 10),
            ResultText(text: _resultado),
          ],
        ),
      ),
    );
  }
}

class NumerosPage extends StatelessWidget {
  const NumerosPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ejercicio 17 - Numeros')),
      body: const Padding(padding: EdgeInsets.all(16), child: NumbersCard()),
    );
  }
}
