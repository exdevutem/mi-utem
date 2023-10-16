import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class CarreraService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<List<Carrera>> getCarreras({bool forceRefresh = false}) async {
    const uri = "/v1/carreras";
    final user = UserController.to.user.value;

    Response response = await _dio.get(
      uri,
      options: buildCacheOptions(
        Duration(days: 7),
        forceRefresh: forceRefresh,
        subKey: user?.rut?.numero.toString(),
      ),
    );

    List<Carrera> carreras = Carrera.fromJsonList(response.data);

    return carreras;
  }
}
