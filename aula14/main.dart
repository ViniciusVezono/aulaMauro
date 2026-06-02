import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  double media(List<double> notas) {
    if (notas.isEmpty) return 0.0;
    double soma = 0.0;
    for (var nota in notas) {
      soma += nota;
    }
    return soma / notas.length;
  }

  double maiorNota(List<double> notas) {
    if (notas.isEmpty) return 0.0;
    return notas.reduce(max);
  }

  double menorNota(List<double> notas) {
    if (notas.isEmpty) return 0.0;
    return notas.reduce(min);
  }

  @override
  Widget build(BuildContext context) {
    var notas = [5.0, 6.5, 8.2];

    var resultadoMedia = media(notas);
    var resultadoMaior = maiorNota(notas);
    var resultadoMenor = menorNota(notas);

    var msg = "Média: ${resultadoMedia.toStringAsFixed(2)}\n"
        "Maior Nota: ${resultadoMaior.toStringAsFixed(2)}\n"
        "Menor Nota: ${resultadoMenor.toStringAsFixed(2)}";

    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text(msg, textAlign: TextAlign.center)),
      ),
    );
  }
}
