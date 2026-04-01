import 'dart:io';
import 'package:env_variables/env_variables.dart';

void main() async {
  print('Content-Type: text/html; charset=utf-8\n\n');

  String dados = EnvVariables.fromEnvironment('QUERY_STRING');
  Uri uri = Uri(query: dados);
  var parametros = uri.queryParameters;
  var nome = parametros["nome"];

  if (nome != null && nome.isNotEmpty) {
    try {
      final arquivo = File('churrasco.txt');
      
      await arquivo.writeAsString('$nome\n', mode: FileMode.append);
      
      print('<h2>$nome foi adicionado à lista do churrasco!</h2>');
      print('<a href="listar_churrasco.exe">Ver lista completa</a>');
    } catch (e) {
      print('Erro ao salvar o nome: $e');
    }
  } else {
    print('Erro: Nenhum nome foi enviado.');
  }
}