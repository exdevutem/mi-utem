import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HeadersInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final headers = options.headers;
    final info = await PackageInfo.fromPlatform();

    headers['User-Agent'] = 'App/MiUTEM v${info.version} (${info.buildNumber})';
    if(options.data != null && !options.headers.containsKey('Content-Type')) {
      headers['Content-Type'] = 'application/json';
    }
    options.headers = headers;

    super.onRequest(options, handler);
  }
}