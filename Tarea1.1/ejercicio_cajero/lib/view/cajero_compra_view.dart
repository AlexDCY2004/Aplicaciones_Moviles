import 'package:flutter/material.dart';

import '../controller/cajero_controller.dart';

class CajeroCompraView extends StatefulWidget {
  const CajeroCompraView({super.key});

  @override
  State<CajeroCompraView> createState() => _CajeroCompraViewState();
}

class _CajeroCompraViewState extends State<CajeroCompraView> {
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _cantidadController = TextEditingController();

  String _message = '';

  CajeroController get _ctrl {
    final args = ModalRoute.of(context)?.settings.arguments;
    return args as CajeroController;
  }

  void _addProducto() {
    final precio = double.tryParse(_precioController.text) ?? -1;
    final cantidad = int.tryParse(_cantidadController.text) ?? -1;
    final msg = _ctrl.agregarArticulo(precio, cantidad);

    if (msg.startsWith('Articulo anadido') || msg.startsWith('Artículo añadido')) {
      _precioController.clear();
      _cantidadController.clear();
    }

    setState(() => _message = msg);
  }

  void _finishCompra() {
    final msg = _ctrl.finalizarVenta();
    setState(() => _message = msg);
  }

  void _startAnotherCompra() {
    final msg = _ctrl.iniciarNuevaVenta();
    setState(() => _message = msg);
  }

  void _goBack() {
    _ctrl.cancelarVenta();
    Navigator.pop(context, _message);
  }

  @override
  void dispose() {
    _precioController.dispose();
    _cantidadController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venta = _ctrl.obtenerVentaActual();
    final articulos = venta?.articulos ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva venta'),
        backgroundColor: Colors.red[700],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const SizedBox(height: 18),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  color: Colors.red[50],
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Nueva venta',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _precioController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(
                            labelText: 'Precio unitario',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _cantidadController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: false),
                          decoration: const InputDecoration(
                            labelText: 'Cantidad',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (!_ctrl.ventaFinalizada())
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.yellow[800],
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: _addProducto,
                                  child: const Text('Agregar articulo'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[700],
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: _finishCompra,
                                  child: const Text('Finalizar venta'),
                                ),
                              ),
                            ],
                          )
                        else
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _startAnotherCompra,
                            child: const Text('Iniciar nueva venta'),
                          ),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _goBack,
                          child: const Text('Regresar'),
                        ),
                        if (_message.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            _message,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  color: Colors.yellow[50],
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Articulos anadidos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 160,
                          child: (venta == null || venta.articulos.isEmpty)
                              ? const Center(child: Text('No hay articulos aun'))
                              : (_ctrl.ventaFinalizada()
                                  ? Center(
                                      child: Text(
                                        'Total de la venta: \$${venta.total.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: articulos.length,
                                      itemBuilder: (context, i) {
                                        final art = articulos[i];
                                        return ListTile(
                                          title: Text(
                                            'Precio: \$${art.precioUnitario.toStringAsFixed(2)} x ${art.cantidad}',
                                          ),
                                          trailing: Text('\$${art.total.toStringAsFixed(2)}'),
                                        );
                                      },
                                    )),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Subtotal: \$${venta?.total.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
