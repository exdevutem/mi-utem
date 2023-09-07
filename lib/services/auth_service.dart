import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class AuthService {
  static final Dio _dio = DioMiUtemClient.initDio;
  static final GetStorage box = GetStorage();

  static Future<Usuario> login(String? correo, String? contrasenia,
      [bool guardar = false]) async {
    String uri = "/v1/auth";

    try {
      final FlutterSecureStorage storage = new FlutterSecureStorage();

      dynamic data = {'correo': correo, 'contrasenia': contrasenia};

      Response response = await _dio.post(uri, data: data);

      Usuario usuario = Usuario();
      if (response.statusCode == 200) {
        usuario = Usuario.fromJson(response.data);
        box.write('token', usuario.token!);
        if (usuario.nombres != null) {
          box.write('nombres', usuario.nombres!);
        }
        if (usuario.apellidos != null) {
          box.write('apellidos', usuario.apellidos!);
        }
        if (usuario.nombre != null) {
          box.write('nombre', usuario.nombre!);
        }
        if (usuario.fotoUrl != null) {
          box.write('fotoUrl', usuario.fotoUrl!);
        }
        if (usuario.correoUtem != null) {
          box.write('correoUtem', usuario.correoUtem!);
        }
        if (usuario.correoPersonal != null) {
          box.write('correoPersonal', usuario.correoPersonal!);
        }
        if (usuario.rut?.numero != null) {
          box.write('rut', usuario.rut!.numero!);
        }
        box.write('esAntiguo', true);

        if (guardar) {
          await storage.write(key: "contrasenia", value: contrasenia);
        }
      }
      return usuario;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    } catch (e) {
      throw e;
    }
  }

  static Future<bool> esPrimeraVez() async {
    try {
      bool? esAntiguo = box.read("esAntiguo");
      if (esAntiguo == null) {
        return true;
      } else {
        return !esAntiguo;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static bool isLoggedIn() {
    try {
      String? token = box.read("token");
      bool isLoggedIn = token != null && token.isNotEmpty;

      return isLoggedIn;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> logOut() async {
    try {
      final FlutterSecureStorage storage = new FlutterSecureStorage();

      box.remove("token");
      box.remove("correo");
      box.remove("nombres");
      box.remove("nombre");
      box.remove("apellidos");
      box.remove("fotoUrl");
      box.remove("rut");
      await storage.deleteAll();
      try {
        await PerfilService.deleteFcmToken();
      } catch (e) {}
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  static Future<String> refreshToken() async {
    String uri = "/v1/auth/refresh";

    try {
      final FlutterSecureStorage secureStorage = new FlutterSecureStorage();

      String? correo = box.read("correoUtem");
      String? contrasenia = await secureStorage.read(key: "contrasenia");

      if (correo != null && contrasenia != null) {
        dynamic data = {'correo': correo, 'contrasenia': contrasenia};

        Response response = await DioMiUtemClient.authDio.post(uri, data: data);

        String token = response.data['token'];
        _storeToken(token);

        return token;
      }
      throw Exception("No se pudo refrescar el token");
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  static void _storeToken(String token) async {
    box.write('token', token);
  }

  static String getToken() {
    final token = box.read('token');
    if (token == null) throw Exception("No se ha encontrado el token");

    return token;
  }

  static void invalidateToken() async {
    box.remove('token');
  }
}
