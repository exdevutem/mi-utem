import 'package:mi_utem/models/user/user.dart';

class PermisoIngreso {
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

  PermisoIngreso({
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

  factory PermisoIngreso.fromJson(Map<String, dynamic>? json) => json != null ? PermisoIngreso(
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
  ) : PermisoIngreso();

  static List<PermisoIngreso> fromJsonList(List<dynamic>? json) => json != null ? json.map((it) => PermisoIngreso.fromJson(it)).toList() : [];
}
