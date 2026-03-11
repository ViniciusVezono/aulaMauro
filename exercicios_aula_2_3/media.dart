

double media(List<double> numbers) {
  if (numbers.isEmpty) {
    return 0.0;
  }

  double sum = 0.0;
  for (final number in numbers) {
    sum += number;
  }
  return sum / numbers.length;
}

void main() {
  var notas = [4.5, 9.2, 7.8];
  var notaFinal = media(notas);
  print('Notas: $notas');
  print('Média das notas: $notaFinal');
}
