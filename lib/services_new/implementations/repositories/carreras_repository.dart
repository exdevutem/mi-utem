import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/services_new/interfaces/repositories/carreras_repository.dart';

class CarrerasRepositoryImplementation extends CarrerasRepository {

  @override
  Future<List<Carrera>> getCarreras() async {
    final response = await authClient.get(Uri.parse("$apiUrl/v1/carreras"));

    final json = jsonDecode(response.body);
    if(response.statusCode != 200) {
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return Carrera.fromJsonList(json as List<dynamic>);
  }

}