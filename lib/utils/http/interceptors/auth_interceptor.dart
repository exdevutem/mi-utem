import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/services/auth_service.dart';
import 'package:mi_utem/utils/http/http_client.dart';

class AuthInterceptor extends QueuedInterceptor {

  /* Cantidad de reintentos máximos si se recibe un error 401 */
  final int retries;
  final _authService = Get.find<AuthService>();

  AuthInterceptor({
    this.retries = 3,
  });

  @override
  Future<void> onRequest(final RequestOptions options, final RequestInterceptorHandler handler) async {
    try {
      if(!options.headers.containsKey("authorization")) {
        final user = await _authService.getUser();
        final token = user?.token;
        if(token != null) {
          options._setAuthenticationHeader(token);
        }
      }

      return handler.next(options);
    } catch (e) {
      return handler.reject(DioError(
        requestOptions: options,
        error: e,
      ));
    }
  }

  @override
  Future<void> onError(final DioError err, final ErrorInterceptorHandler handler) async {
    final options = err.requestOptions;

    if (err.response?.statusCode != 401) {
      return super.onError(err, handler);
    }

    final attempt = err.requestOptions._retryAttempt + 1;
    if (attempt > retries) {
      await _onErrorRefreshingToken();
      return super.onError(err, handler);
    }

    err.requestOptions._retryAttempt = attempt;
    await Future.delayed(const Duration(seconds: 1));

    /* Forzar el refresco de la token de autenticación */
    try {
      await _authService.login(forceRefresh: true);
      final token = (await _authService.getUser())?.token;

      if(token == null) {
        await _onErrorRefreshingToken();
        return super.onError(err, handler);
      }

      options._setAuthenticationHeader(token);
      final response = await HttpClient.httpClient.fetch(options);
      return handler.resolve(response);
    } on DioError catch (e) {
      super.onError(e, handler);
    } catch (e) {
      super.onError(
        DioError(requestOptions: options, error: e),
        handler,
      );
    }
  }

  Future<void> _onErrorRefreshingToken() async => await _authService.logout();
}

extension AuthRequestOptionsX on RequestOptions {
  void _setAuthenticationHeader(final String token) => headers['Authorization'] = 'Bearer $token';

  int get _retryAttempt => (extra['auth_retry_attempt'] as int?) ?? 0;

  set _retryAttempt(final int attempt) => extra['auth_retry_attempt'] = attempt;
}