void main() {
  for (int mes = 1; mes <= 12; mes++) {
    switch (mes) {
      case 4:
        print('$mes - Tiradentes');
      case 5:
        print('$mes - Dia do trabalhador');
      case 9:
        print('$mes - Independência do Brasil');
      case 12:
        print('$mes - Natal');
      default:
        print('$mes');
    }
  }
}
