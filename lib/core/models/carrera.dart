import 'dart:convert';

import 'package:mi_utem/utils/string_utils.dart';

class Carrera {
  final String id;
  final String nombre;
  final String estado;
  final String codigo;

  const Carrera({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.codigo
  });

  factory Carrera.fromJson(Map<String, dynamic> json) => Carrera(
    id: json['carrera_id'],
    nombre: capitalize(json['nombre_carrera']),
    estado: capitalize(json['situacion_academica']).trim(),
    codigo: (json['codigo_carrera'] as int).toString(),
  );

  static List<Carrera> fromJsonList(dynamic json) => json != null ? (json as List).map((it) => Carrera.fromJson(it)).toList() : [];

  toJson() => {
    'id': id,
    'nombre': nombre,
    'estado': estado,
    'codigo': codigo,
  };

  @override
  String toString() => jsonEncode(toJson());
}
