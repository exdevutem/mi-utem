import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/horario.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/core/utils/http/functions.dart';

class HorarioService {

  Future<Horario?> getHorario({ bool forceRefresh = false }) async {
    try {
      final token = await Get.find<AuthService>().activeToken();

      final response = await sigaClientRequest('estudiante/horario/',
        method: 'POST',
        data: 'token=$token',
        contentType: Headers.formUrlEncodedContentType,
        forceRefresh: forceRefresh,
      );

      if(response.data['status_code'] != 200) {
        throw CustomException.fromSiga(response.data);
      }

      // Create a matrix of 6x9
      final horario = List.generate(6, (i) => List.generate(9, (j) => []));
      logger.d(horario);
    } catch (e) {

    }
  }
}