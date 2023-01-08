import 'package:dio/dio.dart';

import 'package:mi_utem/models/noticia.dart';
import 'package:mi_utem/utils/dio_wordpress_client.dart';

class NoticiasService {
  static final Dio _dio = DioWordpressClient.initDio;

  static Future<List<Noticia>> getNoticias() async {
    String uri = "/posts";

    try {
      Response response = await _dio.get(uri);

      List<Noticia> noticias = Noticia.fromJsonList(response.data);

      return await Future.wait(noticias.map((noticia) async {
        String uri = '/media/${noticia.featuredMediaId}';
        try {
          if (noticia.featuredMediaId != null && noticia.featuredMediaId != 0) {
            Response response = await _dio.get(uri);
            noticia.featuredMedia = FeaturedMedia.fromJson(response.data);
          } else {
            noticia.featuredMedia = FeaturedMedia.empty();
          }
          return noticia;
        } catch (e) {
          print(e);
          noticia.featuredMedia = FeaturedMedia.empty();
          return noticia;
        }
      }).toList());
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }
}
