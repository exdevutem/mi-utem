import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AsignaturasService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<List<Asignatura>> getAsignaturas([bool refresh = false]) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String carreraId = prefs.getString('carreraId')!;
    String uri = "/v1/carreras/$carreraId/asignaturas";

    try {
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(Duration(days: 7)),
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
        options: buildCacheOptions(Duration(days: 7)),
      );

      Asignatura asignatura = Asignatura.fromJson(response.data);

      return asignatura;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<Asignatura?> getNotasByCodigoAsignatura(
      String? codigo, String? asignaturaId,
      [bool refresh = false]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String carreraId = prefs.getString('carreraId')!;
    String uri = "/v1/carreras/$carreraId/asignaturas/$asignaturaId/notas";

    try {
      Map<String, dynamic> query = {"semestre": false};
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(Duration(days: 7)),
        queryParameters: query,
      );

      List<Asignatura> asignaturas = Asignatura.fromJsonList(response.data);
      if (asignaturas.length > 0) {
        Asignatura asignatura =
            asignaturas.firstWhere((a) => a.codigo == codigo);
        return asignatura;
      } else {
        return null;
      }
    } on DioError catch (e) {
      print(e.message);
      throw e;
    } catch (e) {
      throw e;
    }
  }
}
