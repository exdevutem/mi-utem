import 'package:recase/recase.dart';

class Carrera {
  static const _stateActive = 'Regular';

  String? id;
  String? nombre;
  String? estado;
  String? codigo;
  String? plan;

  Carrera({this.id, this.nombre, this.estado, this.codigo, this.plan});

  bool get isActive => estado == _stateActive;

  factory Carrera.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Carrera();
    }
    return Carrera(
      id: json['id'],
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
