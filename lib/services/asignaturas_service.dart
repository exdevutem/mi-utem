import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AsignaturasService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<List<Asignatura>> getAsignaturas([bool refresh = false]) async {
    String uri = "/v1/asignaturas";
    
    try {
      Response response = await _dio.get(uri, options: buildCacheOptions(Duration(days: 7), forceRefresh: refresh));

      List<Asignatura> asignaturas = Asignatura.fromJsonList(response.data);

      return asignaturas;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<Asignatura> getDetalleAsignatura(String codigo, [bool refresh = false]) async {
    String uri = "/v1/asignaturas/$codigo";
    
    try {
      Response response = await _dio.get(uri, options: buildCacheOptions(Duration(days: 7), forceRefresh: refresh));

      Asignatura asignatura = Asignatura.fromJson(response.data);

      return asignatura;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<Asignatura> getNotasByCodigoAsignatura(String codigo, [bool refresh = false]) async {
    String uri = "/v1/notas";
    
    try {
      Map<String, dynamic> query = {"semestre": false};
      Response response = await _dio.get(uri, options: buildCacheOptions(Duration(hours: 3), forceRefresh: refresh), queryParameters: query);

      List<Asignatura> asignaturas = Asignatura.fromJsonList(response.data);
      Asignatura asignatura = asignaturas.firstWhere((a) => a.codigo == codigo);

      return asignatura;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}