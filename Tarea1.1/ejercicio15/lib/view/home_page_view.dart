import 'package:flutter/material.dart';

import '../controller/peso_club_controller.dart';
import '../model/peso_club_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const int _personasCount = 5;
  static const int _basculasCount = PesoClubController.basculasPorPersona;

  final _controller = PesoClubController();
  final List<String> _personas = List.generate(
    _personasCount,
    (index) => 'Persona ${index + 1}',
  );

  late final List<TextEditingController> _pesosAnteriores;
  late final List<List<TextEditingController>> _pesosBasculas;

  final List<PesoPersonaResultado?> _resultadosIndividuales =
      List.generate(_personasCount, (_) => null);
  
  int _selectedPersonaIndex = 0;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _pesosAnteriores = List.generate(
      _personasCount,
      (_) => TextEditingController(),
    );
    _pesosBasculas = List.generate(
      _personasCount,
      (_) => List.generate(_basculasCount, (_) => TextEditingController()),
    );
  }

  void _calcularPersona() {
    final resultado = _controller.calcularPesoPersona(
      nombre: _personas[_selectedPersonaIndex],
      pesoAnteriorStr: _pesosAnteriores[_selectedPersonaIndex].text,
      pesosBasculas: _pesosBasculas[_selectedPersonaIndex]
          .map((c) => c.text)
          .toList(),
    );

    setState(() {
      if (resultado.esValido) {
        _resultadosIndividuales[_selectedPersonaIndex] =
            resultado.resultados.first;
        _errorMessage = '';
      } else {
        _errorMessage = resultado.mensaje;
      }
    });
  }

  void _verGeneral() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Resumen General'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(_personasCount, (index) {
            final res = _resultadosIndividuales[index];
            final nombre = _personas[index];
            if (res == null) {
              return ListTile(
                title: Text(nombre),
                subtitle: const Text('Aún no se pesa'),
                leading: const Icon(Icons.hourglass_empty, color: Colors.grey),
              );
            }
            final status = res.subio ? 'SUBIO' : 'BAJO';
            final color = res.subio ? Colors.orange : Colors.green;
            return ListTile(
              title: Text(nombre),
              subtitle: Text('$status (${PesoClubController.formatKg(res.diferencia.abs())})'),
              leading: Icon(
                res.subio ? Icons.trending_up : Icons.trending_down,
                color: color,
              ),
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _limpiar() {
    for (final controller in _pesosAnteriores) {
      controller.clear();
    }
    for (final row in _pesosBasculas) {
      for (final controller in row) {
        controller.clear();
      }
    }

    setState(() {
      for (int i = 0; i < _personasCount; i++) {
        _resultadosIndividuales[i] = null;
      }
      _errorMessage = '';
    });
  }

  @override
  void dispose() {
    for (final controller in _pesosAnteriores) {
      controller.dispose();
    }
    for (final row in _pesosBasculas) {
      for (final controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TemplateHome(
      child: Column(
        children: [
          _buildPersonaSelector(),
          const SizedBox(height: 16),
          OrganismClubCard(
            personaNombre: _personas[_selectedPersonaIndex],
            pesoAnterior: _pesosAnteriores[_selectedPersonaIndex],
            pesosBasculas: _pesosBasculas[_selectedPersonaIndex],
            resultado: _resultadosIndividuales[_selectedPersonaIndex],
            errorMessage: _errorMessage,
            onCalcular: _calcularPersona,
            onLimpiar: _limpiar,
            onVerGeneral: _verGeneral,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonaSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_personasCount, (index) {
          final isSelected = _selectedPersonaIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(_personas[index]),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedPersonaIndex = index;
                    _errorMessage = '';
                  });
                }
              },
            ),
          );
        }),
      ),
    );
  }
}

// Templates
class TemplateHome extends StatelessWidget {
  final Widget child;

  const TemplateHome({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club contra la obesidad'),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF1F6FF), Color(0xFFE3F0FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Organisms
class OrganismClubCard extends StatelessWidget {
  final String personaNombre;
  final TextEditingController pesoAnterior;
  final List<TextEditingController> pesosBasculas;
  final PesoPersonaResultado? resultado;
  final String errorMessage;
  final VoidCallback onCalcular;
  final VoidCallback onLimpiar;
  final VoidCallback onVerGeneral;

  const OrganismClubCard({
    super.key,
    required this.personaNombre,
    required this.pesoAnterior,
    required this.pesosBasculas,
    required this.resultado,
    required this.errorMessage,
    required this.onCalcular,
    required this.onLimpiar,
    required this.onVerGeneral,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const MoleculeHeader(),
            const SizedBox(height: 12),
            const AtomBodyText(
              'Selecciona una persona, ingresa sus pesos y calcula.',
            ),
            const SizedBox(height: 16),
            OrganismPersonaCard(
              nombre: personaNombre,
              pesoAnteriorController: pesoAnterior,
              pesosBasculasControllers: pesosBasculas,
            ),
            const SizedBox(height: 16),
            MoleculeActionButtons(
              onCalcular: onCalcular,
              onLimpiar: onLimpiar,
              onVerGeneral: onVerGeneral,
            ),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 10),
              AtomErrorText(errorMessage),
            ],
            if (resultado != null) ...[
              const SizedBox(height: 16),
              OrganismResultados(resultado: resultado!),
            ],
          ],
        ),
      ),
    );
  }
}

