import 'package:dio/dio.dart';
import 'package:mi_utem/core/models/carrera.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/core/utils/http/functions.dart';

class CarreraService {

  Future<Carrera> getCarrera({ bool forceRefresh = false }) async {
    try {
      final response = await sigaClientRequest('estudiante/carreras/',
        method: 'POST',
        contentType: Headers.formUrlEncodedContentType,
        forceRefresh: forceRefresh,
      );

      if(response.data['status_code'] != 200) {
        throw CustomException.fromSiga(response.data);
      }

      final carreras = (response.data['response'] as List<dynamic>).map((it) => Carrera.fromJson(it)).toList();
      final estados = ["Regular", "Causal de Eliminacion"]
          .reversed
          .map((e) => e.toLowerCase())
          .toList();

      carreras.sort((a,b) => estados.indexOf(b.estado.toLowerCase()).compareTo(estados.indexOf(a.estado.toLowerCase())));
      return carreras.first;
    } on DioError catch(e) {
      final data = e.response?.data ?? {
        'response': 'Error al obtener carrera. Por favor intenta nuevamente.',
        'status_code': 500,
      };
      logger.e('Error al obtener carrera', [e]);
      throw CustomException.fromSiga(data);
    } catch(e) {
      logger.e('Error al obtener carrera', [e]);
      rethrow;
    }
  }
}