import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

late Database db;

void main() async {
  db = sqlite3.open('carros.db');

  db.execute('''
    CREATE TABLE IF NOT EXISTS carros (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      cor TEXT NOT NULL,
      rodas TEXT NOT NULL,
      potencia INTEGER NOT NULL,
      suspensao TEXT NOT NULL
    );
  ''');

  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Servidor rodando em http://localhost:8080');

  await for (HttpRequest request in server) {
    if (request.uri.path == '/salvar') {
      await salvarCarros(request);
    } else {
      await mostrarCarros(request);
    }
  }
}

Future<void> salvarCarros(HttpRequest request) async {
  final params = request.uri.queryParameters;

  String nome = params['carName'] ?? '';
  String cor = params['carColor'] ?? '';
  String rodas = params['wheelType'] ?? '';
  String potenciaStr = params['enginePower'] ?? '';
  String suspensao = params['suspension'] ?? '';

  if (nome.isEmpty ||
      cor.isEmpty ||
      rodas.isEmpty ||
      potenciaStr.isEmpty ||
      suspensao.isEmpty) {
    request.response
      ..write('Erro: dados incompletos')
      ..close();
    return;
  }

  int? potencia = int.tryParse(potenciaStr);

  if (potencia == null) {
    request.response
      ..write('Potência inválida')
      ..close();
    return;
  }

  db.execute(
    'INSERT INTO carros (nome, cor, rodas, potencia, suspensao) VALUES (?, ?, ?, ?, ?)',
    [nome, cor, rodas, potencia, suspensao],
  );

  request.response
    ..statusCode = 302
    ..headers.set('Location', '/')
    ..close();
}

Future<void> mostrarCarros(HttpRequest request) async {
  final resultados = db.select('SELECT * FROM carros');

  StringBuffer lista = StringBuffer();

  for (final row in resultados) {
    lista.writeln('''
      <li>
        <strong>${row['nome']}</strong><br>
        Cor: <span style="color:${row['cor']}">${row['cor']}</span><br>
        Rodas: ${row['rodas']}<br>
        Potência: ${row['potencia']}<br>
        Suspensão: ${row['suspensao']}
      </li><br>
    ''');
  }

  String html = '''
<!DOCTYPE html>
<html lang="pt-br">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Garagem de Personalização</title>

<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background-color: #1a1a2e;
    color: #ffffff;
    display: flex;
    justify-content: center;
    padding: 20px;
}
.container {
    background-color: #16213e;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.5);
    width: 100%;
    max-width: 500px;
}
h1 { text-align: center; color: #4ecca3; }
.form-group { margin-bottom: 20px; }
label { display: block; margin-bottom: 8px; font-weight: bold; }

input[type="text"], select, input[type="range"] {
    width: 100%;
    padding: 10px;
    border-radius: 5px;
    border: none;
    background: #0f3460;
    color: white;
}

.stats-display {
    background: #0f3460;
    padding: 15px;
    border-radius: 8px;
    margin-top: 20px;
    border-left: 5px solid #4ecca3;
}

button {
    width: 100%;
    padding: 12px;
    background-color: #4ecca3;
    border: none;
    border-radius: 5px;
    color: #1a1a2e;
    font-weight: bold;
    cursor: pointer;
    font-size: 16px;
    transition: 0.3s;
}
button:hover { background-color: #45b291; }
</style>
</head>

<body>

<div class="container">
    <h1>Customizar Carro</h1>
    
    <form action="/salvar" method="get">
        <div class="form-group">
            <label>Nome do Veículo:</label>
            <input type="text" name="carName" placeholder="Ex: Relâmpago Azul">
        </div>

        <div class="form-group">
            <label>Cor da Pintura:</label>
            <input type="color" name="carColor" value="#ff0000" style="width: 100%; height: 40px; border: none; cursor: pointer;">
        </div>

        <div class="form-group">
            <label>Estilo das Rodas:</label>
            <select name="wheelType">
                <option value="esportiva">Esportiva (Leve)</option>
                <option value="offroad">Off-Road (Tração)</option>
                <option value="classica">Clássica (Estilo)</option>
            </select>
        </div>

        <div class="form-group">
            <label>Potência do Motor:</label>
            <input type="range" name="enginePower" min="1" max="10" value="5">
        </div>

        <div class="form-group">
            <label>Configuração de Suspensão:</label>
            <input type="radio" name="suspension" value="baixa" checked> Baixa<br>
            <input type="radio" name="suspension" value="alta"> Alta
        </div>

        <button type="submit">Salvar</button>
    </form>

    <h2>Carros criados</h2>
    <ul>
        ${lista.toString()}
    </ul>
</div>

</body>
</html>
''';

  request.response
    ..headers.contentType = ContentType.html
    ..write(html)
    ..close();
}
