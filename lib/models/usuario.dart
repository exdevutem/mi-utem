import 'package:recase/recase.dart';

import 'package:mi_utem/models/rut.dart';

class Usuario {
  String? nombre;
  String? nombres;
  String? apellidos;
  String? correoUtem;
  String? correoPersonal;
  String? token;
  String? fotoUrl;
  Rut? rut;

  Usuario(
      {this.correoUtem,
      this.correoPersonal,
      this.token,
      this.nombres,
      this.nombre,
      this.fotoUrl,
      this.apellidos,
      this.rut});

  factory Usuario.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Usuario();
    }
    return Usuario(
        rut: json['rut'] != null
            ? (json['rut'] is int
                ? Rut.deEntero(json['rut'])
                : Rut.deString(json["rut"]))
            : null,
        correoUtem: json['correoUtem'],
        correoPersonal: json['correoPersonal'],
        token: json['token'],
        fotoUrl: json['fotoUrl'],
        nombres:
            json['nombres'] != null ? ReCase(json['nombres']).titleCase : null,
        nombre: json['nombreCompleto'] != null
            ? ReCase(json['nombreCompleto']).titleCase
            : null,
        apellidos: json['apellidos'] != null
            ? ReCase(json['apellidos']).titleCase
            : null);
  }

  static List<Usuario> fromJsonList(dynamic json) {
    if (json == null) {
      return [];
    }
    List<Usuario> list = [];
    for (var item in json) {
      list.add(Usuario.fromJson(item));
    }
    return list;
  }

  String? get nombreCompleto {
    if (nombre != null && nombre!.isNotEmpty) {
      return nombre;
    } else {
      String completo = '';
      if (nombres != null && nombres!.isNotEmpty) {
        completo += nombres!;
      }
      if (apellidos != null && apellidos!.isNotEmpty) {
        if (completo.isNotEmpty) {
          completo += ' ';
        }
        completo += apellidos!;
      }
      return completo;
    }
  }

  String get primerNombre {
    return nombreCompleto!.split(' ')[0];
  }

  String get iniciales => primeraLetraCadaPalabra(this.nombreCompleto);

  String primeraLetraCadaPalabra(String? sentence) {
    if (sentence == null || sentence.isEmpty) {
      return "NN";
    } else {
      List<String> words = sentence.split(" ");
      List<String> letters = [];

      for (var word in words) {
        letters.add('${word[0]}');
      }
      return letters.join("");
    }
  }
}
