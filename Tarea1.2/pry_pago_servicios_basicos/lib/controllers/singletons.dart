import 'servicioController.dart';
import 'ajusteController.dart';
import 'clienteController.dart';
import 'pagoController.dart';

/// Shared singletons for controllers so state is visible across screens.
final servicioControllerSingleton = ServicioController();
final ajusteControllerSingleton = AjusteController();
final clienteControllerSingleton = ClienteController();
final pagoControllerSingleton = PagoController(
  servicioController: servicioControllerSingleton,
  ajusteController: ajusteControllerSingleton,
);
