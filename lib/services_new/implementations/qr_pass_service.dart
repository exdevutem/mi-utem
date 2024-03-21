import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services_new/interfaces/qr_pass_service.dart';

class QRPassServiceImplementation extends QRPassService {

  @override
  Future<PermisoCovid?> getDetallesPermiso(String id, {bool forceRefresh = false}) async {
    final response = await authClient.post(Uri.parse("$apiUrl/v1/permisos/$id"));

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if(response.statusCode != 200) {
      if(json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return PermisoCovid.fromJson(json);
  }

  @override
  Future<List<PermisoCovid>?> getPermisos({bool forceRefresh = false}) async {
    final response = await authClient.post(Uri.parse("$apiUrl/v1/permisos"));

    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map<String, dynamic> && json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return PermisoCovid.fromJsonList(json as List<dynamic>);
  }


}