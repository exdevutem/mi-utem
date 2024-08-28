class Asistencia {
  num? total;
  num? asistidos;
  num? noAsistidos;
  num? sinRegistro;

  Asistencia({
    this.total = 0,
    this.asistidos = 0,
    this.noAsistidos = 0,
    this.sinRegistro = 0,
  });

  factory Asistencia.fromJson(Map<String, dynamic>? json) => json != null ? Asistencia(
    total: json['total'] ?? 0,
    asistidos: json['asistida'] ?? 0,
    noAsistidos: json['noAsistidos'] ?? 0,
    sinRegistro: json['sinRegistro'] ?? 0,
  ) : Asistencia();

  static List<Asistencia> fromJsonList(dynamic json) => json != null ? (json as List<dynamic>).map((it) => Asistencia.fromJson(it)).toList() : [];

  Map<String, dynamic> toJson() => {
    'total': total,
    'asistidos': asistidos,
    'noAsistidos': noAsistidos,
    'sinRegistro': sinRegistro,
  };
}
