class Noticia {
  int id;
  String titulo, link, imagen;

  Noticia({required this.id, required this.titulo, required this.link, required this.imagen});

  factory Noticia.fromJson(Map<String, dynamic> json) => Noticia(
    id: json["id"],
    titulo: json['yoast_head_json']['title'],
    imagen: json['yoast_head_json']['og_image'][0]['url'],
    link: "https://noticias.utem.cl/?p=${json['id']}",
  );

  static List<Noticia> fromJsonList(List<dynamic> json) => json.where((json) => ((json['yoast_head_json']['og_image'] as List<dynamic>? ?? [])).isNotEmpty).map((e) => Noticia.fromJson(e)).toList();
}
