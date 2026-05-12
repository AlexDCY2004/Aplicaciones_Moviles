import 'package:flutter/material.dart';
import 'package:pry_pago_servicios_basicos/widgets/client_card.dart';
import '../../controllers/singletons.dart';

class ClientesListView extends StatelessWidget {
  const ClientesListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final clientes = clienteControllerSingleton.obtenerClientes();
    return Scaffold(
      appBar: AppBar(title: const Text('Clientes registrados')),
      body: clientes.isEmpty
          ? const Center(child: Text('No hay clientes registrados'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: clientes.length,
              itemBuilder: (c, i) {
                final cl = clientes[i];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ClientCard(
                    nombre: cl.nombre,
                    direccion: cl.direccion ?? '',
                    telefono: cl.telefono ?? '',
                    email: cl.correo ?? '',
                  ),
                );
              },
            ),
    );
  }
}
