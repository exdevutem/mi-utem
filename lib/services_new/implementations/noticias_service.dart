import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/noticia.dart';
import 'package:mi_utem/services_new/interfaces/noticias_service.dart';
import 'package:http/http.dart' as http;

class NoticiasServiceImplementation implements NoticiasService {

  @override
  Future<List<Noticia>?> getNoticias() async {
    final response = await http.get(Uri.parse("$apiUrl/v1/noticias"));

    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map && json.containsKey("error")) {
        throw CustomException.fromJson(json as Map<String, dynamic>);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return Noticia.fromApiJsonList(json as List<dynamic>);
  }

}