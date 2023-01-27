import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:recase/recase.dart';

class Asignatura {
  String? id;
  String? nombre;
  String? codigo;
  String? tipoHora;
  String? estado;
  String? docente;
  String? seccion;
  List<REvaluacion> notasParciales;
  num? notaExamen;
  num? notaPresentacion;
  num? notaFinal;
  Asistencia? asistencia;
  List<Usuario>? estudiantes;
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
    this.notasParciales = const [],
    this.notaFinal,
    this.notaPresentacion,
    this.docente,
    this.seccion,
    this.notaExamen,
    this.asistencia,
    this.estudiantes,
    this.tipoAsignatura,
    this.sala,
    this.horario,
    this.intentos,
    this.tipoSala,
  });

  factory Asignatura.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Asignatura();
    }

    return Asignatura(
      id: json['id'],
      codigo: json['codigo'],
      nombre: ReCase(json['nombre'] ?? '').titleCase,
      tipoHora: ReCase(json['tipoHora'] ?? '').titleCase,
      estado: ReCase(json['estado'] ?? '').titleCase,
      docente: ReCase(json['docente'] ?? '').titleCase,
      seccion: json['seccion'],
      notasParciales: REvaluacion.fromJsonList(json['notasParciales']),
      notaFinal: json['notaFinal'] as num?,
      notaPresentacion: json['notaPresentacion'] as num?,
      notaExamen: json['notaExamen'] as num?,
      // estudiantes: Usuario.fromJsonList(json["estudiantes"]),
      asistencia: Asistencia(asistidos: json['asistenciaAlDia']),
      // tipoAsignatura: ReCase(json['tipoAsignatura'].toString()).titleCase,
      sala: ReCase(json['sala'] ?? '').titleCase,
      horario: json['horario'],
      intentos: json['intentos'] != null ? int.parse(json['intentos']) : 0,
      tipoSala: ReCase(json['tipoSala'] ?? '').titleCase,
    );
  }

  static List<Asignatura> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Asignatura> list = [];
    for (var item in json) {
      list.add(Asignatura.fromJson(item));
    }
    return list;
  }

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

  factory Asistencia.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Asistencia();
    }
    return Asistencia(
      total: json['total'] ?? 0,
      asistidos: json['asistida'] ?? 0,
      noAsistidos: json['noAsistidos'] ?? 0,
      sinRegistro: json['sinRegistro'] ?? 0,
    );
  }

  static List<Asistencia> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Asistencia> list = [];
    for (var item in json) {
      list.add(Asistencia.fromJson(item));
    }
    return list;
  }
}
