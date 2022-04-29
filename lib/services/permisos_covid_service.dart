import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermisosCovidService {
  static final Dio _dio = DioMiUtemClient.baseDio;

  static Future<List<PermisoCovid>> getPermisos([bool refresh = false]) async {
    String uri = "/v1/permisos";

    dynamic data = {
      'correo':
          (await SharedPreferences.getInstance()).getString('correoUtem')!,
      'contrasenia':
          (await (new FlutterSecureStorage()).read(key: 'contrasenia'))!,
    };

    try {
      Response response = await _dio.post(
        uri,
        data: data,
        options: buildCacheOptions(
          Duration(days: 30),
          maxStale: Duration(days: 365),
        ),
      );

      return PermisoCovid.fromJsonList(response.data);
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<PermisoCovid> getDetallesPermiso(String id) async {
    String uri = "/v1/permisos/$id";

    dynamic data = {
      'correo':
          (await SharedPreferences.getInstance()).getString('correoUtem')!,
      'contrasenia':
          (await (new FlutterSecureStorage()).read(key: 'contrasenia'))!,
    };

    try {
      Response response = await _dio.post(
        uri,
        data: data,
        options: buildCacheOptions(
          Duration(days: 180),
          maxStale: Duration(days: 365),
        ),
      );

      return PermisoCovid.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
