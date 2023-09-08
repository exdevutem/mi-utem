import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/controllers/grades_changes_controller.dart';
import 'package:mi_utem/models/grades.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class GradesService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Future<Grades> getGrades(
    String carreraId,
    String asignaturaId, {
    bool forceRefresh = false,
    bool saveGrades = true,
  }) async {
    final uri = "/v1/carreras/$carreraId/asignaturas/$asignaturaId/notas";
    final user = PerfilService.getLocalUsuario();

    Response response = await _dio.get(
      uri,
      options: buildCacheOptions(
        Duration(days: 1),
        maxStale: Duration(days: 7),
        forceRefresh: forceRefresh,
        subKey: user.rut?.numero.toString(),
      ),
    );

    Grades grades = Grades.fromJson(response.data);

    if (saveGrades) {
      GradesChangesController.saveGrades(asignaturaId, grades);
    }

    return grades;
  }
}
