import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('escola.db');

  db.execute('PRAGMA foreign_keys = ON;');

  db.execute('''
    CREATE TABLE IF NOT EXISTS curso (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      aluno_prontuario TEXT NOT NULL,
      disciplina_codigo TEXT NOT NULL,
      situacao TEXT NOT NULL,

      FOREIGN KEY (aluno_prontuario) REFERENCES alunos(prontuario),
      FOREIGN KEY (disciplina_codigo) REFERENCES disciplinas(codigo)
    );
  ''');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8084);

  await for (HttpRequest request in server) {
    if (request.uri.path == '/salvar') {
      var p = request.uri.queryParameters;

      try {
        db.execute(
          'INSERT INTO curso (aluno_prontuario, disciplina_codigo, situacao) VALUES (?, ?, ?)',
          [p['aluno'], p['disciplina'], p['situacao']],
        );

        request.response.write('Salvo com sucesso!');
      } catch (e) {
        request.response.write('Erro: aluno ou disciplina não existe!');
      }

      request.response.close();
    } else {
      request.response
        ..headers.contentType = ContentType.html
        ..write('''
          <h1>Cadastro Curso</h1>
          <form action="/salvar">
            Prontuário: <input name="aluno"><br>
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
