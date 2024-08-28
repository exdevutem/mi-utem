import 'package:dio/dio.dart';
import 'package:mi_utem/config/logger.dart';

InterceptorsWrapper logInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    final now = DateTime.now();
    logger.d("[HttpClient - ${now.toIso8601String()}]: ${options.method.toUpperCase()} ${options.uri}");
    options.extra["request_created_at"] = now.toIso8601String();
    return handler.next(options);
  },
  onResponse: (Response response, ResponseInterceptorHandler handler) {
    final now = DateTime.now();
    final requestCreatedAt = DateTime.tryParse(response.requestOptions.extra["request_created_at"] as String);
    if(requestCreatedAt != null) {
      final difference = now.difference(requestCreatedAt).inMilliseconds;
      logger.d("[HttpClient - $requestCreatedAt]: ${response.statusCode} > ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri} ${difference}ms");
    }
    return handler.next(response);
  },
);