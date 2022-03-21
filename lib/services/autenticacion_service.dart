import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/carreras_service.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutenticacionService {
  static final Dio _dio = DioMiUtemClient.initDio;

  static final String versionCorrecta = "2.5.2";

  static Future<Usuario> login(String? correo, String? contrasenia,
      [bool guardar = false]) async {
    String uri = "/v1/auth";

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final FlutterSecureStorage storage = new FlutterSecureStorage();

      dynamic data = {'correo': correo, 'contrasenia': contrasenia};

      Response response = await _dio.post(uri, data: data);

      Usuario usuario = Usuario();
      if (response.statusCode == 200) {
        usuario = Usuario.fromJson(response.data);
        prefs.setString('token', usuario.token!);
        if (usuario.nombres != null) {
          prefs.setString('nombres', usuario.nombres!);
        }
        if (usuario.apellidos != null) {
          prefs.setString('apellidos', usuario.apellidos!);
        }
        if (usuario.nombre != null) {
          prefs.setString('nombre', usuario.nombre!);
        }
        if (usuario.fotoUrl != null) {
          prefs.setString('fotoUrl', usuario.fotoUrl!);
        }
        if (usuario.correo != null) {
          prefs.setString('correo', usuario.correo!);
        }
        if (usuario.rut?.numero != null) {
          prefs.setInt('rut', usuario.rut!.numero!);
        }
        prefs.setString('version', versionCorrecta);
        prefs.setBool('esAntiguo', true);

        if (guardar) {
          await storage.write(key: "contrasenia", value: contrasenia);
        }
        Carrera carrera = await CarreraService.getCarreraActiva();
        if (carrera.id != null) {
          prefs.setString('carreraId', carrera.id!);
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var esAntiguo = prefs.getBool("esAntiguo");
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      String? version = prefs.getString("version");
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final FlutterSecureStorage storage = new FlutterSecureStorage();

      prefs.remove("token");
      prefs.remove("correo");
      prefs.remove("nombres");
      prefs.remove("nombre");
      prefs.remove("apellidos");
      prefs.remove("fotoUrl");
      prefs.remove("rut");
      prefs.remove("version");
      await storage.deleteAll();
      await DioMiUtemClient.cacheOptions.store!.clean();
      await PerfilService.deleteFcmToken();
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
}
