import 'package:flutter/material.dart';

import '../controller/cajero_controller.dart';

class CajeroHomeView extends StatefulWidget {
  const CajeroHomeView({super.key});

  @override
  State<CajeroHomeView> createState() => _CajeroHomeViewState();
}

class _CajeroHomeViewState extends State<CajeroHomeView> {
  final CajeroController _ctrl = CajeroController();
  String _message = '';

  Future<void> _goToCompra() async {
    final msg = _ctrl.iniciarNuevaVenta();
    if (_ctrl.esCajaCerrada()) {
      setState(() => _message = msg);
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      '/compra',
      arguments: _ctrl,
    );

    if (!mounted) return;
    if (result is String && result.isNotEmpty) {
      setState(() => _message = result);
    }
  }

  Future<void> _goToHistorial() async {
    await Navigator.pushNamed(
      context,
      '/historial',
      arguments: _ctrl,
    );
    if (!mounted) return;
    setState(() {});
  }

  void _finishDia() {
    setState(() => _message = _ctrl.finalizarDia());
  }

  void _startNewDay() {
    setState(() => _message = _ctrl.iniciarNuevoDia());
  }

  @override
  Widget build(BuildContext context) {
    final closed = _ctrl.esCajaCerrada();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Compras'),
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
                      children: [
                        const Text(
                          'Bienvenido cajero',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (!closed) ...[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.amber[700],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 60),
                            ),
                            onPressed: _goToCompra,
                            child: const Text('Iniciar nueva venta'),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (!closed) ...[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 60),
                            ),
                            onPressed: _finishDia,
                            child: const Text('Finalizar dia'),
                          ),
                          const SizedBox(height: 10),
                        ],
                        if (closed) ...[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 60),
                            ),
                            onPressed: _startNewDay,
                            child: const Text('Iniciar nuevo dia'),
                          ),
                          const SizedBox(height: 10),
                        ],
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 168, 168, 168),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 60),
                          ),
                          onPressed: _goToHistorial,
                          child: const Text('Historial de ventas'),
                        ),
                        const SizedBox(height: 16),
                        if (_message.isNotEmpty) ...[
                          Text(
                            _message,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          'Total del dia: \$${_ctrl.obtenerTotalDelDia().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Dia ${_ctrl.obtenerNumeroDia()}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (closed) const SizedBox(height: 8),
                        if (closed)
                          const Text(
                            'La caja esta cerrada.',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
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
