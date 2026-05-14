import 'package:flutter/material.dart';

import '../controller/maquina_cambio_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _precioController = TextEditingController();
  final _pagoController = TextEditingController();
  final _controller = MaquinaCambioController();
  
  final List<int> _productosCents = [];
  CambioViewData? _resultado;
  String _errorMessage = '';

  int get _totalCents => _productosCents.fold(0, (sum, item) => sum + item);

  void _agregarProducto() {
    final cents = _controller.parseToCents(_precioController.text);
    if (cents == null || cents <= 0) {
      setState(() {
        _errorMessage = 'Ingrese un precio válido para agregar.';
      });
      return;
    }

    setState(() {
      _productosCents.add(cents);
      _precioController.clear();
      _errorMessage = '';
      _resultado = null; // Reset result when list changes
    });
  }

  void _calcular() {
    final currentPrecioCents = _controller.parseToCents(_precioController.text) ?? 0;
    final totalAValidar = _totalCents + currentPrecioCents;

    if (totalAValidar == 0) {
      setState(() {
        _errorMessage = 'Debe ingresar al menos un producto.';
      });
      return;
    }

    final resultado = _controller.calcularCambioConTotal(
      totalAValidar,
      _pagoController.text,
    );

    setState(() {
      if (resultado.esValido) {
        _resultado = resultado;
        _errorMessage = '';
      } else {
        _resultado = null;
        _errorMessage = resultado.mensaje;
      }
    });
  }

  void _limpiar() {
    setState(() {
      _precioController.clear();
      _pagoController.clear();
      _productosCents.clear();
      _resultado = null;
      _errorMessage = '';
    });
  }

  @override
  void dispose() {
    _precioController.dispose();
    _pagoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateHome(
      child: OrganismCambioCard(
        precioController: _precioController,
        pagoController: _pagoController,
        errorMessage: _errorMessage,
        resultado: _resultado,
        productos: _productosCents,
        onCalcular: _calcular,
        onLimpiar: _limpiar,
        onAgregar: _agregarProducto,
      ),
    );
  }
}

// Templates
class TemplateHome extends StatelessWidget {
  final Widget child;

  const TemplateHome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maquina de Cambio'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFEAF6FF),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Organisms
class OrganismCambioCard extends StatelessWidget {
  final TextEditingController precioController;
  final TextEditingController pagoController;
  final String errorMessage;
  final CambioViewData? resultado;
  final List<int> productos;
  final VoidCallback onCalcular;
  final VoidCallback onLimpiar;
  final VoidCallback onAgregar;

  const OrganismCambioCard({
    super.key,
    required this.precioController,
    required this.pagoController,
    required this.errorMessage,
    required this.resultado,
    required this.productos,
    required this.onCalcular,
    required this.onLimpiar,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AtomTitle('Calcular vuelto'),
            const SizedBox(height: 8),
            const AtomBodyText(
              'Monedas: 2.00, 1.00, 0.50, 0.25, 0.10',
            ),
            const SizedBox(height: 12),
            MoleculePricePaidInputs(
              precioController: precioController,
              pagoController: pagoController,
              onAgregar: onAgregar,
            ),
            if (productos.isNotEmpty) ...[
              const SizedBox(height: 12),
              AtomSectionTitle('Productos agregados: ${productos.length}'),
              const SizedBox(height: 4),
              ...productos.map((p) => AtomBodyText('- ${MaquinaCambioController.formatCurrency(p)}')),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AtomPrimaryButton(
                    text: 'Calcular',
                    onPressed: onCalcular,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onLimpiar,
                    child: const Text('Limpiar'),
                  ),
                ),
              ],
            ),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              AtomErrorText(errorMessage),
            ],
            if (resultado != null) ...[
              const SizedBox(height: 14),
              MoleculeResultado(resumen: resultado!),
            ],
          ],
        ),
      ),
    );
  }
}

// Molecules
class MoleculePricePaidInputs extends StatelessWidget {
  final TextEditingController precioController;
  final TextEditingController pagoController;
  final VoidCallback onAgregar;

  const MoleculePricePaidInputs({
    super.key,
    required this.precioController,
    required this.pagoController,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AtomNumberField(
                controller: precioController,
                hint: 'Precio del articulo',
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: onAgregar,
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Agregar producto',
            ),
          ],
        ),
        const SizedBox(height: 10),
        AtomNumberField(
          controller: pagoController,
          hint: 'Pago del cliente',
        ),
      ],
    );
  }
}

class MoleculeResultado extends StatelessWidget {
  final CambioViewData resumen;

  const MoleculeResultado({super.key, required this.resumen});

  @override
  Widget build(BuildContext context) {
    final cambioLabel =
        MaquinaCambioController.formatCurrency(resumen.cambioCents);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AtomSectionTitle('Cambio total: $cambioLabel'),
        const SizedBox(height: 8),
        MoleculeCoinList(monedas: resumen.monedas),
      ],
    );
  }
}

class MoleculeCoinList extends StatelessWidget {
  final Map<int, int> monedas;

  const MoleculeCoinList({super.key, required this.monedas});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (final coin in MaquinaCambioController.monedasOrdenadas) {
      final count = monedas[coin] ?? 0;
      if (count > 0) {
        rows.add(
          AtomCoinRow(
            label: MaquinaCambioController.formatCurrency(coin),
            cantidad: count,
          ),
        );
        rows.add(const SizedBox(height: 6));
      }
    }

    if (rows.isEmpty) {
      return const AtomBodyText('No hay vuelto por entregar.');
    }

    rows.removeLast();
    return Column(children: rows);
  }
}

// Atoms
class AtomTitle extends StatelessWidget {
  final String text;

  const AtomTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }
}

class AtomSectionTitle extends StatelessWidget {
  final String text;

  const AtomSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class AtomBodyText extends StatelessWidget {
  final String text;

  const AtomBodyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class AtomErrorText extends StatelessWidget {
  final String text;

  const AtomErrorText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFB00020),
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class AtomNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;

  const AtomNumberField({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: hint,
      ),
    );
  }
}

class AtomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AtomPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class AtomCoinRow extends StatelessWidget {
  final String label;
  final int cantidad;

  const AtomCoinRow({
    super.key,
    required this.label,
    required this.cantidad,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text('x$cantidad'),
      ],
    );
  }
}