class OrganismPersonaCard extends StatelessWidget {
  final String nombre;
  final TextEditingController pesoAnteriorController;
  final List<TextEditingController> pesosBasculasControllers;

  const OrganismPersonaCard({
    super.key,
    required this.nombre,
    required this.pesoAnteriorController,
    required this.pesosBasculasControllers,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF7FAFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFD7E8FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MoleculePersonaHeader(nombre: nombre),
            const SizedBox(height: 10),
            MoleculePesoAnteriorInput(controller: pesoAnteriorController),
            const SizedBox(height: 12),
            MoleculeBasculasGrid(controllers: pesosBasculasControllers),
          ],
        ),
      ),
    );
  }
}

class OrganismResultados extends StatelessWidget {
  final PesoPersonaResultado resultado;

  const OrganismResultados({super.key, required this.resultado});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFEEF6FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFCBE3FF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AtomSectionTitle('Resultado individual'),
            const SizedBox(height: 10),
            MoleculeResultadoRow(persona: resultado),
          ],
        ),
      ),
    );
  }
}

// Molecules
class MoleculeHeader extends StatelessWidget {
  const MoleculeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF7DB6FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.monitor_weight_outlined, color: Colors.white),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: AtomTitle('Ritual de pesaje'),
        ),
      ],
    );
  }
}

class MoleculePersonaHeader extends StatelessWidget {
  final String nombre;

  const MoleculePersonaHeader({super.key, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person_outline, size: 18, color: Color(0xFF2C4C77)),
        const SizedBox(width: 6),
        AtomSectionTitle(nombre),
      ],
    );
  }
}

class MoleculePesoAnteriorInput extends StatelessWidget {
  final TextEditingController controller;

  const MoleculePesoAnteriorInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AtomNumberField(
      controller: controller,
      hint: 'Peso anterior (kg)',
    );
  }
}

class MoleculeBasculasGrid extends StatelessWidget {
  final List<TextEditingController> controllers;

  const MoleculeBasculasGrid({super.key, required this.controllers});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AtomBodyText('Pesos de basculas (10):'),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 520;
            final columns = isWide ? 5 : 2;

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                controllers.length,
                (index) {
                  final width = (constraints.maxWidth - (columns - 1) * 10) /
                      columns;

                  return SizedBox(
                    width: width,
                    child: AtomNumberField(
                      controller: controllers[index],
                      hint: 'B${index + 1}',
                      dense: true,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

class MoleculeActionButtons extends StatelessWidget {
  final VoidCallback onCalcular;
  final VoidCallback onLimpiar;
  final VoidCallback onVerGeneral;

  const MoleculeActionButtons({
    super.key,
    required this.onCalcular,
    required this.onLimpiar,
    required this.onVerGeneral,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: AtomPrimaryButton(
                text: 'Calcular',
                onPressed: onCalcular,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AtomSecondaryButton(
                text: 'Limpiar Todo',
                onPressed: onLimpiar,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onVerGeneral,
            icon: const Icon(Icons.assessment_outlined),
            label: const Text('Ver Resumen General'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2C4C77),
              foregroundColor: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class MoleculeResultadoRow extends StatelessWidget {
  final PesoPersonaResultado persona;

  const MoleculeResultadoRow({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    final diferenciaAbs = persona.diferencia.abs();
    final status = persona.subio ? 'SUBIO' : 'BAJO';
    final color = persona.subio ? const Color(0xFFFFA000) : const Color(0xFF2E7D32);

    return Row(
      children: [
        Expanded(child: AtomBodyText(persona.nombre)),
        AtomStatusChip(text: status, color: color),
        const SizedBox(width: 8),
        AtomBodyText(PesoClubController.formatKg(diferenciaAbs)),
      ],
    );
  }
}

// Atoms
class AtomTitle extends StatelessWidget {
  final String text;

  const AtomTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }
}

class AtomSectionTitle extends StatelessWidget {
  final String text;

  const AtomSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class AtomBodyText extends StatelessWidget {
  final String text;

  const AtomBodyText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class AtomErrorText extends StatelessWidget {
  final String text;

  const AtomErrorText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFB00020),
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class AtomNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool dense;

  const AtomNumberField({
    super.key,
    required this.controller,
    required this.hint,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: hint,
        isDense: dense,
        filled: dense,
        fillColor: dense ? Colors.white : null,
      ),
    );
  }
}

class AtomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AtomPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class AtomSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const AtomSecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class AtomStatusChip extends StatelessWidget {
  final String text;
  final Color color;

  const AtomStatusChip({
    super.key,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
      ),
    );
  }
}
