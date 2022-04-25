import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermisosCovidService {
  static final Dio _dio = DioMiUtemClient.baseDio;

  static Future<List<PermisoCovid>> getPermisos() async {
    String uri = "/v1/permisos";

    dynamic data = {
      'correo':
          (await SharedPreferences.getInstance()).getString('correoUtem')!,
      'contrasenia':
          (await (new FlutterSecureStorage()).read(key: 'contrasenia'))!,
    };

    try {
      Response response = await _dio.post(uri, data: data);

      return PermisoCovid.fromJsonList(response.data);
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<dynamic> getDetallesPermiso(String id) async {
    String uri = "/v1/permisos/$id";

    dynamic data = {
      'correo':
          (await SharedPreferences.getInstance()).getString('correoUtem')!,
      'contrasenia':
          (await (new FlutterSecureStorage()).read(key: 'contrasenia'))!,
    };

    try {
      Response response = await _dio.post(uri, data: data);

      return response.data;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
