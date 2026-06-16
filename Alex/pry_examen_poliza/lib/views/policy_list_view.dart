import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/policy_view_model.dart';
//import '../models/policy_model.dart';
import 'policy_form_view.dart';

class PolicyListView extends StatelessWidget {
  const PolicyListView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<PolicyViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pólizas de Seguro'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => viewModel.fetchPolicies(),
          )
        ],
      ),
      body: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.policies.isEmpty
              ? const Center(child: Text('No hay pólizas registradas.'))
              : ListView.builder(
                  itemCount: viewModel.policies.length,
                  itemBuilder: (context, index) {
                    final policy = viewModel.policies[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      elevation: 4,
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.shield, color: Colors.white),
                        ),
                        title: Text(
                          policy.client,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Código: ${policy.code}'),
                            Text('Tipo: ${policy.insuranceType}'),
                            Text('Valor: \$${policy.insuredValue.toStringAsFixed(2)}'),
                            Text('Vence: ${policy.endDate.toString().split(' ')[0]}'),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Botón de Editar
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PolicyFormView(policy: policy),
                                  ),
                                );
                              },
                            ),
                            // Botón de Eliminar
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                if (policy.id != null) {
                                  viewModel.deletePolicy(policy.id!);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}