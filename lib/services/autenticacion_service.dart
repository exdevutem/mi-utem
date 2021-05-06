import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_utem/models/rut.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/perfil_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutenticacionService {
  static final Dio _dio = DioMiUtemClient.initDio;

  static final String versionCorrecta = "2.5.2";

  static Future<Usuario> login(String correo, String contrasenia, [bool guardar = false]) async {
    String uri = "/v1/usuarios/login";
    
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final FlutterSecureStorage storage = new FlutterSecureStorage();

      dynamic data = {'usuario': correo, 'contrasenia': contrasenia};

      Response response = await _dio.post(uri, data: data);

      Usuario usuario = Usuario.fromJson(response.data);

      prefs.setString('sesion', usuario.sesion);
      prefs.setString('nombres', usuario.nombres);
      prefs.setString('apellidos', usuario.apellidos);
      prefs.setString('nombre', usuario.nombre);
      prefs.setString('fotoUrl', usuario.fotoUrl);
      prefs.setString('correo', usuario.correo);
      prefs.setString('version', versionCorrecta);
      prefs.setInt('rut', usuario.rut?.numero);
      prefs.setBool('esAntiguo', true);
      
      if (guardar) {
        await storage.write(key: "contrasenia", value: contrasenia);
      }
      
      return usuario;
    } on DioError catch (e) {
      print(e.message);
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
      String sesion = prefs.getString("sesion");
      String version = prefs.getString("version");
      bool isLoggedIn = sesion != null && sesion.isNotEmpty && version != null && version.isNotEmpty && version == versionCorrecta;

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

      prefs.remove("sesion");
      prefs.remove("correo");
      prefs.remove("nombres");
      prefs.remove("nombre");
      prefs.remove("apellidos");
      prefs.remove("fotoUrl");
      prefs.remove("rut");
      prefs.remove("version");
      await storage.deleteAll();
      await DioMiUtemClient.cacheOptions.store.clean();
      await PerfilService.deleteFcmToken();
    } catch (e) {
      print(e.message);
      throw e;
    }
  }
}