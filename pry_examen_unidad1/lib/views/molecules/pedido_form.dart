import 'package:flutter/material.dart';
import '../../models/pedido_cafe_model.dart';
import '../../controllers/cafe_controller.dart';
import '../../services/sales_repository.dart';
import '../atoms/cliente_text_field.dart';
import '../atoms/cantidad_text_field.dart';
import '../atoms/product_dropdown.dart';
import '../atoms/size_dropdown.dart';
import '../atoms/primary_button.dart';

class PedidoForm extends StatefulWidget {
  final void Function(PedidoCafeModelo) onPedidoProcesado;

  const PedidoForm({Key? key, required this.onPedidoProcesado}) : super(key: key);

  @override
  State<PedidoForm> createState() => _PedidoFormState();
}

class _PedidoFormState extends State<PedidoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _cantidadCtrl = TextEditingController(text: '1');
  String _producto = 'Café';
  String _tamano = 'Pequeño';

  final CafeController _controller = CafeController();

  void _submit() {
    // Validar por campo usando los validadores del controller (muestran errores en rojo bajo cada label)
    if (!_formKey.currentState!.validate()) return;
    final cantidadParsed = int.parse(_cantidadCtrl.text.trim());
    final pedido = PedidoCafeModelo(
      nombreCliente: _nombreCtrl.text.trim(),
      producto: _producto,
      tamano: _tamano,
      cantidad: cantidadParsed,
    );
    try {
      final procesado = _controller.procesarPedido(pedido);
      // Guardar en historial
      SalesRepository.instance.add(procesado);
      widget.onPedidoProcesado(procesado);
    } catch (e) {
      // Mostrar solo el mensaje legible del ArgumentError (sin prefijo técnico)
      String msg;
      if (e is ArgumentError) {
        msg = e.message?.toString() ?? 'Error en la validación';
      } else {
        msg = e.toString();
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClienteTextField(controller: _nombreCtrl, validator: (v) => _controller.validarNombreField(v)),
          const SizedBox(height: 12),
          ProductDropdown(value: _producto, onChanged: (v) => setState(() => _producto = v ?? 'Café'), validator: (v) => _controller.validarProductoField(v)),
          const SizedBox(height: 12),
          SizeDropdown(value: _tamano, onChanged: (v) => setState(() => _tamano = v ?? 'Pequeño'), validator: (v) => _controller.validarTamanoField(v)),
          const SizedBox(height: 8),
          // Mostrar precio unitario actual con unidad de medida
          Builder(builder: (context) {
            final unit = _controller.precioUnitario(_producto, _tamano);
            return Text('Precio unitario: \$${unit.toStringAsFixed(2)} (USD)', style: const TextStyle(fontSize: 14));
          }),
          const SizedBox(height: 12),
          CantidadTextField(controller: _cantidadCtrl, validator: (v) => _controller.validarCantidadField(v)),
          const SizedBox(height: 16),
          PrimaryButton(label: 'Vender', onPressed: _submit),
        ],
      ),
    );
  }
}
