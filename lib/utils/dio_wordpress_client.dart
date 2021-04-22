import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioWordpressClient {
  static const String url = 'https://www.utem.cl/wp-json/wp/v2';

  static Dio _dio = Dio(BaseOptions(
    baseUrl: url,
  ));
  
  static Dio get initDio => _dio
    //..interceptors.add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor)
    ;
}