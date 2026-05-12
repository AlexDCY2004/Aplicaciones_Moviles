import '../models/pedido_cafe_model.dart';

class SalesRepository {
  SalesRepository._privateConstructor();
  static final SalesRepository instance = SalesRepository._privateConstructor();

  final List<PedidoCafeModelo> _ventas = [];

  List<PedidoCafeModelo> getAll() => List.unmodifiable(_ventas.reversed);

  void add(PedidoCafeModelo pedido) {
    pedido.creadoEn = DateTime.now();
    _ventas.add(pedido);
  }

  void clear() {
    _ventas.clear();
  }
}
