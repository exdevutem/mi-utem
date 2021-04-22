import 'package:mi_utem/models/rut.dart';
import 'package:recase/recase.dart';

class Carrera {
  String nombre;
  String estado;
  String codigo;
  String plan;

  Carrera({
    this.nombre,
    this.estado,
    this.codigo,
    this.plan
  });

  factory Carrera.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Carrera();
    }
    return Carrera(
      nombre: json['nombre'] != null ? ReCase(json['nombre']).titleCase : null,
      estado: json['estado'] != null ? ReCase(json['estado']).titleCase : null,
      plan: json['plan'] != null ? ReCase(json['plan']).titleCase : null,
      codigo: json['codigo'],
    );
  }

  static List<Carrera> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Carrera> list = [];
    for (var item in json) {
      list.add(Carrera.fromJson(item));
    }
    return list;
  }
}
