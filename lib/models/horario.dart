import 'dart:developer';

import 'package:mi_utem/models/asignatura.dart';

class Horario {
  List<Asignatura>? asignaturas;
  List<List<BloqueHorario>>? horario;
  List<dynamic>? dias = [
    'Lunes',
    'Martes',
    'Miércoles',
    'Jueves',
    'Viernes',
    'Sábado'
  ];
  List<Periodo>? periodos = [
    Periodo(
        horaInicio: "08:00",
        horaIntermedio: "08:45",
        horaTermino: "09:30",
        numero: "1"),
    Periodo(
        horaInicio: "09:40",
        horaIntermedio: "10:25",
        horaTermino: "11:10",
        numero: "2"),
    Periodo(
        horaInicio: "11:20",
        horaIntermedio: "12:05",
        horaTermino: "12:50",
        numero: "3"),
    Periodo(
        horaInicio: "13:00",
        horaIntermedio: "13:45",
        horaTermino: "14:30",
        numero: "4"),
    Periodo(
        horaInicio: "14:40",
        horaIntermedio: "15:25",
        horaTermino: "16:10",
        numero: "5"),
    Periodo(
        horaInicio: "16:20",
        horaIntermedio: "17:05",
        horaTermino: "17:50",
        numero: "6"),
    Periodo(
        horaInicio: "18:00",
        horaIntermedio: "18:45",
        horaTermino: "19:30",
        numero: "7"),
    Periodo(
        horaInicio: "19:40",
        horaIntermedio: "20:25",
        horaTermino: "21:10",
        numero: "8"),
    Periodo(
        horaInicio: "21:20",
        horaIntermedio: "22:05",
        horaTermino: "22:50",
        numero: "9"),
  ];

  Horario({this.asignaturas, this.horario, this.dias, this.periodos});

  factory Horario.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Horario();
    }
    return Horario(
      // asignaturas: Asignatura.fromJsonList(json['asignaturas']),
      horario: BloqueHorario.fromJsonMatrix(json['horario']),
      // dias: json["dias"],
      // periodos: Periodo.fromJsonList(json["periodos"]),
    );
  }

  static List<Horario> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Horario> list = [];
    for (var bloque in json) {
      log('bloque: $bloque');
      for (var dia in bloque) {
        log('dia: $dia');
        list.add(Horario.fromJson(dia));
      }
    }
    return list;
  }

  List<String?> get horasInicio {
    return [
      "08:00",
      "09:40",
      "11:20",
      "13:00",
      "14:40",
      "16:20",
      "18:00",
      "19:40",
      "21:20"
    ];
  }

  List<String?> get horasIntermedio {
    return [
      "08:45",
      "10:25",
      "12:05",
      "13:45",
      "15:25",
      "17:05",
      "18:45",
      "20:25",
      "22:05"
    ];
  }

  List<String?> get horasTermino {
    return [
      "09:30",
      "11:10",
      "12:50",
      "14:30",
      "16:10",
      "17:50",
      "19:30",
      "21:10",
      "22:50"
    ];
  }

  List<String?> get diasHorario {
    return ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];
  }

  List<List<BloqueHorario>> get horarioEnlazado {
    List<List<BloqueHorario>> horarioNuevo = [];

    for (List<BloqueHorario> fila in horario!) {
      List<BloqueHorario> filaNueva = [];
      for (BloqueHorario bloque in fila) {
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

  Periodo(
      {this.numero, this.horaInicio, this.horaIntermedio, this.horaTermino});

  factory Periodo.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Periodo();
    }
    return Periodo(
        numero: json["numero"],
        horaInicio: json["horaInicio"],
        horaIntermedio: json["horaIntermedio"],
        horaTermino: json["horaTermino"]);
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
  String? asignatura;
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
        asignatura: json['asignatura']['nombre'],
        sala: json['asignatura']['sala'],
        codigo:
            "${json['asignatura']['codigo']}/${json['asignatura']['seccion']}");
  }

  static List<List<BloqueHorario>>? fromJsonMatrix(dynamic json) {
    if (json == null) {
      return null;
    }
    List<List<BloqueHorario>> matrix = [];
    for (var bloque in json) {
      List<BloqueHorario> list = [];
      for (var dia in bloque) {
        list.add(BloqueHorario.fromJson(dia));
      }
      matrix.add(list);
    }
    return matrix;
  }
}
