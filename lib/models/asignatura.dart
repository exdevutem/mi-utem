import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_utem/models/evaluacion.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Asignatura {
  String? id;
  String? nombre;
  String? codigo;
  String? tipoHora;
  String? estado;
  String? docente;
  String? seccion;
  Color? colorAsignatura;
  List<Evaluacion> evaluaciones;
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
    this.colorAsignatura,
    this.tipoHora,
    this.estado,
    this.evaluaciones = const [],
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

  Future<void> addColor(List<Color> colores) async {
    List<Color> coloresFiltrados = colores;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> json = {};

    if (prefs.containsKey('coloresAsignaturas') &&
        prefs.getString('coloresAsignaturas') != null) {
      json = jsonDecode(prefs.getString('coloresAsignaturas')!);
    }

    List<Color> coloresUsados = json.values.map((c) => Color(c)).toList();
    coloresFiltrados.retainWhere((c) => !coloresUsados.contains(c));

    if (!json.containsKey(this.codigo)) {
      this.colorAsignatura = coloresFiltrados[0];
      json[this.codigo!] = coloresFiltrados[0].value;
      prefs.setString('coloresAsignaturas', jsonEncode(json));
    } else {
      this.colorAsignatura = Color(json[this.codigo!]!);
    }
  }

  factory Asignatura.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Asignatura();
    }

    var asignaturaParseada = Asignatura(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'] != null ? ReCase(json['nombre']).titleCase : null,
      tipoHora:
          json['tipoHora'] != null ? ReCase(json['tipoHora']).titleCase : null,
      estado: json['estado'] != null ? ReCase(json['estado']).titleCase : null,
      docente:
          json['docente'] != null ? ReCase(json['docente']).titleCase : null,
      seccion: json['seccion'],
      evaluaciones: json['evaluaciones'] != null
          ? Evaluacion.fromJsonList(json['evaluaciones'])
          : [],
      notaFinal: json['notaFinal'] != null ? json['notaFinal'] : null,
      notaPresentacion:
          json['notaPresentacion'] != null ? json['notaPresentacion'] : null,
      notaExamen: json['notaExamen'] != null ? json['notaExamen'] : null,
      // estudiantes: Usuario.fromJsonList(json["estudiantes"]),
      asistencia: json['asistenciaAlDia'] != null
          ? Asistencia(asistidos: json['asistenciaAlDia'])
          : null,
      tipoAsignatura: json['tipoAsignatura'] != null
          ? ReCase(json['tipoAsignatura'].toString()).titleCase
          : null,
      sala: json['sala'] != null ? ReCase(json['sala']).titleCase : null,
      horario: json['horario'],
      intentos: json['intentos'] != null ? int.parse(json['intentos']) : 0,
      tipoSala:
          json['tipoSala'] != null ? ReCase(json['tipoSala']).titleCase : null,
    );

    List<Color> colores = Colors.primaries.toList()..shuffle();
    asignaturaParseada.addColor(colores);
    return asignaturaParseada;
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
        break;
      case "Reprobado":
        return MainTheme.reprobadoColor;
        break;
      default:
        return MainTheme.inscritoColor;
    }
  }

  num get notaPresentacionCalculada {
    double presentacion = 0;
    for (var evaluacion in evaluaciones) {
      if (evaluacion.nota != null && evaluacion.porcentaje != null) {
        presentacion += evaluacion.nota! * (evaluacion.porcentaje! / 100);
      }
    }

    return presentacion;
  }

  bool get estanTodasLasNotas {
    for (var evaluacion in evaluaciones) {
      if (evaluacion.nota == null) {
        return false;
      }
    }
    return true;
  }

  bool get puedeDarExamen {
    if (estanTodasLasNotas) {
      return 2.95 <= this.notaPresentacionCalculada &&
          this.notaPresentacionCalculada < 3.95;
    }
    return false;
  }

  bool get estaReprobandoCalculado {
    return notaPresentacionCalculada < 2.95;
  }

  bool get estaAprobandoCalculado {
    return notaPresentacionCalculada >= 3.95;
  }

  Color get colorPorEstadoCalculado {
    if (estanTodasLasNotas) {
      if (estaAprobandoCalculado) {
        return MainTheme.aprobadoColor;
      } else if (estaReprobandoCalculado) {
        return MainTheme.reprobadoColor;
      }
    }
    return MainTheme.inscritoColor;
  }

  String get estadoCalculado {
    if (estanTodasLasNotas) {
      if (estaAprobandoCalculado) {
        return "Aprobado";
      } else if (estaReprobandoCalculado) {
        return "Reprobado";
      }
    }
    return "Inscrito";
  }

  num get examenMinimoCalculado {
    return (((3.95 - notaPresentacionCalculada * 0.6) / 0.4) * 10).ceil() / 10;
  }

  num get notaFinalCalculada {
    if (puedeDarExamen && notaExamen != null) {
      return notaPresentacionCalculada * 0.6 + notaExamen! * 0.4;
    } else {
      return notaPresentacionCalculada;
    }
  }
}

class Asistencia {
  num total;
  num asistidos;
  num noAsistidos;
  num sinRegistro;

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
