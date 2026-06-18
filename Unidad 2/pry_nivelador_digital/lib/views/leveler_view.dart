import 'package:flutter/material.dart';
import '../models/accelerometer_model.dart';
import '../viewmodels/leveler_viewmodel.dart';

class LevelerView extends StatefulWidget {
  const LevelerView({super.key});

  @override
  State<LevelerView> createState() => _LevelerViewState();
}

class _LevelerViewState extends State<LevelerView> {
  final LevelerViewModel _viewModel = LevelerViewModel();

  @override
  void initState() {
    super.initState();
    
    // Configuramos el disparador del diálogo de confirmación para repeticiones de coordenadas
    _viewModel.solicitarConfirmacionDialog = (String endpoint, String nombreApp) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
                const SizedBox(width: 10),
                Text('¿Abrir otra vez?'),
              ],
            ),
            content: Text(
              'Ya abriste ${nombreApp.toUpperCase()} en esta coordenada hace un momento.\n\n'
              '¿Quieres forzar la apertura de una nueva pestaña o prefieres cancelar para cambiar de coordenada?'
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Solo cierra el diálogo, no hace nada en la PC
                },
                child: const Text('Cancelar / Mover celular'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(); 
                  _viewModel.enviarOrdenAPc(endpoint, nombreApp); // Fuerza la apertura repetida
                },
                child: const Text('Sí, abrir otra'),
              ),
            ],
          );
        },
      );
    };

    _viewModel.init(); 
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nivelador Digital', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[50],
      body: StreamBuilder<AccelerometerModel>(
        stream: _viewModel.accelerometerStream,
        builder: (context, snapshot) {
          double x = 0.0, y = 0.0, z = 0.0;

          if (snapshot.hasData) {
            x = snapshot.data!.x;
            y = snapshot.data!.y;
            z = snapshot.data!.z;
          }

          // Cálculos de la burbuja
          double centerArea = 240.0; 
          double bubbleSize = 50.0;
          double maxMovement = (centerArea / 2) - (bubbleSize / 2);

          double posicionX = (-x / 9.81) * maxMovement;
          double posicionY = (y / 9.81) * maxMovement;

          posicionX = posicionX.clamp(-maxMovement, maxMovement);
          posicionY = posicionY.clamp(-maxMovement, maxMovement);

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tarjeta de Coordenadas Numéricas
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                    child: Column(
                      children: [
                        Text('Eje X: ${x.toStringAsFixed(2)} (YouTube)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const Divider(),
                        Text('Eje Y: ${y.toStringAsFixed(2)} (Chrome)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        const Divider(),
                        Text('Eje Z: ${z.toStringAsFixed(2)} (Word)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),

                // El Nivelador Gráfico (Círculo y Burbuja)
                Center(
                  child: Container(
                    width: centerArea,
                    height: centerArea,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.indigo, width: 3),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(width: centerArea, height: 1, color: Colors.grey[400]),
                        Container(width: 1, height: centerArea, color: Colors.grey[400]),
                        Transform.translate(
                          offset: Offset(posicionX, posicionY),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 40),
                            width: bubbleSize,
                            height: bubbleSize,
                            decoration: BoxDecoration(
                              color: _viewModel.isHorizontal ? Colors.green : Colors.red,
                              shape: BoxShape.circle,
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Banner Informativo de Estado Actual
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _viewModel.isHorizontal ? Colors.green[100] : Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _viewModel.isHorizontal ? Colors.green : Colors.blue, width: 1.5),
                  ),
                  child: Text(
                    _viewModel.mensajeAccion,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _viewModel.isHorizontal ? Colors.green[900] : Colors.blue[900],
                    ),
                  ),
                ),

                // EL BOTÓN DINÁMICO E INTELIGENTE: Solo aparece si hay una app detectada y lista para abrir
                Container(
                  height: 60, // Espacio reservado para que la interfaz no salte bruscamente
                  width: double.infinity,
                  child: _viewModel.appDetectadaParaAbrir.isNotEmpty
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigo,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            elevation: 5,
                          ),
                          icon: const Icon(Icons.launch_rounded),
                          label: Text(
                            _viewModel.textoBotonAccion,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            setState(() {
                              _viewModel.ejecutarAccionDeBoton();
                            });
                          },
                        )
                      : const SizedBox.shrink(), // No dibuja nada si el teléfono está recto o libre
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}