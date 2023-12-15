class Noticia {
  int? id;
  String? titulo, subtitulo, link, imagen;

  Noticia({this.id, this.titulo, this.subtitulo, this.link, this.imagen});

  Noticia.empty()
      : id = null,
        titulo = "",
        subtitulo = "",
        link = "",
        imagen = "";

  factory Noticia.fromApiJson(Map<String, dynamic> json) =>
      Noticia(
        id: json["id"],
        titulo: json["titulo"],
        subtitulo: json["subtitulo"],
        link: json["link"],
        imagen: json["imagen"],
      );

  static List<Noticia> fromApiJsonList(List<dynamic> json) =>
      json.map((e) => Noticia.fromApiJson(e)).toList();
}
