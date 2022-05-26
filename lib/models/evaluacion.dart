class Evaluacion {
  String descripcion;
  num? porcentaje;
  num? nota;

  Evaluacion({
    this.descripcion = "Nota",
    this.porcentaje,
    this.nota,
  });

  factory Evaluacion.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Evaluacion();
    }
    return Evaluacion(
      porcentaje: json['porcentaje'],
      descripcion: json['descripcion'] ?? "Nota",
      nota: json['nota'],
    );
  }

  static List<Evaluacion> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Evaluacion> list = [];
    for (var item in json) {
      list.add(Evaluacion.fromJson(item));
    }
    return list;
  }
}
