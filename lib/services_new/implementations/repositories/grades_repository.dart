import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/models/evaluacion/grades.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/services_new/interfaces/repositories/grades_repository.dart';

class GradesRepositoryImplementation extends GradesRepository {

  @override
  Future<Grades> getGrades({required String carreraId, required String asignaturaId}) async {
    final response = await authClient.get(Uri.parse("$apiUrl/v1/carreras/$carreraId/asignaturas/$asignaturaId/notas"));

    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return Grades.fromJson(json as Map<String, dynamic>);
  }
}