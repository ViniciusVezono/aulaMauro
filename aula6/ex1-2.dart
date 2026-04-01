double divide(double x, double y) {
  if (y == 0) {
    throw ArgumentError('Não pode dividir por 0.');
  }
  return x / y;
}

void main() {
  try {
    double result1 = divide(2.0, 3.0);
    print('2.0 / 3.0 = $result1');
  } catch (e) {
    print('Erro ao dividir: $e');
  }

  print('');
  try {
    double result2 = divide(2.0, 0.0);
    print('$result2');
  } on ArgumentError catch (e) {
    print('Erro ao dividir: ${e.message}');
  } catch (e) {
    print('$e');
  }
}
