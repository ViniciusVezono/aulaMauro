import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

late Database db;

void main() async {
  db = sqlite3.open('usuarios.db');

  db.execute('''
    CREATE TABLE IF NOT EXISTS usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      idade INTEGER NOT NULL
    );
  ''');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Servidor rodando em http://localhost:8080');

  await for (HttpRequest request in server) {
    if (request.uri.path == '/salvar') {
      await salvarUsuario(request);
    } else {
      await mostrarUsuarios(request);
    }
  }
}

Future<void> salvarUsuario(HttpRequest request) async {
  final params = request.uri.queryParameters;

  String nome = params['nome'] ?? '';
  String idadeStr = params['idade'] ?? '';

  if (nome.isEmpty || idadeStr.isEmpty) {
    request.response
      ..write('Erro: dados incompletos')
      ..close();
    return;
  }

  int? idade = int.tryParse(idadeStr);

  if (idade == null) {
    request.response
      ..write('Idade inválida')
      ..close();
    return;
  }

  db.execute(
    'INSERT INTO usuarios (nome, idade) VALUES (?, ?)',
    [nome, idade],
  );

  request.response
    ..statusCode = 302
    ..headers.set('Location', '/')
    ..close();
}

Future<void> mostrarUsuarios(HttpRequest request) async {
  final resultados = db.select('SELECT * FROM usuarios');

  StringBuffer lista = StringBuffer();

  for (final row in resultados) {
    lista.writeln('<li>${row['nome']} - ${row['idade']} anos</li>');
  }

  String html = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Usuários</title>
</head>
<body>

<h2>Cadastro de Usuário</h2>

<form action="/salvar" method="get">
  Nome: <input type="text" name="nome"><br><br>
  Idade: <input type="number" name="idade"><br><br>
  <button type="submit">Salvar</button>
</form>

<h2>Lista de Usuários</h2>
<ul>
  ${lista.toString()}
</ul>

</body>
</html>
''';

  request.response
    ..headers.contentType = ContentType.html
    ..write(html)
    ..close();
}
