import 'package:mi_utem/models/rut.dart';
import 'package:mi_utem/models/usuario.dart';

class PermisoCovid {
  String? id;
  String? nombre;
  String? rut;
  String? codigoQr;
  String? perfil;
  String? motivo;
  String? campus;
  String? dependencia;
  String? jornada;
  String? vigencia;
  DateTime? fechaSolicitud;

  PermisoCovid(
    this.id,
    this.nombre,
    this.rut,
    this.codigoQr,
    this.perfil,
    this.motivo,
    this.campus,
    this.dependencia,
    this.jornada,
    this.vigencia,
    this.fechaSolicitud,
  );

  factory PermisoCovid.fromJson(Map<String, dynamic> json) {
    return PermisoCovid(
        json['id'],
        json['usuario']?['nombreCompleto'],
        json['usuario']?['rut'],
        json['codigoQr'],
        json['perfil'],
        json['motivo'],
        json['campus'],
        json['dependencia'],
        json['jornada'],
        json['vigencia'],
        DateTime.tryParse(json['fechaSolicitud']));
  }

  static List<PermisoCovid> fromJsonList(List<dynamic> json) {
    List<PermisoCovid> lista = [];
    for (var elemento in json) {
      lista.add(PermisoCovid.fromJson(elemento));
    }
    return lista;
  }
}
