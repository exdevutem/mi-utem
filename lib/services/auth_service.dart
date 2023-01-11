import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/carreras_service.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class AuthService {
  static final Dio _dio = DioMiUtemClient.initDio;
  static final GetStorage box = GetStorage();

  static final String versionCorrecta = "2.5.2";

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
        box.write('version', versionCorrecta);
        box.write('esAntiguo', true);

        if (guardar) {
          await storage.write(key: "contrasenia", value: contrasenia);
        }
        Carrera carrera = await CarreraService.getCarreraActiva();
        if (carrera.id != null) {
          box.write('carreraId', carrera.id!);
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

  static Future<bool> isLoggedIn() async {
    try {
      String? token = box.read("token");
      String? version = box.read("version");
      bool isLoggedIn = token != null &&
          token.isNotEmpty &&
          version != null &&
          version.isNotEmpty &&
          version == versionCorrecta;

      if (!isLoggedIn) {
        await logOut();
      }

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
      box.remove("version");
      await storage.deleteAll();
      await DioMiUtemClient.dioCacheManager.clearAll();
      try {
        await PerfilService.deleteFcmToken();
      } catch (e) {}
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  static Future<String> refreshToken() async {
    String uri = "/v1/auth";

    try {
      final FlutterSecureStorage secureStorage = new FlutterSecureStorage();

      String? correo = box.read("correoUtem");
      String? contrasenia = await secureStorage.read(key: "contrasenia");

      if (correo != null && contrasenia != null) {
        dynamic data = {'correo': correo, 'contrasenia': contrasenia};

        Response response = await DioMiUtemClient.initDio.post(uri, data: data);

        Usuario usuario = Usuario.fromJson(response.data);
        _storeToken(usuario.token!);

        return usuario.token!;
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
