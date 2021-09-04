import 'package:flutter/material.dart';
import 'package:mi_utem/models/asignatura.dart';

class Horario {
  List<Asignatura>? asignaturas;
  List<List<BloqueHorario>>? horario;
  List<dynamic>? dias;
  List<Periodo>? periodos;

  Horario({
    this.asignaturas,
    this.horario,
    this.dias,
    this.periodos
  });

  factory Horario.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Horario();
    }
    return Horario(
      asignaturas: Asignatura.fromJsonList(json['asignaturas']),
      horario: BloqueHorario.fromJsonMatrix(json['horario']),
      dias: json["dias"],
      periodos: Periodo.fromJsonList(json["periodos"]),
    );
  }

  static List<Horario> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Horario> list = [];
    for (var item in json) {
      list.add(Horario.fromJson(item));
    }
    return list;
  }

  List<String?> get horasInicio {
    return periodos!.map((periodo) => periodo.horaInicio).toList();
  }

  List<String?> get horasIntermedio {
    return periodos!.map((periodo) => periodo.horaIntermedio).toList();
  }

  List<String?> get horasTermino {
    return periodos!.map((periodo) => periodo.horaTermino).toList();
  }

  List<List<BloqueHorario>> get horarioEnlazado {
    List<List<BloqueHorario>> horarioNuevo = [];

    List<Color> colores = Colors.primaries.toList()..shuffle();

    for (num i = 0; i < asignaturas!.length; i++) {
      var asignatura = asignaturas![i as int];
      asignatura.colorAsignatura = colores[i];
    }

    for (List<BloqueHorario> fila in horario!) {
      List<BloqueHorario> filaNueva = [];
      for (BloqueHorario bloque in fila) {
        for (Asignatura asignatura in asignaturas!) {
          if (bloque.codigo == asignatura.codigo) {
            bloque.asignatura = asignatura;
          }
        }
        filaNueva.add(bloque);
      }
      horarioNuevo.add(filaNueva);
    }
    return horarioNuevo;
  }
}

class Periodo {
  String? numero;
  String? horaInicio;
  String? horaIntermedio;
  String? horaTermino;

  Periodo({
    this.numero,
    this.horaInicio,
    this.horaIntermedio,
    this.horaTermino
  });

  factory Periodo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Periodo();
    }
    return Periodo(
      numero: json["numero"],
      horaInicio: json["horaInicio"],
      horaIntermedio: json["horaIntermedio"],
      horaTermino: json["horaTermino"]
    );
  }

  static List<Periodo> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Periodo> list = [];
    for (var item in json) {
      list.add(Periodo.fromJson(item));
    }
    return list;
  }
}

class BloqueHorario {
  Asignatura? asignatura;
  String? sala;
  String? codigo;

  BloqueHorario({
    this.asignatura,
    this.sala,
    this.codigo,
  });

  factory BloqueHorario.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return BloqueHorario();
    }
    return BloqueHorario(
      asignatura: json['asignatura'],
      sala: json['sala'],
      codigo: json['codigo']
    );
  }

  static List<List<BloqueHorario>>? fromJsonMatrix(dynamic json) {
    if (json == null) {
      return null;
    }
    List<List<BloqueHorario>> matrix = [];
    for (var row in json) {
      List<BloqueHorario> list = [];
      for (var col in row) {
        list.add(BloqueHorario.fromJson(col));
      }
      matrix.add(list);
    }
    return matrix;
  }
}