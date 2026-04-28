import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('escola.db');

  db.execute('PRAGMA foreign_keys = ON;');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8081);

  await for (HttpRequest request in server) {
    final res = db.select('SELECT * FROM disciplinas');

    String lista = '';

    for (var r in res) {
      lista += '''
        <li>${r['codigo']} - ${r['nome']}
        (Período: ${r['periodo']} | Carga: ${r['carga']})
        </li>
      ''';
    }

    request.response
      ..headers.contentType = ContentType.html
      ..write('<h1>Disciplinas</h1><ul>$lista</ul>')
      ..close();
  }
}
