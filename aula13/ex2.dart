import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  var linguagens = ['HTML', 'CSS', 'JavaScript'];

  // Função filhos refatorada com if...else
  Widget filhos() {
    if (linguagens.length > 3) {
      return Column(
        children: [
          Text(linguagens[0]),
          Text(linguagens[1]),
          Text(linguagens[2]),
          Text(linguagens[3]),
        ],
      );
    } else {
      return Row(
        children: [
          Text(linguagens[0]),
          Text(linguagens[1]),
          Text(linguagens[2]),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: filhos(),
        ),
      ),
    );
  }
}
