import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../controllers/singletons.dart';
import '../atoms/etiqueta_atom.dart';

class FormularioClienteMolecule extends StatefulWidget {
  final void Function(String nombre, String direccion, String telefono, String correo) onGuardar;

  const FormularioClienteMolecule({super.key, required this.onGuardar});
  @override
  State<FormularioClienteMolecule> createState() => _FormularioClienteMoleculeState();
}

class _FormularioClienteMoleculeState extends State<FormularioClienteMolecule> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final correoCtrl = TextEditingController();
  AutovalidateMode _autoMode = AutovalidateMode.disabled;
  bool _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autoMode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EtiquetaAtom(texto: 'Nombre'),
          TextFormField(
            controller: nombreCtrl,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Nombre completo'),
            onChanged: (_) {
              if (_autoMode == AutovalidateMode.disabled) setState(() => _autoMode = AutovalidateMode.onUserInteraction);
            },
            validator: (v) {
              if (!_submitted && (v == null || v.trim().isEmpty)) return null;
              return clienteControllerSingleton.validarNombre(v);
            },
          ),
          const SizedBox(height: 8),
          const EtiquetaAtom(texto: 'Dirección'),
          TextFormField(
            controller: direccionCtrl,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Dirección'),
            onChanged: (_) {
              if (_autoMode == AutovalidateMode.disabled) setState(() => _autoMode = AutovalidateMode.onUserInteraction);
            },
            validator: (v) {
              if (!_submitted && (v == null || v.trim().isEmpty)) return null;
              return clienteControllerSingleton.validarDireccion(v);
            },
          ),
          const SizedBox(height: 8),
          const EtiquetaAtom(texto: 'Teléfono'),
          TextFormField(
            controller: telefonoCtrl,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Teléfono (9-10 dígitos)'),
            onChanged: (_) {
              if (_autoMode == AutovalidateMode.disabled) setState(() => _autoMode = AutovalidateMode.onUserInteraction);
            },
            validator: (v) {
              if (!_submitted && (v == null || v.trim().isEmpty)) return null;
              return clienteControllerSingleton.validarTelefono(v);
            },
          ),
          const SizedBox(height: 8),
          const EtiquetaAtom(texto: 'Correo'),
          TextFormField(
            controller: correoCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'correo@ejemplo.com'),
            onChanged: (_) {
              if (_autoMode == AutovalidateMode.disabled) setState(() => _autoMode = AutovalidateMode.onUserInteraction);
            },
            validator: (v) {
              if (!_submitted && (v == null || v.trim().isEmpty)) return null;
              return clienteControllerSingleton.validarCorreo(v);
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              setState(() => _submitted = true);
              final valid = _formKey.currentState?.validate() ?? false;
              if (valid) {
                widget.onGuardar(nombreCtrl.text.trim(), direccionCtrl.text.trim(), telefonoCtrl.text.trim(), correoCtrl.text.trim());
              } else {
                setState(() => _autoMode = AutovalidateMode.always);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Corrige los errores del formulario')));
              }
            },
            child: const Text('Guardar cliente'),
          )
        ],
      ),
    );
  }
}
