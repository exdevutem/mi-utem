import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioMiUtemClient {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');

  static const String debugUrl = 'http://192.168.1.169:3000';
  static const String productionUrl = 'https://apiapp.utem.dev';

  static const String url = isProduction ? productionUrl : debugUrl;

  static Dio get initDio => Dio(BaseOptions(
        baseUrl: url,
      ));

  static Dio baseDio = Dio(BaseOptions(
    baseUrl: url,
  ));

  static CacheOptions cacheOptions = CacheOptions(
    store: MemCacheStore(),
    policy: CachePolicy.forceCache,
    maxStale: const Duration(days: 7),
  );

  static Dio get authDio => baseDio
    ..interceptors.addAll(
      [
        InterceptorsWrapper(onRequest: (options, handler) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token');
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
              Response response = await baseDio.request(options.path,
                  cancelToken: options.cancelToken,
                  data: options.data,
                  queryParameters: options.queryParameters);
              handler.resolve(response);
            } else {
              return handler.next(dioError);
            }
          } else {
            return handler.next(dioError);
          }
        }),
        DioCacheInterceptor(options: cacheOptions),
      ],
    );

  static Future<bool> refreshSesion() async {
    String uri = "/v1/auth";

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final FlutterSecureStorage storage = new FlutterSecureStorage();

      String? correo = prefs.getString("correoUtem");
      String? contrasenia = await storage.read(key: "contrasenia");

      if (correo != null && contrasenia != null) {
        dynamic data = {'correo': correo, 'contrasenia': contrasenia};

        Response response = await DioMiUtemClient.initDio.post(uri, data: data);

        if (response.statusCode == 200) {
          Usuario usuario = Usuario.fromJson(response.data);
          prefs.setString('token', usuario.token!);
        }

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
