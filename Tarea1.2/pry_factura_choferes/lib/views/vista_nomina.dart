import 'package:flutter/material.dart';
import '../controllers/nomina_controller.dart';
import '../models/chofer_model.dart';
import '../widgets/atomos/boton_personalizado.dart';
import '../widgets/atomos/campos_texto_personalizado.dart';
import '../widgets/atomos/checkbox_personalizado.dart';
import '../widgets/atomos/radiobutton_personalizado.dart';
import '../widgets/moleculas/grupo_horas.dart';

class VistaNomina extends StatefulWidget {
  const VistaNomina({super.key});

  @override
  State<VistaNomina> createState() => _VistaNominaState();
}

class _VistaNominaState extends State<VistaNomina> {
  final NominaController _controller = NominaController();
  final _formKey = GlobalKey<FormState>();

  final _nombreCtrl = TextEditingController();
  final _sueldoCtrl = TextEditingController();
  final List<TextEditingController> _horasCtrls = List.generate(6, (_) => TextEditingController());
  
  bool _recibeBono = false;
  String _tipoJornada = 'Diurna';

  void _registrar() {
    if (_formKey.currentState!.validate()) {
      try {
        final chofer = ChoferModel(
          nombre: _nombreCtrl.text,
          sueldoPorHora: double.parse(_sueldoCtrl.text),
          horasPorDia: _horasCtrls.map((c) => double.parse(c.text)).toList(),
          recibeBono: _recibeBono,
          tipoJornada: _tipoJornada,
        );

        final error = _controller.validarChofer(chofer);
        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
          return;
        }

        if (_controller.registrarChofer(chofer)) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Chofer registrado con éxito')));
          _limpiarFormularioSolo();
          setState(() {});
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Límite de 5 choferes alcanzado')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Datos inválidos')));
      }
    }
  }

  void _limpiarFormularioSolo() {
    _nombreCtrl.clear();
    _sueldoCtrl.clear();
    for (var c in _horasCtrls) { c.clear(); }
    setState(() {
      _recibeBono = false;
      _tipoJornada = 'Diurna';
    });
  }

  void _limpiarTodo() {
    _controller.limpiar();
    _limpiarFormularioSolo();
  }

  void _calcularYNavegar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Calculando reporte general...'))
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushNamed(context, '/reporte', arguments: _controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Nómina')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text('Choferes registrados: ${_controller.totalRegistrados}/5', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              CamposTextoPersonalizado(
                label: 'Nombre del chofer',
                hint: 'Ej. Juan',
                controller: _nombreCtrl,
              ),
              const SizedBox(height: 10),
              CamposTextoPersonalizado(
                label: 'Sueldo por hora',
                hint: 'Ej. 5.50',
                controller: _sueldoCtrl,
              ),
              const SizedBox(height: 10),
              const Text('Horas trabajadas (Lun - Sáb):'),
              // Usando la molecula recien creada
              GrupoHoras(controladores: _horasCtrls),
              const SizedBox(height: 10),
              CheckboxPersonalizado(
                label: '¿Recibe Bono extra?',
                value: _recibeBono,
                onChanged: (val) => setState(() => _recibeBono = val ?? false),
              ),
              Row(
                children: [
                   Expanded(
                    child: RadioButtonPersonalizado<String>(
                      titulo: 'Diurna',
                      opciones: const ['Diurna'],
                      valorSeleccionado: _tipoJornada,
                      onChanged: (val) => setState(() => _tipoJornada = val!),
                      etiqueta: (v) => v,
                    ),
                  ),
                  Expanded(
                    child: RadioButtonPersonalizado<String>(
                      titulo: 'Nocturna',
                      opciones: const ['Nocturna'],
                      valorSeleccionado: _tipoJornada,
                      onChanged: (val) => setState(() => _tipoJornada = val!),
                      etiqueta: (v) => v,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: BotonPersonalizado(text: 'Registrar', onPressed: _controller.puedeRegistrar ? _registrar : null)),
                  const SizedBox(width: 10),
                  Expanded(child: BotonPersonalizado(text: 'Limpiar Todo', tipo: TipoBoton.secundario, onPressed: _limpiarTodo)),
                ],
              ),
              const SizedBox(height: 10),
              BotonPersonalizado(
                text: 'Calcular y Ver Reporte',
                onPressed: _calcularYNavegar,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
