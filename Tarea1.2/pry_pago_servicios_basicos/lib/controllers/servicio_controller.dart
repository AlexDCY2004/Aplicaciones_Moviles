import '../models/modelos.dart';

class ServicioController {
  final List<Servicio> _servicios = [];

  ServicioController() {
    _inicializarServiciosPorDefecto();
  }

  void _inicializarServiciosPorDefecto() {
    // Agua: tramos
    // Tarifa de Agua ajustada a los rangos proporcionados:
    // - De 0 a 8 m3: $0.31
    // - De 9 a 15 m3: $0.43
    // - Más de 15 m3: $0.72
    final tarifaAgua = Tarifa(
      tipo: TipoTarifa.porTramos,
      precio: 0.0,
      tramos: [
        Tramo(minimo: 0, maximo: 8, precioPorUnidad: 0.31),
        Tramo(minimo: 8, maximo: 15, precioPorUnidad: 0.43),
        Tramo(minimo: 15, maximo: null, precioPorUnidad: 0.72),
      ],
      cargoFijo: 2.10,
    );

    // Energía (Luz): tramos según imagen y cargos fijos adicionales
    // Tramos (kWh): 0-50: $0.091, 51-100: $0.093, 101-150: $0.095, 151-180: $0.097, >180: $0.097
    final tarifaEnergia = Tarifa(
      tipo: TipoTarifa.porTramos,
      precio: 0.0,
      tramos: [
        Tramo(minimo: 0, maximo: 50, precioPorUnidad: 0.091),
        Tramo(minimo: 50, maximo: 100, precioPorUnidad: 0.093),
        Tramo(minimo: 100, maximo: 150, precioPorUnidad: 0.095),
        Tramo(minimo: 150, maximo: 180, precioPorUnidad: 0.097),
        Tramo(minimo: 180, maximo: null, precioPorUnidad: 0.097),
      ],
      cargoFijo: 0.0,
    );

    // Internet: tarifa fija
    final tarifaInternet = Tarifa(tipo: TipoTarifa.fija, precio: 30.0, cargoFijo: 0.0);
    // TV: tarifa fija
    final tarifaTV = Tarifa(tipo: TipoTarifa.fija, precio: 20.0, cargoFijo: 0.0);

    _servicios.addAll([
      Servicio(id: 's_agua', nombre: 'Agua potable', unidad: 'm3', tarifa: tarifaAgua),
      Servicio(id: 's_energia', nombre: 'Luz eléctrica', unidad: 'kWh', tarifa: tarifaEnergia),
      Servicio(id: 's_internet', nombre: 'Internet', unidad: 'mes', tarifa: tarifaInternet),
      Servicio(id: 's_tv', nombre: 'Tv Cable', unidad: 'mes', tarifa: tarifaTV),
      // Streaming as a separate selectable service (user may pay streaming subscription directly)
      Servicio(id: 's_streaming', nombre: 'Streaming', unidad: 'mes', tarifa: Tarifa(tipo: TipoTarifa.fija, precio: 0.0, cargoFijo: 0.0)),
      Servicio(id: 's_otros', nombre: 'Otros', unidad: 'unidad', tarifa: Tarifa(tipo: TipoTarifa.porUnidad, precio: 0.0, cargoFijo: 0.0)),
      // Basura: cargo fijo comercial/administrativo aplicado aunque consumo sea cero
      Servicio(id: 's_basura', nombre: 'Basura', unidad: 'servicio', tarifa: Tarifa(tipo: TipoTarifa.fija, precio: 0.0, cargoFijo: 1.11)),
    ]);
  }

  List<Servicio> obtenerServicios() => List.unmodifiable(_servicios);

  Servicio? obtenerPorId(String id) {
    try {
      return _servicios.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
