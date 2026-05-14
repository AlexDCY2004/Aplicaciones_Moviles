import 'package:flutter/material.dart';
import '../controllers/nomina_controller.dart';
import '../widgets/atomos/boton_personalizado.dart';
import '../widgets/moleculas/tarjeta_chofer.dart';
import '../widgets/organismos/resumen_general_nomina.dart';

class VistaReporte extends StatelessWidget {
  const VistaReporte({super.key});

  @override
  Widget build(BuildContext context) {
    final NominaController controller = ModalRoute.of(context)!.settings.arguments as NominaController;
    final choferes = controller.choferes;

    return Scaffold(
      appBar: AppBar(title: const Text('Reporte General')),
      body: choferes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No hay choferes registrados'),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: BotonPersonalizado(
                      text: 'Regresar',
                      tipo: TipoBoton.secundario,
                      // Demostrando uso de pop
                      onPressed: () => Navigator.pop(context),
                    ),
                  )
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: choferes.length + 1,
                    itemBuilder: (context, index) {
                      if (index == choferes.length) {
                        return ResumenGeneralNomina(
                          totalPagar: controller.calcularTotalEmpresa(),
                          choferMasHoras: controller.choferMasHorasLunes(),
                        );
                      }
                      return TarjetaChofer(chofer: choferes[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BotonPersonalizado(
                    text: 'Volver al Registro',
                    tipo: TipoBoton.secundario,
                    // Demostrando uso de pop
                    onPressed: () => Navigator.pop(context),
                  ),
                )
              ],
            ),
    );
  }
}
