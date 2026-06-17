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
    _viewModel.init(); // Encendemos el acelerómetro
  }

  @override
  void dispose() {
    _viewModel.dispose(); // Apagamos el acelerómetro para ahorrar batería
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nivelador Digital MVVM'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<AccelerometerModel>(
        stream: _viewModel.accelerometerStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          // Mapeamos los valores de los ejes para mover la burbuja visualmente en la pantalla
          // Limitamos el rango multiplicando por factores pequeños para que no se salga del contenedor
          double posicionX = data.x * 12; 
          double posicionY = data.y * 12;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Tarjeta de información de los sensores
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text('Eje X: ${data.x.toStringAsFixed(2)} (YouTube)', style: const TextStyle(fontSize: 16)),
                        const Divider(),
                        Text('Eje Y: ${data.y.toStringAsFixed(2)} (Chrome)', style: const TextStyle(fontSize: 16)),
                        const Divider(),
                        Text('Eje Z: ${data.z.toStringAsFixed(2)} (Word)', style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),

                // MARCO DEL NIVEL DE CONSTRUCCIÓN
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.indigo, width: 4),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Líneas de guía centrales (la cruz del nivel)
                      Container(width: 2, color: Colors.indigo.withOpacity(0.3)),
                      Container(height: 2, color: Colors.indigo.withOpacity(0.3)),
                      
                      // BURBUJA MÓVIL ANIMADA
                      AnimatedAlign(
                        alignment: Alignment(
                          // Clampeamos los valores entre -1.0 y 1.0 para mantener la burbuja dentro del círculo
                          (posicionX / 100).clamp(-1.0, 1.0),
                          (posicionY / 100).clamp(-1.0, 1.0),
                        ),
                        duration: const Duration(milliseconds: 100),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            // Cambia a VERDE si está perfectamente horizontal, si no, es ROJO
                            color: _viewModel.isHorizontal ? Colors.green : Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // BANNER DE ACCIÓN / SIMULACIÓN
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: _viewModel.isHorizontal ? Colors.green[100] : Colors.amber[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _viewModel.isHorizontal ? Colors.green : Colors.amber,
                    ),
                  ),
                  child: Text(
                    _viewModel.mensajeAccion,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _viewModel.isHorizontal ? Colors.green[900] : Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}