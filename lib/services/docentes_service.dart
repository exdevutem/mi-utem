import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:mi_utem/models/rut.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/utils/dio_docente_client.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DocentesService {
  static final Dio _dio = DioDocenteClient.initDio;

  static Future<String> generarImagenPerfil(Usuario usuario) async {
    String baseUrl = "https://mi.utem.cl/static/interdocs/fotos/";
    List<String> formatos = [".jpg", ".jpeg", ".png", ".gif"];

    String imageUrl = "$baseUrl${usuario.rut.numero}${formatos[0]}";

    for (var formato in formatos) {
      String actualImageUrl = "$baseUrl${usuario.rut.numero}$formato";
      final imageResponse =
        await http.head(Uri.parse(actualImageUrl));

      if (imageResponse.statusCode == 200) {
        imageUrl = actualImageUrl;
        return imageUrl;
      }
    }

    return imageUrl;
  }

  static Future<List<Usuario>> buscarDocentes(String nombre) async {
    String uri = "/docentes/buscar";
    
    try {
      dynamic data = {"nombre": nombre};

      Response response = await _dio.get(uri, queryParameters: data);

      List<Usuario> usuarios = Usuario.fromJsonList(response.data["docentes"]);
      List<Usuario> usuariosConFoto = [];
      for (var usuario in usuarios) {
        
        Usuario usuarioConFoto = usuario;
        
        usuarioConFoto.fotoUrl = await generarImagenPerfil(usuario);
        usuariosConFoto.add(usuarioConFoto);
      }
      return usuariosConFoto;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<Usuario> traerUnDocente(String nombre) async {
    String uri = "/docentes/buscar";
    
    try {
      dynamic data = {"nombre": nombre, "limit": 1};

      Response response = await _dio.get(uri, queryParameters: data);

      Usuario usuario = Usuario.fromJson(response.data);

      Usuario usuarioConFoto = usuario;
      usuarioConFoto.fotoUrl = await generarImagenPerfil(usuario);
      
      return usuarioConFoto;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<Usuario> asignarUnDocente(String nombreDocente, String codigoAsignatura, String nombreAsignatura) async {
    String uri = "/docentes/asignar";
    
    try {
      dynamic data = {"nombreDocente": nombreDocente, "codigoAsignatura": codigoAsignatura, "nombreAsignatura": nombreAsignatura};

      Response response = await _dio.post(uri, data: data);

      Usuario usuario = Usuario.fromJson(response.data);

      Usuario usuarioConFoto = usuario;
      usuarioConFoto.fotoUrl = await generarImagenPerfil(usuario);
      
      return usuarioConFoto;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

}