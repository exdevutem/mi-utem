import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/asignaturas/asignatura.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/core/services/carrera_service.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/core/utils/http/functions.dart';

class AsignaturasService {
  
  Future<List<Asignatura>> getAsignaturas({ bool forceRefresh = false}) async {
    try {
      final token = await Get.find<AuthService>().activeToken();
      final carrera = await Get.find<CarreraService>().getCarrera();
      final response = await sigaClientRequest('estudiante/asignaturas/',
        method: 'POST',
        data: 'token=$token&carrera_id=${carrera.id}',
        forceRefresh: forceRefresh,
        contentType: Headers.formUrlEncodedContentType,
      );

      final data = response.data;
      if(data['status_code'] != 200) {
        throw CustomException.fromSiga(data);
      }

      return (data['response'] as List<dynamic>).map<Asignatura>((e) => Asignatura.fromJson(e)).toList();
    } on DioError catch(e) {
      logger.e('Error al obtener asignaturas', [e]);
      final data = e.response?.data ?? {
        'response': 'Error al obtener asignaturas. Por favor intenta nuevamente.',
        'status_code': 500,
      };

      throw CustomException.fromSiga(data);
    } catch(e) {
      logger.e('Error al obtener asignaturas', [e]);
      rethrow;
    }
  }
}