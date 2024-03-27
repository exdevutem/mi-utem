import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/permiso_ingreso.dart';
import 'package:mi_utem/repositories/interfaces/permiso_ingreso_repository.dart';

class PermisoIngresoRepositoryImplementation extends PermisoIngresoRepository {

  @override
  Future<PermisoIngreso> getDetallesPermiso(String id) async {
    final response = await authClient.post(Uri.parse("$apiUrl/v1/permisos/$id"));

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if(response.statusCode != 200) {
      if(json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return PermisoIngreso.fromJson(json);
  }

  @override
  Future<List<PermisoIngreso>> getPermisos() async {
    final response = await authClient.post(Uri.parse("$apiUrl/v1/permisos"));

    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map<String, dynamic> && json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return PermisoIngreso.fromJsonList(json as List<dynamic>);
  }

}