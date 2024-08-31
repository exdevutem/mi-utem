import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/core/utils/http/http_client.dart';

class AuthInterceptorSiga extends QueuedInterceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final data = options.extra['sigaParams'] ?? {};
    if((options.extra['noToken'] as bool?) != true) {
      try {
        final token = await Get.find<AuthService>().activeToken();
        data['token'] = token;
      } catch(e) {
        logger.e('Error al obtener token de siga', [e]);
      }
    }

    options.data = (data as Map<dynamic, dynamic>).entries.map((e) => '${e.key}=${Uri.encodeFull(e.value.toString())}').join('&');

    logger.d('AuthInterceptorSiga: ${options.method} ${options.uri}', [options.headers]);
    return handler.next(options);
  }
}

class AuthInterceptorExDev extends QueuedInterceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    logger.d('AuthInterceptorExDev#onRequest', [options.uri, !options.headers.containsKey("Authorization") && options._retryCountExDev < 3 && (options.extra['noToken'] as bool?) != true]);
    if(!options.headers.containsKey("Authorization") && options._retryCountExDev < 3 && (options.extra['noToken'] as bool?) != true) {
      try {
        final token = await Get.find<AuthService>().activeTokenExdev(forceRefresh: options.extra[DIO_CACHE_KEY_FORCE_REFRESH] ?? false);
        options._setAuthHeader(token);
      } catch(e) {
        logger.e('Error al obtener token de exdev', [e]);
      }
    }

    logger.d('AuthInterceptorExDev: ${options.method} ${options.uri}', [options.headers]);
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final options = err.requestOptions;
    final attempt = err.requestOptions._retryCountExDev + 1;
    if (attempt > 3) {
      return handler.next(err);
    }

    err.requestOptions._retryCountExDev = attempt;
    await Future.delayed(const Duration(milliseconds: 500));

    /* Forzar el refresco de la token de autenticación */
    try {
      final token = await Get.find<AuthService>().activeTokenExdev(forceRefresh: true);
      options._setAuthHeader(token);
      final response = await HttpClient.httpClient.fetch(options);
      return handler.resolve(response);
    } on DioError catch (e) {
      return handler.next(e);
    } catch (e) {
      return handler.next(DioError(requestOptions: options, error: e));
    }
  }
}

extension AuthRequestExDevOptions on RequestOptions {

  void _setAuthHeader(final String token) => headers["Authorization"] = "Bearer $token";

  int get _retryCountExDev => (extra['exdev_api_retries'] as int?) ?? 0;

  set _retryCountExDev(int value) => extra['exdev_api_retries'] = value;

}