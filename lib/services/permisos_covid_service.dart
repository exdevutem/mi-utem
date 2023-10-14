import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class PermisosCovidService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Future<List<PermisoCovid>> getPermisos(
      {bool forceRefresh = false}) async {
    const uri = "/v1/permisos";

    final user = UserController.to.getUser();

    logger.d("Obteniendo permisos de ${user.rut?.numero}");

    try {
      Response response = await _dio.post(
        uri,
        options: buildCacheOptions(
          Duration(days: 300),
          maxStale: Duration(days: 300),
          forceRefresh: forceRefresh,
          subKey: user.rut?.numero.toString(),
        ),
      );

      return PermisoCovid.fromJsonList(response.data);
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<PermisoCovid> getDetallesPermiso(
    String id, {
    bool forceRefresh = false,
  }) async {
    final uri = "/v1/permisos/$id";

    final user = UserController.to.getUser();

    try {
      Response response = await _dio.post(
        uri,
        options: buildCacheOptions(
          Duration(days: 180),
          maxStale: Duration(days: 365),
          forceRefresh: forceRefresh,
          subKey: user.rut?.numero.toString(),
        ),
      );

      return PermisoCovid.fromJson(response.data);
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
