import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/core/utils/http/interceptors/error_interceptor.dart';
import 'package:mi_utem/core/utils/http/interceptors/headers_interceptor.dart';
import 'package:mi_utem/core/utils/http/interceptors/log_interceptor.dart';
import 'package:mi_utem/core/utils/http/interceptors/offline_mode_interceptor.dart';

class HttpClient {

  static final DioCacheManager cacheManager = DioCacheManager(CacheConfig(
    baseUrl: apiUrl,
    defaultMaxAge: const Duration(days: 7),
    defaultMaxStale: const Duration(days: 14),
  ));

  static final Dio dioClient = Dio(BaseOptions(baseUrl: apiUrl))..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
  ]);

  static final Dio httpClient = dioClient..interceptors.addAll([
    OfflineModeInterceptor(),
    cacheManager.interceptor,
    errorInterceptor,
  ]);

  static final Dio authClient = httpClient;

  static Future<void> clearCache() async {
    await cacheManager.deleteByPrimaryKey("miutem");
    await cacheManager.clearExpired();
    await cacheManager.clearAll();
  }
}