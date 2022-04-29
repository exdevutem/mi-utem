import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HorarioService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<Horario> getHorario([bool refresh = false]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String carreraId = prefs.getString('carreraId')!;
    String uri = "/v1/carreras/$carreraId/horarios";

    try {
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(Duration(days: 30)),
      );

      Horario horario = Horario.fromJson(response.data);

      for (var dia in horario.horario!) {
        for (var bloque in dia) {
          print("HorarioService bloque ${bloque.codigo}");
        }
      }

      return horario;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
