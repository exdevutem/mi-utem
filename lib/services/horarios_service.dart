import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HorarioService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<Horario> getHorario([bool refresh = false]) async {
    String uri = "/v1/horarios";
    
    try {
      Response response = await _dio.get(uri, options: buildCacheOptions(Duration(days: 7), forceRefresh: refresh));

      
      Horario horario = Horario.fromJson(response.data);

      for (var dia in horario.horario) {
        for (var bloque in dia) {
          print("HorarioService bloque ${bloque?.codigo}");
        }
      }

      return horario;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}