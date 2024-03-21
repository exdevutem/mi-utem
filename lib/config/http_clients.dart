
import 'package:http_interceptor/http_interceptor.dart';
import 'package:mi_utem/config/logger.dart';
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
  int get maxRetryAttempts => 6;

  @override
  Future<bool> shouldAttemptRetryOnResponse(ResponseData response) async {
    if(response.statusCode != 401) {
      return false;
    }

    logger.d("[ExpiredTokenRetryPolicy]: ${response.request?.method.name.toUpperCase()} ${response.request?.url} Recibió un 401, refrescando token...");
    final _authService = di.get<AuthService>();
    final currentToken = (await _authService.getUser())?.token;
    if(currentToken == null) {
      await _authService.login();
    } else {
      await _authService.isLoggedIn(forceRefresh: true);
    }

    final token = (await _authService.getUser())?.token;
    if(token == null) {
      logger.d("[ExpiredTokenRetryPolicy]: No se pudo refrescar el token!");
      return false;
    }

    return true;
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