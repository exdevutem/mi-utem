import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/permiso_ingreso.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/core/utils/http/functions.dart';

class PermisosService {

  Future<List<PermisoIngreso>> getPermisos({ bool forceRefresh = false }) async {
    String token = await Get.find<AuthService>().activeTokenExdev();

    try {
      final response = await authClientRequest('permisos',
        method: 'POST',
        ttl: Duration(days: 30),
        forceRefresh: forceRefresh,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return PermisoIngreso.fromJsonList(response.data as List<dynamic>?);
    } on DioError catch(e) {
      final data = e.response?.data ?? {
        'response': 'Error al obtener permisos',
        'status_code': e.response?.statusCode ?? 500,
      };

      logger.e('Error al obtener permisos', [e]);
      throw CustomException.fromSiga(data);
    } catch (e) {
      logger.e('Error al obtener permisos', [e]);
      throw CustomException.custom(message: 'Error al obtener permisos');
    }
  }

  Future<PermisoIngreso> getDetallesPermiso(String id, { bool forceRefresh = false }) async {
    String token = await Get.find<AuthService>().activeTokenExdev();

    try {
      final response = await authClientRequest('permisos/$id',
        method: 'POST',
        ttl: Duration(days: 30),
        forceRefresh: forceRefresh,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      return PermisoIngreso.fromJson(response.data as Map<String, dynamic>?);
    } on DioError catch(e) {
      final data = e.response?.data ?? {
        'response': 'Error al obtener permisos',
        'status_code': e.response?.statusCode ?? 500,
      };

      logger.e('Error al obtener permisos', [e]);
      throw CustomException.fromSiga(data);
    } catch (e) {
      logger.e('Error al obtener permisos', [e]);
      throw CustomException.custom(message: 'Error al obtener permisos');
    }
  }
}