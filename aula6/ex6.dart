import 'dart:io';

void main() async {
  final servidor = await HttpServer.bind(InternetAddress.loopbackIPv4, 8080);

  print('Servidor online! Acesse em: http://localhost:8080');

  await for (HttpRequest pedido in servidor) {
    pedido.response.headers.contentType = ContentType.html;

    pedido.response.write('''
      <!DOCTYPE html>
      <html lang="pt-br">
      <head>
        <meta charset="UTF-8">
        <title>Resposta Dart</title>
      </head>
      <body>
        <h1>hello</h1>
      </body>
      </html>
    ''');

    await pedido.response.close();
  }
}
