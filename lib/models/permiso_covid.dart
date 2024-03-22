import 'package:mi_utem/models/user/user.dart';

class PermisoCovid {
  String? id;
  User? user;
  String? codigoQr;
  String? perfil;
  String? motivo;
  String? campus;
  String? dependencia;
  String? jornada;
  String? vigencia;
  DateTime? fechaSolicitud;

  PermisoCovid({
    this.id,
    this.user,
    this.codigoQr,
    this.perfil,
    this.motivo,
    this.campus,
    this.dependencia,
    this.jornada,
    this.vigencia,
    this.fechaSolicitud,
  });

  factory PermisoCovid.fromJson(Map<String, dynamic> json) => PermisoCovid(
    id: json['id'],
    user: json.containsKey("usuario") ? User.fromJson(json['usuario']) : null,
    codigoQr: json['codigoQr'],
    perfil: json['perfil'],
    motivo: json['motivo'],
    campus: json['campus'],
    dependencia: json['dependencia'],
    jornada: json['jornada'],
    vigencia: json['vigencia'],
    fechaSolicitud: DateTime.tryParse(json['fechaSolicitud']),
  );

  static List<PermisoCovid> fromJsonList(List<dynamic>? json) => json != null ? json.map((it) => PermisoCovid.fromJson(it)).toList() : [];
}
