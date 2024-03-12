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

  factory REvaluacion.fromJson(Map<String, dynamic>? json) =>
      json != null ? REvaluacion(
        porcentaje: json[porcentajeKey],
        descripcion: json[descripcionKey],
        nota: json[notaKey],
      ) : REvaluacion();

  static List<REvaluacion> fromJsonList(List<dynamic>? json) =>
      json?.map((it) => REvaluacion.fromJson(it)).toList() ?? [];

  Map<String, dynamic> toJson() => {
    porcentajeKey: porcentaje,
    descripcionKey: descripcion,
    notaKey: nota,
  };
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

  IEvaluacion copyWith({bool? editable, String? descripcion, num? porcentaje, num? nota}) =>
      IEvaluacion(
        editable: editable ?? this.editable,
        descripcion: descripcion ?? this.descripcion,
        porcentaje: porcentaje ?? this.porcentaje,
        nota: nota ?? this.nota,
      );
}
