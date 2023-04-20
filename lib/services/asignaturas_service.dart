import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class AsignaturasService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Future<List<Asignatura>> getAsignaturas({
    bool forceRefresh = false,
  }) async {
    final carreraId = box.read('carreraId')!;
    final uri = "/v1/carreras/$carreraId/asignaturas";
    final user = PerfilService.getLocalUsuario();

    try {
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(
          Duration(days: 7),
          forceRefresh: forceRefresh,
          subKey: user.rut?.numero.toString(),
        ),
      );

      List<Asignatura> asignaturas = Asignatura.fromJsonList(response.data);

      return asignaturas;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<Asignatura> getDetalleAsignatura(
    String? codigo, {
    bool forceRefresh = false,
  }) async {
    final uri = "/v1/asignaturas/$codigo";
    final user = PerfilService.getLocalUsuario();

    try {
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(
          Duration(days: 7),
          forceRefresh: forceRefresh,
          subKey: user.rut?.numero.toString(),
        ),
      );

      Asignatura asignatura = Asignatura.fromJson(response.data);

      return asignatura;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
