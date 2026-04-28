import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final db = sqlite3.open('escola.db');

  db.execute('PRAGMA foreign_keys = ON;');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8085);

  await for (HttpRequest request in server) {
    var prontuario = request.uri.queryParameters['prontuario'];

    if (prontuario == null) {
      request.response
        ..headers.contentType = ContentType.html
        ..write('''
          <h1>Consultar</h1>
          <form>
            Prontuário: <input name="prontuario">
            <button>Buscar</button>
          </form>
        ''')
        ..close();
      continue;
    }

    final aluno = db.select(
      'SELECT nome FROM alunos WHERE prontuario = ?',
      [prontuario],
    );

    final dados = db.select('''
      SELECT d.periodo, c.situacao
      FROM curso c
      JOIN disciplinas d ON d.codigo = c.disciplina_codigo
      WHERE c.aluno_prontuario = ?
    ''', [prontuario]);

    int maiorPeriodo = 0;
    int aprovadas = 0;

    for (var d in dados) {
      if (d['periodo'] > maiorPeriodo) maiorPeriodo = d['periodo'];
      if (d['situacao'] == 'Aprovado') aprovadas++;
    }

    double porcentagem = dados.isEmpty ? 0 : (aprovadas / dados.length) * 100;

    request.response
      ..headers.contentType = ContentType.html
      ..write('''
        <h1>Resultado</h1>
        Nome: ${aluno.first['nome']}<br>
        Maior período: $maiorPeriodo<br>
        Progresso: ${porcentagem.toStringAsFixed(1)}%
      ''')
      ..close();
  }
}
