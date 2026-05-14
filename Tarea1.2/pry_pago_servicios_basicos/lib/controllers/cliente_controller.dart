import '../models/modelos.dart';

class ClienteController {
  final List<Cliente> _clientes = [];

  List<Cliente> obtenerClientes() => List.unmodifiable(_clientes);

  // telefono validator: expects 9-10 digits. Keep logic minimal.

  void agregarCliente(Cliente cliente) {
    _clientes.add(cliente);
  }

  Cliente? buscarPorId(String id) {
    try {
      return _clientes.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  bool eliminar(String id) {
    final antes = _clientes.length;
    _clientes.removeWhere((c) => c.id == id);
    return _clientes.length < antes;
  }

  bool actualizar(Cliente cliente) {
    final idx = _clientes.indexWhere((c) => c.id == cliente.id);
    if (idx < 0) return false;
    _clientes[idx] = cliente;
    return true;
  }

  String? validarNombre(String? value) {
    if (value == null || value.trim().isEmpty) return 'El nombre es obligatorio';
    final v = value.trim();
    final invalid = RegExp(r'[^A-Za-zÁÉÍÓÚáéíóúÑñ ]');
    if (invalid.hasMatch(v)) return 'El nombre no puede contener números ni caracteres especiales';
    if (v.length < 2) return 'Nombre muy corto';
    return null;
  }

  String? validarDireccion(String? value) {
    if (value == null || value.trim().isEmpty) return 'La dirección es obligatoria';
    if (value.trim().length < 3) return 'Dirección muy corta';
    return null;
  }

  String? validarTelefono(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'El teléfono es obligatorio';
    if (!RegExp(r'^\d+$').hasMatch(v)) return 'Solo dígitos (0-9)';
    if (v.length < 9) return 'numero muy pequeño';
    if (v.length > 10) return 'Máximo 10 dígitos';
    return null;
  }

  String? validarCorreo(String? value) {
    if (value == null || value.trim().isEmpty) return 'El correo es obligatorio';
    final v = value.trim();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+').hasMatch(v)) return 'Correo inválido';
    if (!v.contains('@') || v.split('@')[0].isEmpty) return 'Debe haber texto antes de @';
    return null;
  }
}
