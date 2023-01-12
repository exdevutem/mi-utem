import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class HorarioService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Future<Horario> getHorario([bool refresh = false]) async {
    final String carreraId = box.read('carreraId')!;
    String uri = "/v1/carreras/$carreraId/horarios";

    try {
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(
          Duration(days: 30),
          forceRefresh: refresh,
        ),
      );

      Horario horario = Horario.fromJson(response.data);

      return horario;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
