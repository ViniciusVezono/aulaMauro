import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('escola.db');

  db.execute('''
    CREATE TABLE IF NOT EXISTS curso (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      aluno TEXT,
      disciplina TEXT,
      situacao TEXT
    );
  ''');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8084);

  await for (HttpRequest request in server) {
    if (request.uri.path == '/salvar') {
      var p = request.uri.queryParameters;

      db.execute(
        'INSERT INTO curso (aluno, disciplina, situacao) VALUES (?, ?, ?)',
        [p['aluno'], p['disciplina'], p['situacao']],
      );

      request.response
        ..write('Salvo!')
        ..close();
    } else {
      request.response
        ..headers.contentType = ContentType.html
        ..write('''
          <h1>Cadastro de Curso</h1>
          <form action="/salvar">
            Aluno: <input name="aluno"><br>
            Disciplina: <input name="disciplina"><br>
            Situação:
            <select name="situacao">
              <option>Aprovado</option>
              <option>Reprovado</option>
              <option>Cursando</option>
            </select><br>
            <button>Salvar</button>
          </form>
        ''')
        ..close();
    }
  }
}