import 'package:get/get.dart';
import 'package:mi_utem/config/constants.dart';

import 'package:mi_utem/models/noticia.dart';

class NoticiasService extends GetConnect {

  Future<List<Noticia>> getNoticias() async =>
      get("${Constants.apiUrl}/v1/noticias").then((response) => response.statusCode == 200 ? Noticia.fromApiJsonList(response.body) : []);

}
