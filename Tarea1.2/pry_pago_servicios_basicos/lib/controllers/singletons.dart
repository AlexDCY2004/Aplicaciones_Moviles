import 'servicio_controller.dart';
import 'ajuste_controller.dart';
import 'cliente_controller.dart';
import 'pago_controller.dart';


final servicioControllerSingleton = ServicioController();
final ajusteControllerSingleton = AjusteController();
final clienteControllerSingleton = ClienteController();
final pagoControllerSingleton = PagoController(
  servicioController: servicioControllerSingleton,
  ajusteController: ajusteControllerSingleton,
);
