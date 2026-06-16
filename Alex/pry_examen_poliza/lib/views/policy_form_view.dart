import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/policy_model.dart';
import '../view_models/policy_view_model.dart';

class PolicyFormView extends StatefulWidget {
  final Policy? policy; // Si es nulo crea, si tiene datos edita

  const PolicyFormView({super.key, this.policy});

  @override
  State<PolicyFormView> createState() => _PolicyFormViewState();
}

class _PolicyFormViewState extends State<PolicyFormView> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _codeController;
  late TextEditingController _clientController;
  late TextEditingController _typeController;
  late TextEditingController _valueController;
  
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 365));

  @override
  void initState() {
    super.initState();
    // Si estamos editando, precargamos los controladores con los datos existentes
    _codeController = TextEditingController(text: widget.policy?.code ?? '');
    _clientController = TextEditingController(text: widget.policy?.client ?? '');
    _typeController = TextEditingController(text: widget.policy?.insuranceType ?? '');
    _valueController = TextEditingController(text: widget.policy?.insuredValue.toString() ?? '');
    if (widget.policy != null) {
      _startDate = widget.policy!.startDate;
      _endDate = widget.policy!.endDate;
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _clientController.dispose();
    _typeController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final viewModel = Provider.of<PolicyViewModel>(context, listen: false);
      
      final newPolicy = Policy(
        id: widget.policy?.id,
        code: _codeController.text,
        client: _clientController.text,
        insuranceType: _typeController.text,
        startDate: _startDate,
        endDate: _endDate,
        insuredValue: double.parse(_valueController.text),
      );

      if (widget.policy == null) {
        // Guardar nuevo
        await viewModel.addPolicy(newPolicy);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Póliza registrada con éxito')),
        );
        _formKey.currentState!.reset();
      } else {
        // Actualizar existente
        await viewModel.updatePolicy(widget.policy!.id!, newPolicy);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Póliza actualizada con éxito')),
        );
        Navigator.pop(context); // Regresa a la lista después de editar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.policy != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Póliza' : 'Nueva Póliza de Seguro'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(labelText: 'Código de Póliza', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientController,
                decoration: const InputDecoration(labelText: 'Nombre del Cliente', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Tipo de Seguro (Vida, Auto, etc.)', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Campo requerido' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(labelText: 'Valor Asegurado (\$)', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) => double.tryParse(value ?? '') == null ? 'Ingrese un número válido' : null,
              ),
              const SizedBox(height: 16),
              
              // Selectores de Fechas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Inicio: ${_startDate.toString().split(' ')[0]}"),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, true),
                    child: const Text('Elegir Fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Vencimiento: ${_endDate.toString().split(' ')[0]}"),
                  ElevatedButton(
                    onPressed: () => _selectDate(context, false),
                    child: const Text('Elegir Fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Botón de guardar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent, foregroundColor: Colors.white),
                  onPressed: _saveForm,
                  child: Text(isEditing ? 'ACTUALIZAR PÓLIZA' : 'REGISTRAR PÓLIZA'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}