import 'package:html/parser.dart';

class Noticia {
  int id, featuredMediaId;
  String titulo, subtitulo, link;
  FeaturedMedia featuredMedia;
    
    
  Noticia(
    this.id,
    this.titulo,
    this.subtitulo,
    this.link,
    this.featuredMediaId
  );

  Noticia.empty()
    : id = null,
      titulo = "",
      subtitulo = "",
      link = "",
      featuredMedia = FeaturedMedia.empty(),
      featuredMediaId = null;

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      json['id'],
      parse(json['title']['rendered']).body.text.trim(),
      parse(json['excerpt']['rendered']).body.text.trim(),
      json['link'],
      json['featured_media']
    );
  }

  static List<Noticia> fromJsonList(List<dynamic> json) {
    List<Noticia> lista = [];
    for (var elemento in json) {
      lista.add(Noticia.fromJson(elemento));
    }
    return lista;
  }
}

class FeaturedMedia {
  int id;
  String guid;
    
    
  FeaturedMedia({
    this.id,
    this.guid
  });

  factory FeaturedMedia.empty() {
    return FeaturedMedia(
    id: null,
    guid: "https://noticias.utem.cl/wp-content/uploads/2017/07/en-preparacion.jpg"
    );
  }

  factory FeaturedMedia.fromJson(Map<String, dynamic> json) {
    return FeaturedMedia(
      id: json['id'],
      guid: json['guid'] != null && json['guid']['rendered'] != null && json['guid']['rendered'] != "" ? json['guid']['rendered'] : "https://noticias.utem.cl/wp-content/uploads/2017/07/en-preparacion.jpg"
    );
  }
}