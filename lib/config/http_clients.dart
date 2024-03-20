import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/models/pair.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:watch_it/watch_it.dart';

final httpClient = InterceptedClient.build(
  interceptors: [
    LoggerInterceptor(),
  ],
);
final authClient = InterceptedClient.build(
  interceptors: [
    LoggerInterceptor(),
    AuthInterceptor(),
  ],
  retryPolicy: ExpiredTokenRetryPolicy(),
);

class AuthInterceptor implements InterceptorContract {

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    if(!data.headers.containsKey('user-agent'))  {
      data.headers['user-agent'] = "App/MiUTEM";
    }

    if(!data.headers.containsKey('content-type'))  {
      data.headers['content-type'] = "application/json";
    }

    if (!data.headers.containsKey('authorization') && !data.url.contains("/v1/auth/login") && !data.url.contains("/v1/auth/refresh")) { // No enviar token si es login o refresh
      final user = await di.get<AuthService>().getUser();
      final token = user?.token;
      if (token != null) {
        logger.d("[AuthInterceptor]: Agregado token de autorización al request");
        data.headers['authorization'] = 'Bearer $token';
      }
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async => data;
}

class ExpiredTokenRetryPolicy extends RetryPolicy {

  @override
  int get maxRetryAttempts => 3;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if(response.statusCode != 401) {
      return false;
    }

    logger.d("[ExpiredTokenRetryPolicy]: ${response.request?.method.name.toUpperCase()} ${response.request?.url} Recibió un 401, refrescando token...");
    final _authService = di.get<AuthService>();
    final currentUser = await _authService.getUser();
    await _authService.isLoggedIn();
    final user = await _authService.getUser();
    final token = user?.token;
    if(token == null) {
      logger.d("[ExpiredTokenRetryPolicy]: No se pudo refrescar el token, redirigiendo a login");
      return false;
    }

    return currentUser?.token == token;
  }
}

class LoggerInterceptor implements InterceptorContract {

  final _times = <String, DateTime>{};

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    logger.d("[LoggerInterceptor#request]: ${data.method.name.toUpperCase()} ${data.url}");
    _times["${data.method}:${data.url}"] = DateTime.now();
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    String? diff;
    final time = _times["${data.method}:${data.url}"];
    if(time != null) {
      diff = " (${DateTime.now().difference(time).inMilliseconds}ms)";
    }
    logger.d("[LoggerInterceptor#response]: ${data.statusCode} ${data.url}$diff");
    return data;
  }
}

class CachedClient extends http.BaseClient {

  final _client = http.Client();
  final _cache = <String, Pair<num, http.StreamedResponse>>{};

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    logger.d("[HttpClient]: ${request.method.toUpperCase()} ${request.url}");
    final useCache = request.headers.containsKey('X-MiUTEM-Use-Cache');
    final cacheKey = sha1.convert(utf8.encode("${request.method}:${request.url}:${request.headers}:${request.contentLength}:${request.followRedirects}:${request.maxRedirects}:${request.persistentConnection}")).toString();
    if (useCache) {
      logger.d("[HttpClient]: Usando cache para ${request.method.toUpperCase()} ${request.url}");
      request.headers.remove('X-MiUTEM-Use-Cache');
      final ttl = request.headers.containsKey('X-MiUTEM-Cache-TTL') ? int.parse(request.headers['X-MiUTEM-Cache-TTL']!) : 300; // 5 minutos por defecto (en segundos)
      request.headers.remove('X-MiUTEM-Cache-TTL');
      if (_cache.containsKey(cacheKey)) {
        final pair = _cache[cacheKey]!;
        if ((DateTime.now().millisecondsSinceEpoch - pair.a) < (ttl * 1000)) { // Si no ha expirado
          return pair.b;
        }

        _cache.remove(cacheKey); // Borrar cache si ya expiró
      }
    }

    final responseStream = await _client.send(request);
    if (useCache && responseStream.statusCode == 200) {
      _cache[cacheKey] = Pair(DateTime.now().millisecondsSinceEpoch, responseStream);
    }

    return responseStream;
  }

  @override
  void close() {
    _client.close();
    super.close();
  }

}
