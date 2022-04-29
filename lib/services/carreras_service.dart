import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class CarreraService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<List<Carrera>> getCarreras([bool refresh = false]) async {
    String uri = "/v1/carreras";

    Response response = await _dio.get(
      uri,
      options: buildCacheOptions(Duration(days: 7)),
    );

    List<Carrera> carreras = Carrera.fromJsonList(response.data);

    return carreras;
  }

  static Future<Carrera> getCarreraActiva([bool refresh = false]) async {
    String uri = "/v1/carreras";

    Response response = await _dio.get(
      uri,
      options: buildCacheOptions(Duration(days: 7)),
    );

    List<Carrera> carreras = Carrera.fromJsonList(response.data);
    Carrera activa = carreras
        .firstWhere((carrera) => carrera.estado!.toLowerCase() == "regular");

    return activa;
  }
}
