class Carro {
  int portas = 0;
  int rodas = 4;
  int velocidade = 0;
  Carro(this.portas);
  String estado() {
    return 'Carro com $portas portas. Velocidade: $velocidade km/h';
  }

  void acelera() {
    velocidade += 5;
  }

  void freiar() {
    velocidade = (velocidade > 10) ? (velocidade - 10) : 0;
  }
}

void main() {
  Carro novo = Carro(4);
  print(novo.velocidade);
  novo.acelera();
  novo.acelera();
  novo.acelera();
  print(novo.velocidade);
  novo.freiar();
  print(novo.velocidade);
  novo.freiar();
  print(novo.velocidade);
}
