import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class AuthService {
  static final Dio _dio = DioMiUtemClient.initDio;
  static final GetStorage box = GetStorage();

  static Future<Usuario> login(String correo, String contrasenia) async {
    final uri = "/v1/auth";

    try {
      final data = {'correo': correo, 'contrasenia': contrasenia};
      final response = await _dio.post(uri, data: data);

      return Usuario.fromJson(response.data);
    } catch (e) {
      throw e;
    }
  }

  static Future<String> refreshToken(String correo, String contrasenia) async {
    log("AuthService refreshToken");

    final uri = "/v1/auth/refresh";

    try {
      final data = {'correo': correo, 'contrasenia': contrasenia};

      final response = await DioMiUtemClient.authDio.post(uri, data: data);

      return response.data['token'] as String;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
