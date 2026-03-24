class Celular {
  String marca;
  String modelo;
  int bateria;

  Celular(this.marca, this.modelo, this.bateria);

  void mostrarStatus() {
    print('O $marca $modelo está com $bateria% de carga.');
  }
}


void main() {
  var meuCelular = Celular("Motorola", "G34", 15);
  meuCelular.mostrarStatus();

}