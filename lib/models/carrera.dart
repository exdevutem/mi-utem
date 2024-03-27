import 'dart:convert';

import 'package:mi_utem/utils/string_utils.dart';

class Carrera {
  String? id;
  String? nombre;
  String? estado;
  String? codigo;
  String? plan;

  Carrera({this.id, this.nombre, this.estado, this.codigo, this.plan});

  factory Carrera.fromJson(Map<String, dynamic>? json) => json != null ?  Carrera(
    id: json['id'],
    nombre: json['nombre'] != null ? capitalize(json['nombre']) : null,
    estado: json['estado'] != null ? capitalize(json['estado']) : null,
    plan: json['plan'] != null ? capitalize(json['plan']) : null,
    codigo: json['codigo'],
  ) : Carrera();

  static List<Carrera> fromJsonList(dynamic json) => json != null ? (json as List).map((it) => Carrera.fromJson(it)).toList() : [];

  toJson() => {
    'id': id,
    'nombre': nombre,
    'estado': estado,
    'codigo': codigo,
    'plan': plan,
  };

  @override
  String toString() => jsonEncode(toJson());
}
