import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion/grades.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/utils/string_utils.dart';

class Asignatura {
  String? id;
  String? nombre;
  String? codigo;
  String? tipoHora;
  String? estado;
  String? docente;
  String? seccion;

  Asistencia? asistencia;
  Grades? grades;
  List<User>? estudiantes;
  String? tipoAsignatura;
  num? intentos;
  String? horario;
  String? sala;
  String? tipoSala;

  Asignatura({
    this.id,
    this.nombre,
    this.codigo,
    this.tipoHora,
    this.estado,
    this.docente,
    this.seccion,
    this.asistencia,
    this.grades,
    this.estudiantes,
    this.tipoAsignatura,
    this.sala,
    this.horario,
    this.intentos,
    this.tipoSala,
  });

  Color get colorPorEstado {
    switch (estado) {
      case "Aprobado":
        return MainTheme.aprobadoColor;
      case "Reprobado":
        return MainTheme.reprobadoColor;
      default:
        return MainTheme.inscritoColor;
    }
  }

  factory Asignatura.fromJson(Map<String, dynamic>? json) => json != null ? Asignatura(
    id: json['id'],
    codigo: json['codigo'],
    nombre: capitalize(json['nombre'] ?? ''),
    tipoHora: capitalize(json['tipoHora'] ?? ''),
    estado: capitalize(json['estado'] ?? ''),
    docente: capitalize(json['docente'] ?? ''),
    seccion: json['seccion'],
    grades: json.containsKey('notas') ? Grades.fromJson(json['notas']) : null,
    estudiantes: User.fromJsonList(json["estudiantes"]),
    asistencia: Asistencia(asistidos: json['asistenciaAlDia']),
    tipoAsignatura: capitalize(json['tipoAsignatura'] as String),
    sala: capitalize(json['sala'] ?? ''),
    horario: json['horario'],
    intentos: int.tryParse(json['intentos'] ?? '0') ?? 0,
    tipoSala: capitalize(json['tipoSala'] ?? ''),
  ) : Asignatura();

  static List<Asignatura> fromJsonList(dynamic json) => json != null ? (json as List<dynamic>).map((it) => Asignatura.fromJson(it)).toList() : [];

  Map<String, dynamic> toJson() => {
    'id': id,
    'codigo': codigo,
    'nombre': nombre,
    'tipoHora': tipoHora,
    'estado': estado,
    'docente': docente,
    'seccion': seccion,
    'estudiantes': estudiantes,
    'notas': grades?.toJson(),
    'asistencia': asistencia?.toJson(),
    'tipoAsignatura': tipoAsignatura,
    'sala': sala,
    'horario': horario,
    'intentos': intentos,
    'tipoSala': tipoSala,
  };
}

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
