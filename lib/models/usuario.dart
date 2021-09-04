import 'package:mi_utem/models/rut.dart';
import 'package:recase/recase.dart';

class Usuario {
  String? nombre;
  String? nombres;
  String? apellidos;
  String? correo;
  String? sesion;
  String? fotoUrl;
  Rut? rut;

  Usuario({
    this.correo,
    this.sesion,
    this.nombres,
    this.nombre,
    this.fotoUrl,
    this.apellidos,
    this.rut
  });

  factory Usuario.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Usuario();
    }
    return Usuario(
      rut: json['rut'] != null ? Rut.deEntero(json['rut']) : null,
      correo: json['correo'],
      sesion: json['sesion'],
      fotoUrl: json['fotoUrl'],
      nombres: json['nombres'] != null ? ReCase(json['nombres']).titleCase : null,
      nombre: json['nombreCompleto'] != null ? ReCase(json['nombreCompleto']).titleCase : null,
      apellidos: json['apellidos'] != null ? ReCase(json['apellidos']).titleCase : null
    );
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
      return "$nombres $apellidos";
    }
    
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
