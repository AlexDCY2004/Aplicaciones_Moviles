/*import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:http/http.dart' as http; // 1. Importamos el paquete HTTP
import '../models/accelerometer_model.dart';

class LevelerViewModel {
  final StreamController<AccelerometerModel> _modelController = StreamController<AccelerometerModel>();
  StreamSubscription<AccelerometerEvent>? _sensorSubscription;

  Stream<AccelerometerModel> get accelerometerStream => _modelController.stream;

  String mensajeAccion = "Dispositivo Estable";
  bool isHorizontal = false;

  // 2. LA IP DE TU PC: Cambia esto por el resultado de poner 'ipconfig' en tu terminal
  final String urlBasePc = "http://192.168.18.11:3000"; 

  // Bandera para evitar enviar 50 peticiones por segundo mientras el teléfono se mueve
  bool _bloqueoPeticion = false;

  void init() {
    _sensorSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      final model = AccelerometerModel(x: event.x, y: event.y, z: event.z);
      _evaluarInclinacionYAccion(model);

      if (!_modelController.isClosed) {
        _modelController.add(model);
      }
    });
  }

  void _evaluarInclinacionYAccion(AccelerometerModel model) {
    bool horizontalEnX = model.x.abs() < 0.6;
    bool horizontalEnY = model.y.abs() < 0.6;

    if (horizontalEnX && horizontalEnY) {
      isHorizontal = true;
      mensajeAccion = "¡Completamente Horizontal! (Ejes nivelados)";
    } else {
      isHorizontal = false;
      
      if (model.x.abs() > model.y.abs() && model.x.abs() > 3.0) {
        mensajeAccion = "Abriendo YouTube en PC...";
        _enviarOrdenAPc('/abrir-youtube'); // 3. Llamamos a la PC de verdad
      } else if (model.y.abs() > model.x.abs() && model.y.abs() > 3.0) {
        mensajeAccion = "Abriendo Google Chrome...";
        _enviarOrdenAPc('/abrir-chrome');
      } else if (model.z.abs() > 8.0 && model.x.abs() < 1.5 && model.y.abs() < 1.5) {
        mensajeAccion = "Abriendo Word...";
        _enviarOrdenAPc('/abrir-word');
      }
    }
  }

  // 4. FUNCIÓN MÁGICA: Envía la señal por la red local
  void _enviarOrdenAPc(String endpoint) async {
    if (_bloqueoPeticion) return; // Si ya envió una orden, espera a que termine

    _bloqueoPeticion = true;
    try {
      final url = Uri.parse('$urlBasePc$endpoint');
      await http.post(url); // Envía el golpe HTTP POST a la computadora
    } catch (e) {
      print("Error conectando con la PC: $e");
    }

    // Espera 3 segundos antes de permitir abrir otra ventana para no colapsar la PC
    await Future.delayed(const Duration(seconds: 3));
    _bloqueoPeticion = false;
  }

  void dispose() {
    _sensorSubscription?.cancel();
    _modelController.close();
  }
}*/

import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:http/http.dart' as http;
import '../models/accelerometer_model.dart';

class LevelerViewModel {
  final StreamController<AccelerometerModel> _modelController = StreamController<AccelerometerModel>();
  StreamSubscription<AccelerometerEvent>? _sensorSubscription;

  Stream<AccelerometerModel> get accelerometerStream => _modelController.stream;

  // Variables de estado para la interfaz
  String mensajeAccion = "Dispositivo Estable";
  bool isHorizontal = false;

  // Variables para el nuevo flujo del Botón Dinámico
  String appDetectadaParaAbrir = ""; // "youtube", "chrome", "word" o ""
  String textoBotonAccion = "";      // Texto que llevará el botón en la interfaz
  String endpointActual = "";        // Endpoint correspondiente al eje inclinado

  // Memoria del sistema
  String ultimaAppAbiertaConExito = "ninguna";

  // IP de tu computadora con Node.js
  final String urlBasePc = "http://192.168.18.11:3000"; 

