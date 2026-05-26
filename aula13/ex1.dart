import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    var linguagens = ['HTML', 'CSS', 'JavaScript'];
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: (linguagens.length > 3)
              ? Column(children: [
                  Text(linguagens[0]),
                  Text(linguagens[1]),
                  Text(linguagens[2]),
                  Text(linguagens[3]),
                ])
              : Row(children: [
                  Text(linguagens[0]),
                  Text(linguagens[1]),
                  Text(linguagens[2]),
                ]),
        ),
      ),
    );
  }
}
