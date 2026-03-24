class Animal {
  String nome;

  Animal(this.nome);

  void emitirSom() {
    print("$nome está emitindo som");
  }
}

class Gato extends Animal {
  Gato(String nome) : super(nome);

  @override
  void emitirSom() {
    print("Miau");
  }
}


void main() {

  var gato = Gato('theo');
  gato.emitirSom();
}
