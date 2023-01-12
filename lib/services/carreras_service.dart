import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class CarreraService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<List<Carrera>> getCarreras([bool refresh = false]) async {
    String uri = "/v1/carreras";

    Response response = await _dio.get(
      uri,
      options: buildCacheOptions(
        Duration(days: 7),
        forceRefresh: refresh,
      ),
    );

    List<Carrera> carreras = Carrera.fromJsonList(response.data);

    return carreras;
  }

  static Future<Carrera> getCarreraActiva([bool refresh = false]) async {
    String uri = "/v1/carreras";

    Response response = await _dio.get(
      uri,
      options: buildCacheOptions(
        Duration(days: 7),
        forceRefresh: refresh,
      ),
    );

    List<Carrera> carreras = Carrera.fromJsonList(response.data);

    final estados = ["Regular", "Causal de Eliminacion"]
        .reversed
        .map((e) => e.toLowerCase())
        .toList();

    carreras.sort(
      (a, b) => estados.indexOf(b.estado!.toLowerCase()).compareTo(
            estados.indexOf(a.estado!.toLowerCase()),
          ),
    );

    Carrera activa = carreras.first;

    return activa;
  }
}
