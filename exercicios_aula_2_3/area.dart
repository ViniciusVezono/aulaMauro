import 'dart:math' as math;

double areaCirculo(double radius) {
  double area = math.pi * (radius * radius);
  return area;
}

void main() {
  double r1 = 5.0;
  double area1 = areaCirculo(r1);
  print(area1);
}
