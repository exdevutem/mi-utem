import 'package:mi_utem/models/evaluacion/grades.dart';

abstract class GradesRepository {

  /* Obtiene las notas de la carrera y asignatura especificada */
  Future<Grades> getGrades({
    required String carreraId,
    required String asignaturaId,
  });
}