import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/services_new/interfaces/asignaturas_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:watch_it/watch_it.dart';

class AsignaturasServiceImplementation implements AsignaturasService {

  @override
  Future<List<Asignatura>?> getAsignaturas(String? carreraId, {bool forceRefresh = false}) async {
    if(carreraId == null) {
      return null;
    }

    final user = await di.get<AuthService>().getUser();
    if(user == null) {
      return null;
    }

    final response = await authClient.get(Uri.parse('$apiUrl/v1/carreras/$carreraId/asignaturas'), headers: {
      'Authorization': 'Bearer ${user.token}',
      'Content-Type': 'application/json',
      'User-Agent': 'App/MiUTEM',
    });

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
    final user = await di.get<AuthService>().getUser();
    if(user == null) {
      return null;
    }

    final response = await authClient.get(Uri.parse('$apiUrl/v1/asignaturas/$asignaturaId'), headers: {
      'Authorization': 'Bearer ${user.token}',
      'Content-Type': 'application/json',
      'User-Agent': 'App/MiUTEM',
    });

    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return Asignatura.fromJson(json as Map<String, dynamic>);
  }

}