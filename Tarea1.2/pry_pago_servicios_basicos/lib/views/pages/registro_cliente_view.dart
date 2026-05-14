import 'package:flutter/material.dart';
import '../molecules/formulario_cliente_molecule.dart';
import '../../controllers/controllers.dart';
import '../../controllers/singletons.dart';
import '../../models/cliente_model.dart';

final ClienteController _clienteController = clienteControllerSingleton;

class RegistroClienteView extends StatelessWidget {
  const RegistroClienteView({super.key});

  void _guardarCliente(BuildContext context, String nombre, String direccion, String telefono, String correo) {
    final cliente = Cliente(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre,
      direccion: direccion,
      telefono: telefono,
      correo: correo,
    );
    _clienteController.agregarCliente(cliente);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cliente guardado')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar cliente')),
      body: Padding(padding: const EdgeInsets.all(16), child: FormularioClienteMolecule(onGuardar: (n, d, t, c) => _guardarCliente(context, n, d, t, c))),
    );
  }
}
