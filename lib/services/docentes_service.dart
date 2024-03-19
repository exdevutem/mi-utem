import 'package:dio/dio.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/utils/dio_docente_client.dart';

class DocentesService {
  static final Dio _dio = DioDocenteClient.initDio;

  static Future<String> generarImagenPerfil(User user) async {
    String baseUrl = "https://mi.utem.cl/static/interdocs/fotos/";
    List<String> formatos = [".jpg", ".jpeg", ".png", ".gif"];

    String imageUrl = "$baseUrl${user.rut?.rut}${formatos[0]}";

    for (final formato in formatos) {
      String actualImageUrl = "$baseUrl${user.rut?.rut}$formato";
      final imageResponse = await authClient.head(Uri.parse(actualImageUrl));

      if (imageResponse.statusCode == 200) {
        imageUrl = actualImageUrl;
        return imageUrl;
      }
    }

    return imageUrl;
  }

  static Future<List<User>> buscarDocentes(String nombre) async {
    String uri = "/docentes/buscar";

    try {
      dynamic data = {"nombre": nombre};

      Response response = await _dio.get(uri, queryParameters: data);

      List<User> usuarios = User.fromJsonList(response.data["docentes"]);
      List<User> usuariosConFoto = [];
      for (var usuario in usuarios) {
        User usuarioConFoto = usuario;

        usuarioConFoto.fotoUrl = await generarImagenPerfil(usuario);
        usuariosConFoto.add(usuarioConFoto);
      }
      return usuariosConFoto;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<User> traerUnDocente(String? nombre) async {
    String uri = "/docentes/buscar";

    try {
      dynamic data = {"nombre": nombre, "limit": 1};

      Response response = await _dio.get(uri, queryParameters: data);

      User user = User.fromJson(response.data);
      user.fotoUrl = await generarImagenPerfil(user);
      return user;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<User> asignarUnDocente(String? nombreDocente, String? codigoAsignatura, String? nombreAsignatura) async {
    String uri = "/docentes/asignar";

    try {
      dynamic data = {
        "nombreDocente": nombreDocente,
        "codigoAsignatura": codigoAsignatura,
        "nombreAsignatura": nombreAsignatura
      };

      Response response = await _dio.post(uri, data: data);

      User user = User.fromJson(response.data);
      user.fotoUrl = await generarImagenPerfil(user);
      return user;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
