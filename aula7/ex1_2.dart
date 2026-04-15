import 'dart:io';

void main() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);
  print('Servidor rodando em http://localhost:8080');
  await for (HttpRequest request in server) {
    await salvarDadosEAtualizarRelatorio(request);
  }
}

Future<void> salvarDadosEAtualizarRelatorio(HttpRequest request) async {
  final params = request.uri.queryParameters;
  String nome = params['nome'] ?? '';
  String sexo = params['sexo'] ?? '';
  String bebida = params['bebida'] ?? '';
  if (nome.isEmpty || sexo.isEmpty || bebida.isEmpty) {
    request.response
      ..write('Erro: dados incompletos')
      ..close();
    return;
  }
  String linha = '$nome | $sexo | $bebida\n';
  File lista = File('lista.txt');
  await lista.writeAsString(linha, mode: FileMode.append);
  List<String> linhas = await lista.readAsLines();
  int totalCarne = 0;
  int totalRefri = 0;
  int totalCerveja = 0;
  for (var l in linhas) {
    if (l.trim().isEmpty) continue;
    var partes = l.split('|');
    if (partes.length < 3) continue;
    String s = partes[1].trim().toUpperCase();
    if (s == 'M') {
      totalCarne += 200;
      totalRefri += 500;
      totalCerveja += 600;
    } else if (s == 'F') {
      totalCarne += 150;
      totalRefri += 400;
      totalCerveja += 500;
    }
  }
  String relatorio =
      ''' ===== RELATÓRIO DO CHURRASCO ===== Carne: ${totalCarne} g (${(totalCarne / 1000).toStringAsFixed(2)} kg) Refrigerante: ${totalRefri} ml (${(totalRefri / 1000).toStringAsFixed(2)} L) Cerveja: ${totalCerveja} ml (${(totalCerveja / 1000).toStringAsFixed(2)} L) ''';
  File('relatorio.txt').writeAsStringSync(relatorio);
  request.response
    ..write('Dados salvos com sucesso!<br>')
    ..write('Relatório atualizado em relatorio.txt')
    ..close();
}
