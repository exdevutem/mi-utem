import 'package:dio/dio.dart';

class DioWordpressClient {
  static const String url = 'https://www.utem.cl/wp-json/wp/v2';

  static Dio _dio = Dio(BaseOptions(
    baseUrl: url,
  ));

  static Dio get initDio => _dio
      //..interceptors.add(DioCacheManager(CacheConfig(baseUrl: url)).interceptor)
      ;
}
