import 'dart:io';

void main() async {
  final arquivo = File('horas.txt');
  
  String horaAtual = DateTime.now().toString();

  try {
    await arquivo.writeAsString('$horaAtual\n', mode: FileMode.append);
    print('Hora salva com sucesso: $horaAtual');
  } catch (e) {
    print('Erro ao salvar no arquivo: $e');
  }
}