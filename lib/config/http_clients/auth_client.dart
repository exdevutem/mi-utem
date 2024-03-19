import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/pair.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:watch_it/watch_it.dart';

final authClient = AuthClient();

class AuthClient extends http.BaseClient {

  final _client = http.Client();
  final _cache = <String, Pair<num, http.StreamedResponse>>{};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    logger.d("[AuthClient]: ${request.method.toUpperCase()} ${request.url}");
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

    final useCache = request.headers.containsKey('X-MiUTEM-Use-Cache');
    final cacheKey = sha1.convert(utf8.encode("${request.method}:${request.url}:${request.headers}:${request.contentLength}:${request.followRedirects}:${request.maxRedirects}:${request.persistentConnection}")).toString();
    if (useCache) {
      request.headers.remove('X-MiUTEM-Use-Cache');
      final ttl = request.headers.containsKey('X-MiUTEM-Cache-TTL') ? int.parse(request.headers['X-MiUTEM-Cache-TTL']!) : 300;
      request.headers.remove('X-MiUTEM-Cache-TTL');
      if (_cache.containsKey(cacheKey)) {
        final pair = _cache[cacheKey]!;
        if (DateTime.now().millisecondsSinceEpoch - pair.a < ttl * 1000) { // Si no ha expirado
          return pair.b;
        }

        _cache.remove(cacheKey); // Borrar cache si ya expiró
      }
    }

    var responseStream = await _client.send(request);
    if (responseStream.statusCode == 401) {
      var response = await http.Response.fromStream(responseStream);
      final json = jsonDecode(response.body);
      if(json is Map<String, dynamic> && json.containsKey("codigoInterno") && json["codigoInterno"] == 12) {
        // Refrescar el token
        final _authService = di.get<AuthService>();
        await _authService.isLoggedIn();
        final user = await _authService.getUser();
        final token = user?.token;
        if (token != null) {
          return await _client.send(request);
        }
      }

      throw Exception("Error al refrescar el token");
    }

    if (useCache) {
      _cache[sha1.convert(utf8.encode(cacheKey)).toString()] = Pair(DateTime.now().millisecondsSinceEpoch, responseStream);
    }

    return responseStream;
  }

  @override
  void close() {
    _client.close();
    super.close();
  }

}