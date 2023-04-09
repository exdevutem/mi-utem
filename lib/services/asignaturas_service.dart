import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class AsignaturasService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Future<List<Asignatura>> getAsignaturas([bool refresh = false]) async {
    String carreraId = box.read('carreraId')!;
    String uri = "/v1/carreras/$carreraId/asignaturas";

    try {
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(
          Duration(days: 7),
          forceRefresh: refresh,
        ),
      );

      List<Asignatura> asignaturas = Asignatura.fromJsonList(response.data);

      return asignaturas;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<Asignatura> getDetalleAsignatura(String? codigo,
      [bool refresh = false]) async {
    String uri = "/v1/asignaturas/$codigo";

    try {
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(
          Duration(days: 7),
          forceRefresh: refresh,
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
