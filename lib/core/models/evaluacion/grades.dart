import 'package:mi_utem/core/models/evaluacion/evaluacion.dart';

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
    notasParciales: REvaluacion.fromJsonList(json['notas_parciales']),
    notaFinal: json['nota_final_asignatura'] as num?,
    notaPresentacion: json['nota_seccion_asignatura'] as num?,
    notaExamen: json['nota_examen'] as num?,
  );

  Map<String, dynamic> toJson() => {
    'notas_parciales': notasParciales.map((nota) => nota.toJson()).toList(),
    'nota_final': notaFinal,
    'nota_presentacion': notaPresentacion,
    'nota_examen': notaExamen,
  };
}
