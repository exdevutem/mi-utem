import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:watch_it/watch_it.dart';

class AuthClient extends http.BaseClient {

  final _client = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if(!request.headers.containsKey('user-agent'))  {
      request.headers['user-agent'] = "App/MiUTEM";
    }

    if(!request.headers.containsKey('content-type'))  {
      request.headers['content-type'] = "application/json";
    }

    if (!request.headers.containsKey('authorization')) {
      final user = await di.get<AuthService>().getUser();
      final token = user?.token;
      if (token != null) {
        request.headers['authorization'] = 'Bearer $token';
      }
    }

    var response = await _client.send(request);
    final json = jsonDecode(await response.stream.bytesToString());
    if(response.statusCode == 401 && json is Map<String, dynamic> && json.containsKey("codigoInterno") && json["codigoInterno"] == 12) {
      // Refrescar el token
      final _authService = di.get<AuthService>();
      await _authService.isLoggedIn();
      final user = await _authService.getUser();
      final token = user?.token;
      if (token != null) {
        request.headers['authorization'] = 'Bearer $token';
        response = await _client.send(request);
      }
    }

    return response;
  }

  @override
  void close() {
    _client.close();
    super.close();
  }

}