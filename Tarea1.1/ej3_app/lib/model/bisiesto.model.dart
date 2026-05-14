class BisiestoModel {
  static bool esBisiesto(int anio) {
    // Lógica: Múltiplo de 4 y (no múltiplo de 100 o sí de 400)
    if ((anio % 4 == 0 && anio % 100 != 0) || (anio % 400 == 0)) {
      return true;
    }
    return false;
  }
}