  // Callback para levantar el Dialog en la Vista solo cuando sea necesario
  Function(String endpoint, String nombreApp)? solicitarConfirmacionDialog;

  void init() {
    _sensorSubscription = accelerometerEventStream().listen((AccelerometerEvent event) {
      final model = AccelerometerModel(x: event.x, y: event.y, z: event.z);
      _evaluarInclinacion(model);

      if (!_modelController.isClosed) {
        _modelController.add(model);
      }
    });
  }

  // El sensor SOLO detecta y prepara la acción. NO dispara alertas automáticas.
  void _evaluarInclinacion(AccelerometerModel model) {
    bool horizontalEnX = model.x.abs() < 0.6;
    bool horizontalEnY = model.y.abs() < 0.6;

    if (horizontalEnX && horizontalEnY) {
      isHorizontal = true;
      mensajeAccion = "¡Completamente Horizontal! (Ejes nivelados)";
      appDetectadaParaAbrir = "";
      textoBotonAccion = "";
      endpointActual = "";
    } else {
      isHorizontal = false;
      
      if (model.x.abs() > model.y.abs() && model.x.abs() > 3.0) {
        mensajeAccion = "Coordenada X Detectada (YouTube)";
        appDetectadaParaAbrir = "youtube";
        textoBotonAccion = "Abrir YouTube en PC";
        endpointActual = "/abrir-youtube";
      } else if (model.y.abs() > model.x.abs() && model.y.abs() > 3.0) {
        mensajeAccion = "Coordenada Y Detectada (Chrome)";
        appDetectadaParaAbrir = "chrome";
        textoBotonAccion = "Abrir Google Chrome";
        endpointActual = "/abrir-chrome";
      } else if (model.z.abs() > 8.0 && model.x.abs() < 1.5 && model.y.abs() < 1.5) {
        mensajeAccion = "Coordenada Z Detectada (Word)";
        appDetectadaParaAbrir = "word";
        textoBotonAccion = "Abrir Word en PC";
        endpointActual = "/abrir-word";
      } else {
        // Posición intermedia o inclinación no definida
        appDetectadaParaAbrir = "";
        textoBotonAccion = "";
        endpointActual = "";
      }
    }
  }

  // 🔥 ESTA FUNCIÓN SE EJECUTA ÚNICAMENTE CUANDO SE PRESIONA EL BOTÓN EN LA PANTALLA
  void ejecutarAccionDeBoton() {
    if (appDetectadaParaAbrir.isEmpty) return;

    // Condición: Si es una app DIFERENTE a la última que abrimos con éxito
    if (ultimaAppAbiertaConExito != appDetectadaParaAbrir) {
      // Abre directamente sin preguntar
      String appAAbrir = appDetectadaParaAbrir; 
      enviarOrdenAPc(endpointActual, appAAbrir);
    } 
    // Condición: Si el usuario quiere abrir EXACTAMENTE la misma app consecutivamente
    else {
      if (solicitarConfirmacionDialog != null) {
        solicitarConfirmacionDialog!(endpointActual, appDetectadaParaAbrir);
      }
    }
  }

  // Envía la señal real a la computadora por Wi-Fi
  void enviarOrdenAPc(String endpoint, String nombreApp) async {
    try {
      final url = Uri.parse('$urlBasePc$endpoint');
      await http.post(url);
      
      // Registramos el éxito de la operación
      ultimaAppAbiertaConExito = nombreApp;
      
      // "Limpiamos" temporalmente los estados para obligar al usuario a mover el celular
      limpiarPantalla();
    } catch (e) {
      print("Error en comunicación local: $e");
    }
  }

  // Resetea el botón para forzar a que el usuario cambie de posición o mueva el celular
  void limpiarPantalla() {
    appDetectadaParaAbrir = "";
    textoBotonAccion = "";
    endpointActual = "";
    mensajeAccion = "Acción ejecutada. Mueva el dispositivo.";
  }

  void dispose() {
    _sensorSubscription?.cancel();
    _modelController.close();
  }
}