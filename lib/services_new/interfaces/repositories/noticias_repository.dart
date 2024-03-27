import 'package:mi_utem/models/noticia.dart';

abstract class NoticiasRepository {

  Future<List<Noticia>?> getNoticias();
}