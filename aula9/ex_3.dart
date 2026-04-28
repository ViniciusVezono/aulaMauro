import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('escola.db');

  db.execute('PRAGMA foreign_keys = ON;');

  db.execute('''
    CREATE TABLE IF NOT EXISTS alunos (
      prontuario TEXT PRIMARY KEY,
      nome TEXT NOT NULL
    );
  ''');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8082);

  await for (HttpRequest request in server) {
    if (request.uri.path == '/salvar') {
      var p = request.uri.queryParameters;

      db.execute(
        'INSERT INTO alunos VALUES (?, ?)',
        [p['prontuario'], p['nome']],
      );

      request.response
        ..statusCode = 302
        ..headers.set('Location', '/')
        ..close();
    } else {
      request.response
        ..headers.contentType = ContentType.html
        ..write('''
          <h1>Cadastro Aluno</h1>
          <form action="/salvar">
            Prontuário: <input name="prontuario"><br>
            Nome: <input name="nome"><br>
            <button>Salvar</button>
          </form>
        ''')
        ..close();
    }
  }
}
