import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../models/accelerometer_model.dart';

class LevelerViewModel {
  // StreamController para enviar los datos procesados a la Vista
  final StreamController<AccelerometerModel> _modelController = StreamController<AccelerometerModel>();
  StreamSubscription<AccelerometerEvent>? _sensorSubscription;

  // Getters para que la vista consuma los datos
  Stream<AccelerometerModel> get accelerometerStream => _modelController.stream;

  // Variables de estado auxiliares
  String mensajeAccion = "Dispositivo Estable";
  bool isHorizontal = false;

  // Inicializa la escucha del sensor
  void init() {
    // SOLUCIÓN AQUÍ: Usamos accelerometerEventStream() en lugar del método viejo
    _sensorSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      // 1. Mapeamos los datos del paquete a nuestro modelo
      final model = AccelerometerModel(x: event.x, y: event.y, z: event.z);

      // 2. Evaluamos la lógica de negocio (Inclinación / Acciones en PC)
      // SOLUCIÓN AQUÍ: Corregido el nombre de la función (sin espacios)
      _evaluarInclinacionYAccion(model);

      // 3. Añadimos el modelo al flujo para que la vista se actualice
      if (!_modelController.isClosed) {
        _modelController.add(model);
      }
    });
  }

  // SOLUCIÓN AQUÍ: Corregido el espacio extraño que tenías en el nombre
  void _evaluarInclinacionYAccion(AccelerometerModel model) {
    // Definimos un umbral de tolerancia para considerar que está "horizontal"
    bool horizontalEnX = model.x.abs() < 0.6;
    bool horizontalEnY = model.y.abs() < 0.6;

    if (horizontalEnX && horizontalEnY) {
      isHorizontal = true;
      mensajeAccion = "¡Completamente Horizontal! (Ejes nivelados)";
    } else {
      isHorizontal = false;
      
      // Evaluamos cuál eje predomina en la inclinación para activar la simulación
      if (model.x.abs() > model.y.abs() && model.x.abs() > 1.5) {
        mensajeAccion = "Simulando: Abrir YouTube en PC (Eje X)";
      } else if (model.y.abs() > model.x.abs() && model.y.abs() > 1.5) {
        mensajeAccion = "Simulando: Abrir Google Chrome en PC (Eje Y)";
      } else if (model.z.abs() > 8.0 && model.x.abs() < 2.0 && model.y.abs() < 2.0) {
        mensajeAccion = "Simulando: Abrir Word en PC (Eje Z)";
      }
    }
  }

  // Limpieza de memoria al cerrar la pantalla
  void dispose() {
    _sensorSubscription?.cancel();
    _modelController.close();
  }
}