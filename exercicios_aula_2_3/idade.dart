int idade({int anoNascimento = 0}) {
  int anoAtual = DateTime.now().year;

  return anoAtual - anoNascimento;
}

void main() {
  int valor = idade(anoNascimento: 1970);
  print(valor);
}
	