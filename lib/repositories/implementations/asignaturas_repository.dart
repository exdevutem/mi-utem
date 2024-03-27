import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/asignaturas/asignatura.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/repositories/interfaces/asignaturas_repository.dart';

class AsignaturasRepositoryImplementation implements AsignaturasRepository {

  @override
  Future<List<Asignatura>?> getAsignaturas(String? carreraId, {bool forceRefresh = false}) async {
    if(carreraId == null) {
      return null;
    }

    final response = await authClient.get(Uri.parse('$apiUrl/v1/carreras/$carreraId/asignaturas'));

    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return Asignatura.fromJsonList(json);
  }

  @override
  Future<Asignatura?> getDetalleAsignatura(String? asignaturaId, {bool forceRefresh = false}) async {
    final response = await authClient.get(Uri.parse('$apiUrl/v1/asignaturas/$asignaturaId'));

    final json = jsonDecode(response.body);
    if(response.statusCode != 200) {
      logger.e("Error al obtener detalle de asignatura: ${response.reasonPhrase}", json);
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return Asignatura.fromJson(json as Map<String, dynamic>);
  }

}