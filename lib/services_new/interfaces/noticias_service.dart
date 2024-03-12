import 'package:mi_utem/models/noticia.dart';

abstract class NoticiasService {

  Future<List<Noticia>?> getNoticias();
}