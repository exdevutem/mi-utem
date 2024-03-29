class Rut {
  int? numero;
  String? dv;

  Rut(this.numero, this.dv);

  Rut.deEntero(int? rut) {
    this.numero = rut;
    this.dv = calcularDv(rut);
  }

  Rut.deString(String? rut) {
    List<String?> separated = separarRutYDv(rut);
    this.numero = separated[0] != null ? int.tryParse(separated[0]!) : null;
    this.dv = separated[1];
  }

  static List<String?> separarRutYDv(String? rutCompleto) {
    if (rutCompleto != null) {
      String limpio = limpiar(rutCompleto);
      if (limpio.length == 0) {
        return [null, null];
      }
      if (limpio.length == 1) {
        return [limpio, null];
      }
      String dv = limpio.substring(limpio.length - 1);
      String rut = limpio.substring(0, limpio.length - 1);
      return [rut, dv];
    }
    return [null, null];
  }

  static String? calcularDv(int? numero) {
    if (numero != null) {
      int suma = 0;
      int multiplicador = 2;
      String rut = numero.toString();
      for (var i = rut.length - 1; i >= 0; i--) {
        String charDigito = String.fromCharCode(rut.runes.elementAt(i));
        suma = suma + int.parse(charDigito) * multiplicador;
        multiplicador = multiplicador >= 7 ? 2 : multiplicador + 1;
      }

      int valor = 11 - (suma % 11);

      switch (valor) {
        case 10:
          return "K";
        case 11:
          return "0";
        default:
          return valor.toString();
      }
    }
    return null;
  }

  bool esValido() {
    return this.dv == calcularDv(this.numero);
  }

  String formateado(bool conSeparadorDeMiles) {
    if (conSeparadorDeMiles) {
      String numeroStr = this.numero.toString();
      String numeroFinal = "";
      int contador = 0;
      for (var i = (numeroStr.runes.length - 1); i >= 0; i--) {
        var char = new String.fromCharCode(numeroStr.runes.elementAt(i));
        contador++;
        numeroFinal += char;
        if (contador == 3) {
          numeroFinal += ".";
          contador = 0;
        }
      }

      numeroFinal =
          new String.fromCharCodes(numeroFinal.runes.toList().reversed);
      return "$numeroFinal-${this.dv}".toUpperCase();
    } else {
      return "${this.numero}-${this.dv}".toUpperCase();
    }
  }

  static String limpiar(String rut) {
    return rut.replaceAll(new RegExp(r'^0+|[^0-9kK]+'), '').toUpperCase();
  }
}
