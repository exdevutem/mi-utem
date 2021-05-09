import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioDocenteClient {
    static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  
  static const String debugUrl = 'http://192.168.5.109:3100/v1';
  static const String productionUrl = 'http://docentes.inndev.studio/v1';
  
  static const String url = isProduction ? productionUrl : productionUrl;

  static Dio _dio = Dio(BaseOptions(
    baseUrl: url,
  ));

  static CacheOptions get cacheOptions => CacheOptions(
    store: HiveCacheStore('docentesutem'),
    policy: CachePolicy.forceCache,
    maxStale: const Duration(days: 7),
  );
  
  static Dio get initDio => _dio
    ..interceptors.add(DioCacheInterceptor(options: cacheOptions),);
}