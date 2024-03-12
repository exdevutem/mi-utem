import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/qr_pass_service.dart';
import 'package:http/http.dart' as http;
import 'package:watch_it/watch_it.dart';

class QRPassServiceImplementation extends QRPassService {

  final _authService = di.get<AuthService>();

  @override
  Future<PermisoCovid?> getDetallesPermiso(String id, {bool forceRefresh = false}) async {
    final user = await _authService.getUser();
    if(user == null) {
      return null;
    }

    final response = await http.post(Uri.parse("$apiUrl/v1/permisos/$id"),
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json',
        'User-Agent': 'App/MiUTEM'
      },
    );

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
    final user = await _authService.getUser();
    if(user == null) {
      return null;
    }

    final response = await http.post(Uri.parse("$apiUrl/v1/permisos"),
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json',
        'User-Agent': 'App/MiUTEM'
      },
    );

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