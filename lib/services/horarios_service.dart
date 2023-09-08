import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class HorarioService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Future<Horario> getHorario(
    String carreraId, {
    bool forceRefresh = false,
  }) async {
    final uri = "/v1/carreras/$carreraId/horarios";
    final user = PerfilService.getLocalUsuario();

    try {
      Response response = await _dio.get(
        uri,
        options: buildCacheOptions(
          Duration(days: 30),
          forceRefresh: true,
          subKey: user.rut?.numero.toString(),
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
