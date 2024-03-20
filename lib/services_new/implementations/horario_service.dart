import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/horario.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/horario_service.dart';
import 'package:watch_it/watch_it.dart';

class HorarioServiceImplementation implements HorarioService {
  @override
  Future<Horario?> getHorario(String carreraId, {bool forceRefresh = false}) async {
    final user = await di.get<AuthService>().getUser();
    if (user == null) {
      return null;
    }

    final response = await authClient.get(Uri.parse("$apiUrl/v1/carreras/$carreraId/horarios"),
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json',
        'User-Agent': 'App/MiUTEM',
      },
    );

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
