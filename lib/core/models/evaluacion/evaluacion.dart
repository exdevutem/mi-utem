import 'dart:convert';

class REvaluacion {
  String? descripcion;
  num? porcentaje;
  num? nota;

  REvaluacion({
    this.descripcion,
    this.porcentaje,
    this.nota,
  });

  factory REvaluacion.fromJson(Map<String, dynamic> json) => REvaluacion(
    porcentaje: json['ponderador'],
    descripcion: json['descripcion'],
    nota: json['nota'],
  );

  static List<REvaluacion> fromJsonList(List<dynamic>? json) =>
      json?.map((it) => REvaluacion.fromJson(it)).toList() ?? [];

  Map<String, dynamic> toJson() => {
    'ponderador': porcentaje,
    'descripcion': descripcion,
    'nota': nota,
  };

  @override
  String toString() => jsonEncode(toJson());
}

class IEvaluacion extends REvaluacion {
  bool editable;

  IEvaluacion({
    super.porcentaje,
    super.descripcion,
    super.nota,
    this.editable = false,
  });

  factory IEvaluacion.fromRemote(REvaluacion evaluacion) => IEvaluacion(
    descripcion: evaluacion.descripcion,
    porcentaje: evaluacion.porcentaje,
    nota: evaluacion.nota,
  );

  IEvaluacion copyWith({bool? editable, String? descripcion, num? porcentaje, num? nota}) => IEvaluacion(
    editable: editable ?? this.editable,
    descripcion: descripcion ?? this.descripcion,
    porcentaje: porcentaje ?? this.porcentaje,
    nota: nota ?? this.nota,
  );

  @override
  Map<String, dynamic> toJson() => {
    ...super.toJson(),
    "editable": editable,
  };

  @override
  String toString() => jsonEncode(toJson());
}
