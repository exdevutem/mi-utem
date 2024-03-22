import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/services_new/interfaces/horario_service.dart';

class HorarioServiceImplementation implements HorarioService {
  @override
  Future<Horario?> getHorario(String carreraId, {bool forceRefresh = false}) async {
    final response = await authClient.get(Uri.parse("$apiUrl/v1/carreras/$carreraId/horarios"));

    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      logger.e("[HorarioService] Error al obtener horario: ${response.reasonPhrase}", json);
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return Horario.fromJson(json);
  }
}
