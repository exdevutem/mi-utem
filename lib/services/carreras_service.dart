import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class CarreraService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<List<Carrera>> getCarreras([bool refresh = false]) async {
    String uri = "/v1/carreras";

    try {
      Response response = await _dio.get(
        uri,
        options: DioMiUtemClient.cacheOptions
            .copyWith(
                maxStale: Duration(days: 0),
                policy: refresh ? CachePolicy.refresh : CachePolicy.request)
            .toOptions(),
      );

      List<Carrera> carreras = Carrera.fromJsonList(response.data);

      return carreras;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<Carrera> getCarreraActiva([bool refresh = false]) async {
    String uri = "/v1/carreras/activa";

    try {
      Response response = await _dio.get(
        uri,
        options: DioMiUtemClient.cacheOptions
            .copyWith(
                maxStale: Duration(days: 7),
                policy: refresh ? CachePolicy.refresh : CachePolicy.request)
            .toOptions(),
      );

      Carrera activa = Carrera.fromJson(response.data);

      return activa;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
