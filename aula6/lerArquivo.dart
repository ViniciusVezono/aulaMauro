import 'dart:io';

void main() async {
  final arquivo = File('horas.txt');

  try {
    if (await arquivo.exists()) {
      print('--- Horas Registradas ---');
      
      List<String> linhas = await arquivo.readAsLines();

      if (linhas.isEmpty) {
        print('O arquivo está vazio.');
      } else {
        for (var linha in linhas) {
          print(linha);
        }
      }
    } else {
      print('O arquivo "horas.txt" ainda não foi criado.');
    }
  } catch (e) {
    print('Erro ao ler o arquivo: $e');
  }
}