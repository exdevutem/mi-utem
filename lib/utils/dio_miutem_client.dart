import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mi_utem/services/auth_service.dart';

class DioMiUtemClient {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static String debugUrl =
      dotenv.env['MI_UTEM_API_DEBUG'] ?? 'https://api.exdev.cl/';
  static const String productionUrl = 'https://api.exdev.cl/';

  static String url = isProduction ? productionUrl : debugUrl;

  static Dio get initDio => Dio(BaseOptions(baseUrl: url));

  static CacheConfig cacheConfig = CacheConfig(
    baseUrl: url,
    defaultMaxAge: Duration(days: 7),
    defaultMaxStale: Duration(days: 60),
  );
  static DioCacheManager dioCacheManager = DioCacheManager(cacheConfig);

  static Dio baseDio = Dio(BaseOptions(baseUrl: url))
    ..interceptors.add(dioCacheManager.interceptor);

  static Dio get authDio => initDio
    ..interceptors.add(
      AuthInterceptor(),
    );
}

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({
    this.retries = 3,
  });

  /// The number of retries in case of 401
  final int retries;

  @override
  Future<void> onRequest(
    final RequestOptions options,
    final RequestInterceptorHandler handler,
  ) async {
    try {
      final token = AuthService.getToken();

      options._setAuthenticationHeader(token);

      return handler.next(options);
    } catch (e) {
      final error = DioError(requestOptions: options, error: e);
      handler.reject(error);
    }
  }

  @override
  Future<void> onError(
      final DioError err, final ErrorInterceptorHandler handler) async {
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
    await Future<void>.delayed(const Duration(seconds: 1));

    // Force refresh auth token
    try {
      final token = await AuthService.refreshToken();

      log("Refreshing token, attempt $attempt...");

      options._setAuthenticationHeader(token);
      final response = await DioMiUtemClient.baseDio.fetch<void>(options);
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

  Future<void> _onErrorRefreshingToken() async {
    AuthService.invalidateToken();
  }
}

extension AuthRequestOptionsX on RequestOptions {
  void _setAuthenticationHeader(final String token) =>
      headers['Authorization'] = 'Bearer $token';

  int get _retryAttempt => (extra['auth_retry_attempt'] as int?) ?? 0;

  set _retryAttempt(final int attempt) => extra['auth_retry_attempt'] = attempt;
}
