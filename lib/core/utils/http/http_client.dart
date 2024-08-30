import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/core/utils/http/interceptors/auth_interceptor.dart';
import 'package:mi_utem/core/utils/http/interceptors/error_interceptor.dart';
import 'package:mi_utem/core/utils/http/interceptors/headers_interceptor.dart';
import 'package:mi_utem/core/utils/http/interceptors/log_interceptor.dart';
import 'package:mi_utem/core/utils/http/interceptors/offline_mode_interceptor.dart';

class HttpClient {

  static final DioCacheManager cacheManagerExDev = DioCacheManager(CacheConfig(
    baseUrl: apiUrl,
    defaultMaxAge: const Duration(days: 7),
    defaultMaxStale: const Duration(days: 14),
  ));

  static final DioCacheManager cacheManagerSiga = DioCacheManager(CacheConfig(
    baseUrl: sigaServiceUri,
    defaultMaxAge: const Duration(days: 7),
    defaultMaxStale: const Duration(days: 14),
  ));

  static final Dio dioClient = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
  ]);

  static final Dio httpClient = dioClient..interceptors.addAll([
    OfflineModeInterceptor(),
    errorInterceptor,
  ]);

  static final Dio authClientSiga = httpClient..interceptors.addAll([
    authInterceptorSiga,
    cacheManagerSiga.interceptor,
  ]);

  static final Dio authClientExDev = httpClient..interceptors.addAll([
    authInterceptorExDev,
    cacheManagerExDev.interceptor,
  ]);

  static Future<void> clearCache() async {
    await cacheManagerExDev.clearAll();
    await cacheManagerSiga.clearAll();
  }
}