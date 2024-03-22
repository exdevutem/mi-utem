

class Rut {
  int rut;

  get dv => _calcularDV();

  Rut(this.rut);

  String _calcularDV() {
    var rutString = rut.toString();
    var suma = 0;
    var multiplo = 2;
    for (var i = rutString.length - 1; i >= 0; i--) {
      suma += int.parse(rutString[i]) * multiplo;
      multiplo++;
      if (multiplo > 7) {
        multiplo = 2;
      }
    }

    final dv = 11 - (suma % 11);
    return dv == 11 ? "0" : (dv == 10 ? "K" : dv.toString());
  }

  static Rut fromString(String rut) {
    if(rut.contains("-")) {
      rut = rut.split("-")[0];
    }

    return Rut(int.parse(rut.replaceAll(".", "")));
  }

  @override
  String toString() {
    final rut = "${this.rut}${dv.toUpperCase()}";
    if (rut.isEmpty) {
      return rut;
    }
    var rutLength = rut.length;
    var verificationDigit = '-${rut.substring(rutLength - 1)}';

    var result = '';
    for (var i = 1; i < rutLength; i += 1) {
      var start = rutLength - i - 1;
      var end = rutLength - i;
      result = '${rut.substring(start, end)}$result';
      if (i % 3 == 0) {
        result = '.$result';
      }
    }
    return '$result$verificationDigit';
  }

}