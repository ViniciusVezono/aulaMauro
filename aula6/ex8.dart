import 'dart:io';

void main() async {
  print('Content-Type: text/html; charset=utf-8\n\n');

  print('''
    <!DOCTYPE html>
    <html>
    <head><title>Lista de Convidados</title></head>
    <body>
      <h1>Convidados do Churrasco</h1>
      <ul>
  ''');

  try {
    final arquivo = File('churrasco.txt');

    if (await arquivo.exists()) {
      List<String> linhas = await arquivo.readAsLines();

      if (linhas.isEmpty) {
        print('<li>Nenhum nome na lista ainda.</li>');
      } else {
        for (var nome in linhas) {
          print('<li>$nome</li>');
        }
      }
    } else {
      print('<li>O arquivo de lista ainda não existe.</li>');
    }
  } catch (e) {
    print('<li>Erro ao ler a lista: $e</li>');
  }

  print('''
      </ul>
      <br>
      <a href="../envianome.html">Adicionar mais pessoas</a>
    </body>
    </html>
  ''');
}