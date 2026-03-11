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
  var notas = [8.5, 4.0, 7.5, 9.0, 5.5, 3.0, 10.0, 6.0];

  const double notaMinimaAprovacao = 7.0;

  var notasAprovadasIterable = notas.where(
    (nota) => nota >= notaMinimaAprovacao,
  );

  double mediaNotasAprovadas;

  if (notasAprovadasIterable.isEmpty) {
    mediaNotasAprovadas = 0.0;
  } else {
    final double somaNotasAprovadas = notasAprovadasIterable.fold(
      0.0,
      (acumulador, nota) => acumulador + nota,
    );
    mediaNotasAprovadas = somaNotasAprovadas / notasAprovadasIterable.length;
  }

  print('Todas as notas: $notas');
  print(
    'Notas dos alunos aprovados (>= $notaMinimaAprovacao): ${notasAprovadasIterable.toList()}',
  );
  print(
    'Média das notas dos aprovados: ${mediaNotasAprovadas.toStringAsFixed(2)}',
  );
}
