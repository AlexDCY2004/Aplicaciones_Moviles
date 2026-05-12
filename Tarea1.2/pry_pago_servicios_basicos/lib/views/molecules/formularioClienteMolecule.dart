import 'package:flutter/material.dart';
import '../../controllers/singletons.dart';
import '../atoms/etiquetaAtom.dart';

class FormularioClienteMolecule extends StatefulWidget {
  final void Function(String nombre, String direccion, String telefono, String correo) onGuardar;

  const FormularioClienteMolecule({Key? key, required this.onGuardar}) : super(key: key);

  @override
  State<FormularioClienteMolecule> createState() => _FormularioClienteMoleculeState();
}

class _FormularioClienteMoleculeState extends State<FormularioClienteMolecule> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final direccionCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();
  final correoCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const EtiquetaAtom(texto: 'Nombre'),
          TextFormField(
            controller: nombreCtrl,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Nombre completo'),
            validator: (v) => clienteControllerSingleton.validarNombre(v),
          ),
          const SizedBox(height: 8),
          const EtiquetaAtom(texto: 'Dirección'),
          TextFormField(
            controller: direccionCtrl,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Dirección'),
            validator: (v) => clienteControllerSingleton.validarDireccion(v),
          ),
          const SizedBox(height: 8),
          const EtiquetaAtom(texto: 'Teléfono'),
          TextFormField(
            controller: telefonoCtrl,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Teléfono'),
            validator: (v) => clienteControllerSingleton.validarTelefono(v),
          ),
          const SizedBox(height: 8),
          const EtiquetaAtom(texto: 'Correo'),
          TextFormField(
            controller: correoCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'correo@ejemplo.com'),
            validator: (v) => clienteControllerSingleton.validarCorreo(v),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              final valid = _formKey.currentState?.validate() ?? false;
              if (valid) {
                widget.onGuardar(nombreCtrl.text.trim(), direccionCtrl.text.trim(), telefonoCtrl.text.trim(), correoCtrl.text.trim());
              } else {
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
