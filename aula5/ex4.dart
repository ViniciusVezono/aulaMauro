abstract class Forma {
  String cor;
  Forma(this.cor);
  String paraSVG();
}

class Painel {
  List<Forma> formas = [];
  void adicionar(Forma f) => formas.add(f);
  void imprimirCodigo() {
    print('<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500">');
    for (var forma in formas) {
      print(' ${forma.paraSVG()}');
    }
    print('</svg>');
  }
}

class Circulo extends Forma {
  double centroX, centroY, raio;

  Circulo(this.centroX, this.centroY, this.raio, String cor) : super(cor);

  @override
  String paraSVG() {
    return '<circle cx="$centroX" cy="$centroY" r="$raio" fill="$cor" />';
  }
}

void main() {
  var meuDesenho = Painel();

  meuDesenho.adicionar(Circulo(50, 50, 30, "blue"));

  meuDesenho.imprimirCodigo();
}
