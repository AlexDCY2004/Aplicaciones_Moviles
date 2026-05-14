import 'package:flutter/material.dart';
import '../molecules/selector_servicio_molecule.dart';
import '../atoms/caja_texto_atom.dart';
import '../molecules/resumen_ajustes_molecule.dart';
import '../../models/modelos.dart';
import '../../controllers/controllers.dart';
import '../../controllers/singletons.dart';


class NuevoPagoView extends StatefulWidget {
  final bool hideOtros;
  const NuevoPagoView({super.key, this.hideOtros = false});

  @override
  State<NuevoPagoView> createState() => _NuevoPagoViewState();
}

class _NuevoPagoViewState extends State<NuevoPagoView> {
  String? servicioSeleccionado;
  String? clienteSeleccionadoId;
  String? operadoraSeleccionada;
  final operadoraOtroCtrl = TextEditingController();
  String? streamingSeleccionado;
  final streamingOtroCtrl = TextEditingController();
  final streamingPrecioCtrl = TextEditingController();
  final consumoCtrl = TextEditingController();
  final seleccionados = <String>{};
  List<Ajuste> ajustesEjemplo = [];
  final ServicioController servicioController = servicioControllerSingleton;
  final AjusteController ajusteController = ajusteControllerSingleton;
  late final PagoController pagoController = pagoControllerSingleton;

