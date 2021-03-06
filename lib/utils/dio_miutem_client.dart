import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/usuario.dart';

class DioMiUtemClient {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  static String debugUrl =
      dotenv.env['MI_UTEM_API_DEBUG'] ?? 'https://api.exdev.cl/';
  static const String productionUrl = 'https://api.exdev.cl/';

  static String url = isProduction ? productionUrl : debugUrl;

  static Dio get initDio => Dio(
        BaseOptions(
          baseUrl: url,
        ),
      );

  static CacheConfig cacheConfig = CacheConfig(
    baseUrl: url,
    defaultMaxAge: Duration(days: 7),
    defaultMaxStale: Duration(days: 60),
  );
  static DioCacheManager dioCacheManager = DioCacheManager(cacheConfig);

  static Dio baseDio = Dio(BaseOptions(
    baseUrl: url,
  ))
    ..interceptors.add(dioCacheManager.interceptor);

  static Dio get authDio => initDio
    ..interceptors.addAll(
      [
        InterceptorsWrapper(onRequest: (options, handler) async {
          GetStorage box = GetStorage();
          var token = box.read('token');
          options.headers.addAll({"Authorization": "Bearer $token"});

          return handler.next(options);
        }, onResponse: (response, handler) async {
          return handler.next(response);
        }, onError: (dioError, handler) async {
          print("onError");
          if (dioError.response?.statusCode == 401) {
            RequestOptions options = dioError.response!.requestOptions;

            baseDio.interceptors.requestLock.lock();
            baseDio.interceptors.responseLock.lock();
            bool ok = await refreshSesion();
            baseDio.interceptors.requestLock.unlock();
            baseDio.interceptors.responseLock.unlock();

            if (ok) {
              final opts = new Options(
                method: dioError.requestOptions.method,
                headers: dioError.requestOptions.headers,
              );
              Response response = await authDio.request(
                options.path,
                options: opts,
                data: options.data,
                queryParameters: options.queryParameters,
              );
              handler.resolve(response);
            } else {
              return handler.next(dioError);
            }
          } else {
            return handler.next(dioError);
          }
        }),
        //DioCacheInterceptor(options: cacheOptions),
      ],
    );

  static Future<bool> refreshSesion() async {
    String uri = "/v1/auth";

    try {
      final GetStorage box = GetStorage();
      final FlutterSecureStorage storage = new FlutterSecureStorage();

      String? correo = box.read("correoUtem");
      String? contrasenia = await storage.read(key: "contrasenia");

      print({'correo': correo, 'contrasenia': contrasenia});

      if (correo != null && contrasenia != null) {
        dynamic data = {'correo': correo, 'contrasenia': contrasenia};

        Response response = await DioMiUtemClient.initDio.post(uri, data: data);

        if (response.statusCode == 200) {
          Usuario usuario = Usuario.fromJson(response.data);
          box.write('token', usuario.token!);
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}
