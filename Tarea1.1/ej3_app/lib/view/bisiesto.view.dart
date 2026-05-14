import 'package:flutter/material.dart';
import '../controller/bisiesto.controller.dart';

// --- ÁTOMOS
class LabelText extends StatelessWidget {
  final String text;
  const LabelText(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold));
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const PrimaryButton({super.key, required this.text, required this.onPressed});
  @override
  Widget build(BuildContext context) => ElevatedButton(onPressed: onPressed, child: Text(text));
}

// --- ORGANISMO: LA CARD DE CÁLCULO ---
class BisiestoCard extends StatefulWidget {
  const BisiestoCard({super.key});

  @override
  State<BisiestoCard> createState() => _BisiestoCardState();
}

class _BisiestoCardState extends State<BisiestoCard> {
  final _ctrlAnio = TextEditingController();
  final _controller = BisiestoController();
  String _resultado = '';

  void _comprobar() {
    setState(() {
      _resultado = _controller.verificarAnio(_ctrlAnio.text);
    });
  }

  @override
  void dispose() {
    _ctrlAnio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LabelText("Comprobar Año Bisiesto"),
          const SizedBox(height: 20),
          TextField(
            controller: _ctrlAnio,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Ingrese el año",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(text: "Verificar", onPressed: _comprobar),
          const SizedBox(height: 20),
          Text(
            _resultado,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// --- PÁGINA ---
class BisiestoPage extends StatelessWidget {
  const BisiestoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detector de Bisiestos")),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: BisiestoCard()),
      ),
    );
  }
}