import 'package:mi_utem/models/usuario.dart';

class PermisoCovid {
  String? id;
  Usuario? usuario;
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
    this.usuario,
    this.codigoQr,
    this.perfil,
    this.motivo,
    this.campus,
    this.dependencia,
    this.jornada,
    this.vigencia,
    this.fechaSolicitud,
  });

  factory PermisoCovid.fromJson(Map<String, dynamic> json) {
    return PermisoCovid(
      id: json['id'],
      usuario: Usuario.fromJson(json['usuario']),
      codigoQr: json['codigoQr'],
      perfil: json['perfil'],
      motivo: json['motivo'],
      campus: json['campus'],
      dependencia: json['dependencia'],
      jornada: json['jornada'],
      vigencia: json['vigencia'],
      fechaSolicitud: DateTime.tryParse(json['fechaSolicitud']),
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