  @override
  void initState() {
    super.initState();
    ajustesEjemplo = [...ajusteController.obtenerDescuentos(), ...ajusteController.obtenerRecargos()];
    final svs = servicioController.obtenerServicios();
    if (svs.isNotEmpty) {
      servicioSeleccionado = svs.first.nombre;
    }
    final cls = clienteControllerSingleton.obtenerClientes();
    if (cls.isNotEmpty) clienteSeleccionadoId = cls.first.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo pago')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Seleccionar cliente'),
          const SizedBox(height: 6),
          _buildClienteSelector(context),
          const SizedBox(height: 12),
              SelectorServicioMolecule(
                servicios: servicioController
                  .obtenerServicios()
                  .where((s) => s.id != 's_basura' && s.id != 's_streaming' && (!widget.hideOtros || s.id != 's_otros'))
                  .map((s) => s.nombre)
                  .toList(),
                seleccionado: servicioSeleccionado,
                onChanged: (s) => setState(() => servicioSeleccionado = s)),
          const SizedBox(height: 8),
          Builder(builder: (ctx) {
            final serv = servicioController.obtenerServicios().firstWhere((s) => s.nombre == servicioSeleccionado, orElse: () => servicioController.obtenerServicios().first);
            if (serv.id != 's_tv') return const SizedBox.shrink();
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 12),
              const Text('Streaming (opcional)'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: streamingSeleccionado,
                items: ['Ninguno', 'Netflix', 'Max', 'Disney+', 'Otros'].map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                onChanged: (v) => setState(() => streamingSeleccionado = v),
                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              ),
              if (streamingSeleccionado != null && streamingSeleccionado != 'Ninguno') ...[
                const SizedBox(height: 8),
                if (streamingSeleccionado == 'Otros') TextFormField(controller: streamingOtroCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Nombre del streaming')),
                const SizedBox(height: 8),
                CajaTextoAtom(controlador: streamingPrecioCtrl, placeholder: '0.00', teclado: TextInputType.number, soloNumeros: true),
              ]
            ]);
          }),
          Builder(builder: (ctx) {
            final serv = servicioController.obtenerServicios().firstWhere((s) => s.nombre == servicioSeleccionado, orElse: () => servicioController.obtenerServicios().first);
            if (serv.id != 's_internet') return const SizedBox.shrink();
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 12),
              const Text('Operadora'),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: operadoraSeleccionada,
                items: ['Fibramax', 'CNT', 'Netlife', 'Otros'].map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                onChanged: (v) => setState(() => operadoraSeleccionada = v),
                decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
              ),
              if (operadoraSeleccionada == 'Otros') ...[
                const SizedBox(height: 8),
                TextFormField(controller: operadoraOtroCtrl, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'Nombre de la operadora')),
              ]
            ]);
          }),
          const SizedBox(height: 12),
          const Text('Consumo / Valor base'),
          CajaTextoAtom(controlador: consumoCtrl, placeholder: '0', teclado: TextInputType.number, soloNumeros: true),
          const SizedBox(height: 12),
          const Text('Ajustes (descuentos / recargos)'),
          ResumenAjustesMolecule(ajustes: ajustesEjemplo, seleccionados: seleccionados, onToggle: (id) => setState(() => seleccionados.contains(id) ? seleccionados.remove(id) : seleccionados.add(id))),
          const SizedBox(height: 16),
          Row(children: [
            ElevatedButton(onPressed: _calcular, child: const Text('Calcular')),
            const SizedBox(width: 12),
            OutlinedButton(onPressed: _limpiar, child: const Text('Limpiar')),
          ]),
        ]),
      ),
    );
  }

  void _calcular() {
    final servicio = servicioController.obtenerServicios().firstWhere((s) => s.nombre == servicioSeleccionado, orElse: () => servicioController.obtenerServicios().first);
    final consumo = double.tryParse(consumoCtrl.text.trim()) ?? 0.0;
    if (clienteSeleccionadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seleccione un cliente antes de continuar')));
      return;
    }
    if (servicio.id == 's_internet') {
      if (operadoraSeleccionada == null || operadoraSeleccionada!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Seleccione la operadora')));
        return;
      }
      if (operadoraSeleccionada == 'Otros' && operadoraOtroCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingrese el nombre de la operadora')));
        return;
      }
    }
    String? streamingNombre;
    double streamingPrecio = 0.0;
    if (servicio.id == 's_tv') {
      if (streamingSeleccionado != null && streamingSeleccionado != 'Ninguno') {
        // streaming selected (not 'Ninguno') - require price
        if (streamingSeleccionado == 'Otros') {
          if (streamingOtroCtrl.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingrese el nombre del streaming')));
            return;
          }
          streamingNombre = streamingOtroCtrl.text.trim();
        } else {
          streamingNombre = streamingSeleccionado;
        }
        final sp = double.tryParse(streamingPrecioCtrl.text.trim());
        if (sp == null || sp <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ingrese un precio válido para el streaming')));
          return;
        }
        streamingPrecio = sp;
      }
    }
    final valorBase = (servicio.id == 's_internet' || servicio.id == 's_tv' || servicio.id == 's_streaming') ? consumo : 0.0;
    final resumen = pagoController.calcularTotal(servicio, consumo, seleccionados.toList(), valorBase: valorBase, streamingPrecio: streamingPrecio, streamingNombre: streamingNombre);
    final args = {
      'resumen': resumen,
      'clienteId': clienteSeleccionadoId,
      'servicioId': servicio.id,
      'servicioNombre': servicio.nombre,
      'consumo': consumo,
      'ajustes': seleccionados.toList(),
      'operadora': servicio.id == 's_internet' ? (operadoraSeleccionada == 'Otros' ? operadoraOtroCtrl.text.trim() : operadoraSeleccionada) : null,
      'valorBase': valorBase,
      'streamingNombre': servicio.id == 's_tv' ? streamingNombre : null,
      'streamingPrecio': servicio.id == 's_tv' ? streamingPrecio : 0.0,
    };
    Navigator.pushNamed(context, '/resumen', arguments: args);
  }

  void _limpiar() {
    setState(() {
      servicioSeleccionado = servicioController.obtenerServicios().isNotEmpty ? servicioController.obtenerServicios().first.nombre : null;
      consumoCtrl.clear();
      seleccionados.clear();
    });
  }
  Widget _buildClienteSelector(BuildContext context) {
    final clientes = clienteControllerSingleton.obtenerClientes();
    if (clientes.isEmpty) {
      return Row(children: [
        const Expanded(child: Text('No hay clientes. Registre uno.')),
        OutlinedButton(onPressed: () => Navigator.pushNamed(context, '/registro'), child: const Text('Registrar')),
      ]);
    }
    return DropdownButtonFormField<String>(
      initialValue: clienteSeleccionadoId,
      items: clientes.map((c) => DropdownMenuItem(value: c.id, child: Text(c.nombre))).toList(),
      onChanged: (v) => setState(() => clienteSeleccionadoId = v),
      decoration: const InputDecoration(border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
    );
  }
}
