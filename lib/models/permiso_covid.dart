class PermisoCovid {
  String? id;
  String? perfil;
  String? motivo;
  String? campus;
  String? dependencia;
  String? jornada;
  String? fechaSolicitud;

  PermisoCovid(
    this.id,
    this.perfil,
    this.motivo,
    this.campus,
    this.dependencia,
    this.jornada,
    this.fechaSolicitud,
  );

  factory PermisoCovid.fromJson(Map<String, dynamic> json) {
    return PermisoCovid(
      json['id'],
      json['perfil'],
      json['motivo'],
      json['campus'],
      json['dependencia'],
      json['jornada'],
      json['fechaSolicitud'],
    );
  }

  static List<PermisoCovid> fromJsonList(List<dynamic> json) {
    List<PermisoCovid> lista = [];
    for (var elemento in json) {
      lista.add(PermisoCovid.fromJson(elemento));
    }
    return lista;
  }
}
