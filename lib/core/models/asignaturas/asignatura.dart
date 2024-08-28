import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/asignaturas/asistencia.dart';
import 'package:mi_utem/core/models/evaluacion/grades.dart';
import 'package:mi_utem/core/models/user/persona/persona.dart';
import 'package:mi_utem/core/models/user/persona/rut.dart';
import 'package:mi_utem/core/utils/utils.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/utils/string_utils.dart';

class Asignatura {
  String id;
  String nombre;
  String codigo;
  String tipoHora;
  String estado;
  String seccion;
  Persona docente;

  Asistencia? asistencia;
  Grades? grades;
  List<Persona>? estudiantes;
  String? tipoAsignatura;
  num? intentos;
  String? horario;
  String? sala;
  String? tipoSala;

  Asignatura({
    required this.id,
    required this.nombre,
    required this.codigo,
    required this.tipoHora,
    required this.estado,
    required this.seccion,
    required this.docente,
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

  factory Asignatura.fromJson(Map<String, dynamic> json) => Asignatura(
    id: json['seccion_id'],
    codigo: json['codigo_asignatura'],
    nombre: capitalize(json['nombre_asignatura'] ?? ''),
    tipoHora: capitalize(json['tipo_hora'] ?? ''),
    estado: '', // TODO: Agregar estado de aprobado, reprobado o inscrito.
    docente: let<String, Persona?>(json['profesor'], (String? docente) {
      final partes = (docente ?? '').split("-").map((it) => it.trim());
      if(partes.isEmpty) {
        return null;
      }

      if(partes.length == 1) {
        return Persona(nombreCompleto: capitalize(partes.first));
      }

      final numeroRut = int.tryParse(partes.first);
      return Persona(
        nombreCompleto: capitalize(partes.last.trim()),
        rut: numeroRut != null ? Rut(numeroRut) : null,
      );
    }) ?? Persona(nombreCompleto: "Sin Docente"),
    seccion: json['seccion'],
    // asistencia: Asistencia(asistidos: json['asistencia_al_dia']), // TODO: Implementar asistencia de sisei (entrega un porcentaje)
    tipoAsignatura: capitalize(json['tipo_asignatura'] as String? ?? ''),
    sala: capitalize(json['sala'] ?? ''),
    horario: json['horario'],
    intentos: num.tryParse('${json['intentos'] ?? ''}') ?? 1,
    // tipoSala: capitalize(json['tipoSala'] ?? ''), // TODO: Obtener tipo de sala desde api-mi-utem
  );

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
    'notas': grades?.toJson() ?? [],
    'asistencia': asistencia?.toJson() ?? {},
    'tipoAsignatura': tipoAsignatura,
    'sala': sala,
    'horario': horario,
    'intentos': intentos,
    'tipoSala': tipoSala,
  };

  @override
  String toString() => jsonEncode(toJson());

  Asignatura copyWith({
    String? id,
    String? nombre,
    String? codigo,
    String? tipoHora,
    String? estado,
    Persona? docente,
    String? seccion,
    Asistencia? asistencia,
    Grades? grades,
    List<Persona>? estudiantes,
    String? tipoAsignatura,
    String? sala,
    String? horario,
    num? intentos,
    String? tipoSala,
  }) => Asignatura(
    id: id ?? this.id,
    nombre: nombre ?? this.nombre,
    codigo: codigo ?? this.codigo,
    tipoHora: tipoHora ?? this.tipoHora,
    estado: estado ?? this.estado,
    docente: docente ?? this.docente,
    seccion: seccion ?? this.seccion,
    asistencia: asistencia ?? this.asistencia,
    grades: grades ?? this.grades,
    estudiantes: estudiantes ?? this.estudiantes,
    tipoAsignatura: tipoAsignatura ?? this.tipoAsignatura,
    sala: sala ?? this.sala,
    horario: horario ?? this.horario,
    intentos: intentos ?? this.intentos,
    tipoSala: tipoSala ?? this.tipoSala,
  );
}