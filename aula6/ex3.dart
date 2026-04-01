import 'dart:async';

Future<void> imprimeDemorado(String message) async {
  await Future.delayed(Duration(seconds: 1));
  print(message);
}

void main() async {
  print('hello');
  await imprimeDemorado('world');
}
