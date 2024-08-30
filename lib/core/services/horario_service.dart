import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/horario.dart';
import 'package:mi_utem/core/services/carrera_service.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/core/utils/http/functions.dart';

class HorarioService {

  Future<Horario> getHorario({ bool forceRefresh = false }) async {
    try {
      final carrera = await Get.find<CarreraService>().getCarrera();
      logger.d('*1');
      final response = await sigaClientRequest('estudiante/horario/',
        method: 'POST',
        contentType: Headers.formUrlEncodedContentType,
        forceRefresh: forceRefresh,
        sigaParams: {
          'carrera_id': carrera.id,
        }
      );
      logger.d('*2');

      logger.d('getHorario', response);
      if(response.data['status_code'] != 200) {
        throw CustomException.fromSiga(response.data);
      }

      logger.d('*3', response);
      // Create a matrix of 6x9
      final horario = List.generate(6, (i) => List.generate(9, (j) => []));
      logger.d('Horario', horario);

      throw CustomException(message: 'Error al obtener horario. Intenta más tarde.');
    } catch (e) {
      rethrow;
    }
  }
}