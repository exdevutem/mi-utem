class REvaluacion {
  String? descripcion;
  num? porcentaje;
  num? nota;

  static const porcentajeKey = "porcentaje";
  static const descripcionKey = "descripcion";
  static const notaKey = "nota";

  REvaluacion({
    this.descripcion,
    this.porcentaje,
    this.nota,
  });

  factory REvaluacion.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return REvaluacion();
    }
    return REvaluacion(
      porcentaje: json[porcentajeKey],
      descripcion: json[descripcionKey],
      nota: json[notaKey],
    );
  }

  static List<REvaluacion> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<REvaluacion> list = [];
    for (var item in json) {
      list.add(REvaluacion.fromJson(item));
    }
    return list;
  }
}

class IEvaluacion extends REvaluacion {
  bool editable;

  IEvaluacion({
    this.editable = false,
    String? descripcion,
    num? porcentaje,
    num? nota,
  }) : super(
          descripcion: descripcion,
          porcentaje: porcentaje,
          nota: nota,
        );

  factory IEvaluacion.fromRemote(REvaluacion evaluacion) {
    return IEvaluacion(
      descripcion: evaluacion.descripcion,
      porcentaje: evaluacion.porcentaje,
      nota: evaluacion.nota,
    );
  }

  IEvaluacion copyWith(
      {bool? editable, String? descripcion, num? porcentaje, num? nota}) {
    return IEvaluacion(
      editable: editable ?? this.editable,
      descripcion: descripcion ?? this.descripcion,
      porcentaje: porcentaje ?? this.porcentaje,
      nota: nota ?? this.nota,
    );
  }
}
