import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/core/models/evaluacion/grades.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/core/services/carrera_service.dart';
import 'package:mi_utem/core/utils/http/functions.dart';

class GradesService {

  Future<Grades> getGrades(String asignaturaId, { forceRefresh = false }) async {
    try {
      final token = await Get.find<AuthService>().activeToken();
      final carrera = await Get.find<CarreraService>().getCarrera();
      final response = await sigaClientRequest('estudiante/asignaturas/notas/',
        method: 'POST',
        data: 'token=$token&carrera_id=${carrera.id}&seccion_id=$asignaturaId',
        contentType: Headers.formUrlEncodedContentType,
        forceRefresh: forceRefresh,
      );

      if(response.data['status_code'] != 200) {
        throw CustomException.fromSiga(response.data);
      }

      return (response.data['response'] as List<dynamic>).map((it) => Grades.fromJson(it)).toList().first;
    } on DioError catch(e){
      final data = e.response?.data ?? {
        'response': 'Error al obtener notas de asignatura. Intenta más tarde.',
        'status_code': e.response?.statusCode ?? 500,
      };
      logger.e('Error al obtener notas de asignatura $asignaturaId', [e]);
      throw CustomException.fromSiga(data);
    } catch (e) {
      logger.e('Error al obtener notas de asignatura $asignaturaId', [e]);
      throw CustomException.custom(message: 'Error al obtener notas de asignatura. Intenta más tarde.');
    }
  }
}