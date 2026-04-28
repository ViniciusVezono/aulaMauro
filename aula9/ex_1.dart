import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('escola.db');

  db.execute('''
    CREATE TABLE IF NOT EXISTS disciplinas (
      codigo TEXT PRIMARY KEY,
      nome TEXT,
      periodo INTEGER,
      carga INTEGER
    );
  ''');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  await for (HttpRequest request in server) {
    if (request.uri.path == '/salvar') {
      var p = request.uri.queryParameters;

      db.execute(
        'INSERT INTO disciplinas VALUES (?, ?, ?, ?)',
        [p['codigo'], p['nome'], p['periodo'], p['carga']],
      );

      request.response
        ..statusCode = 302
        ..headers.set('Location', '/')
        ..close();
    } else {
      request.response
        ..headers.contentType = ContentType.html
        ..write('''
          <h1>Cadastrar Disciplina</h1>
          <form action="/salvar">
            Código: <input name="codigo"><br>
            Nome: <input name="nome"><br>
            Período: <input name="periodo"><br>
            Carga: <input name="carga"><br>
            <button>Salvar</button>
          </form>
        ''')
        ..close();
    }
  }
}