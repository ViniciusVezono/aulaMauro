import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('escola.db');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8083);

  await for (HttpRequest request in server) {
    final res = db.select('SELECT * FROM alunos');

    String lista = '';

    for (var r in res) {
      lista += '<li>${r['prontuario']} - ${r['nome']}</li>';
    }

    request.response
      ..headers.contentType = ContentType.html
      ..write('<h1>Alunos</h1><ul>$lista</ul>')
      ..close();
  }
}