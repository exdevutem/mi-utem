import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioMiUtemClient {
  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
  
  static const String debugUrl = 'http://192.168.5.109:3000';
  static const String productionUrl = 'https://apiapp.utem.dev';
  
  static const String url = isProduction ? productionUrl : productionUrl;

  static Dio get initDio => Dio(BaseOptions(
    baseUrl: url,
  ));

  static Dio baseDio = Dio(BaseOptions(
    baseUrl: url,
  ));

  static DioCacheManager cacheManager = DioCacheManager(CacheConfig(baseUrl: url));

  static Dio get authDio => baseDio
    ..interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          var sesion = prefs.getString('sesion');

          options.headers.addAll({"Authorization": "Bearer $sesion"});

          return options;
        },
        onResponse: (Response response) async {
        },
        onError: (DioError dioError) async {
          if (dioError.response?.statusCode == 401) {
            RequestOptions options = dioError.response.request;

            baseDio.interceptors.requestLock.lock();
            baseDio.interceptors.responseLock.lock();
            bool ok = await refreshSesion();
            baseDio.interceptors.requestLock.unlock();
            baseDio.interceptors.responseLock.unlock();

            if (ok) {
              return baseDio.request(
                options.path,
                cancelToken: options.cancelToken,
                data: options.data,
                queryParameters: options.queryParameters
              );
            } else {
              return dioError; 
            }
          } else {
            return dioError; 
          }
        }
      ),
      cacheManager.interceptor,
    ],);
  
  static Future<bool> refreshSesion() async {
    String uri = "/v1/usuarios/refresh";
    
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final FlutterSecureStorage storage = new FlutterSecureStorage();

      String correo = prefs.getString("correo");
      String contrasenia = await storage.read(key: "contrasenia");

      if (correo != null && contrasenia != null) {
        dynamic data = {'usuario': correo, 'contrasenia': contrasenia};

        Response response = await DioMiUtemClient.initDio.post(uri, data: data);

        Usuario usuario = Usuario.fromJson(response.data);

        prefs.setString('sesion', usuario.sesion);
      
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}