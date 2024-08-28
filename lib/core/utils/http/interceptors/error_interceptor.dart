import 'package:dio/dio.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';

InterceptorsWrapper errorInterceptor = InterceptorsWrapper(
  onError: (DioError err, ErrorInterceptorHandler handler) {
    if(err.response?.statusCode == 401) {
      return handler.next(err);
    }

    final json = err.response?.data ?? {};
    if(json is Map && json.containsKey("error")) {
      return handler.reject(DioError(requestOptions: err.requestOptions, error: CustomException.fromJson(json as Map<String, dynamic>)));
    }

    logger.e("[ErrorInterceptor]: ${err.message}", err.error, err.stackTrace);
    final error = DioError(requestOptions: err.requestOptions, error: CustomException.fromJson({
      "mensaje": err.response?.statusMessage ?? "Ocurrió un error inesperado. Por favor, inténtalo nuevamente.",
      "error": err.message,
      "codigoHttp": err.response?.statusCode,
      "codigoInterno": 0.0,
    }), response: err.response, type: err.type);
    error.stackTrace = err.stackTrace;
    return handler.reject(error);
  },
);