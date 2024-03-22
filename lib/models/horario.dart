import 'package:mi_utem/models/asignaturas/asignatura.dart';

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

  factory Horario.fromJson(Map<String, dynamic>? json) => json != null ? Horario(
    // asignaturas: Asignatura.fromJsonList(json['asignaturas']),
    horario: BloqueHorario.fromJsonMatrix(json['horario']),
    // dias: json["dias"],
    // periodos: Periodo.fromJsonList(json["periodos"]),
  ) : Horario();

  static List<Horario> fromJsonList(dynamic json) => (json as List<dynamic>? ?? []).expand((bloque) => (bloque as List<dynamic>? ?? []).map((dia) => Horario.fromJson(dia))).toList();

  List<String> get horasInicio => [
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

  List<String> get horasIntermedio => [
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

  List<String> get horasTermino => [
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

  List<String> get diasHorario => ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado"];

  List<List<BloqueHorario>> get horarioEnlazado {
    final _horario = horario;
    List<List<BloqueHorario>> horarioNuevo = [];
    if(_horario == null) {
      return [];
    }

    for (List<BloqueHorario> fila in _horario) {
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

  Periodo({
    this.numero,
    this.horaInicio,
    this.horaIntermedio,
    this.horaTermino,
  });

  factory Periodo.fromJson(Map<String, dynamic>? json) => json != null ? Periodo(
    numero: json["numero"],
    horaInicio: json["horaInicio"],
    horaIntermedio: json["horaIntermedio"],
    horaTermino: json["horaTermino"],
  ) : Periodo();

  static List<Periodo> fromJsonList(dynamic json) => json != null ? (json as List<dynamic>).map((item) => Periodo.fromJson(item)).toList() : [];
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

  factory BloqueHorario.fromJson(Map<String, dynamic>? json) => json != null ? BloqueHorario(
    asignatura: Asignatura.fromJson(json['asignatura']),
    sala: json['asignatura']['sala'],
    codigo: "${json['asignatura']['codigo']}/${json['asignatura']['seccion']}",
  ) : BloqueHorario();

  static List<List<BloqueHorario>>? fromJsonMatrix(dynamic json) => json == null ? null : (json as List<dynamic>? ?? []).map((bloque) => (bloque as List<dynamic>? ?? []).map((dia) => BloqueHorario.fromJson(dia)).toList()).toList();
}
