import 'package:mi_utem/models/evaluacion/evaluacion.dart';

class Grades {
  List<REvaluacion> notasParciales;
  num? notaFinal;
  num? notaPresentacion;
  num? notaExamen;

  Grades({
    this.notasParciales = const [],
    this.notaFinal,
    this.notaPresentacion,
    this.notaExamen,
  });

  factory Grades.fromJson(Map<String, dynamic> json) => Grades(
    notasParciales: REvaluacion.fromJsonList(json['notasParciales']),
    notaFinal: json['notaFinal'] as num?,
    notaPresentacion: json['notaPresentacion'] as num?,
    notaExamen: json['notaExamen'] as num?,
  );

  Map<String, dynamic> toJson() => {
    'notasParciales': notasParciales.map((nota) => nota.toJson()).toList(),
    'notaFinal': notaFinal,
    'notaPresentacion': notaPresentacion,
    'notaExamen': notaExamen,
  };
}
