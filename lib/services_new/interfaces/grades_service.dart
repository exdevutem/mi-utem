import 'package:mi_utem/models/grades.dart';

abstract class GradesService {

  Future<Grades?> getGrades(String carreraId, String asignaturaId, {bool forceRefresh = false, bool saveGrades = true});

  Future<void> saveGrades(String asignaturaId, Grades grades);

  Future<GradeChangeType> compareGrades(String asignaturaId, Grades grades);

  Future<Map<String, GradeChangeType>> lookForGradeUpdates();
}

enum GradeChangeType {
  weightingsSet,
  weightingsUpdated,
  weightingsDeleted,
  gradeSet,
  gradeUpdated,
  gradeDeleted,
  noChange
}