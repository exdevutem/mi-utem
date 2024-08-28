import 'dart:convert';

import 'package:mi_utem/core/models/tokenized_object.dart';
import 'package:mi_utem/core/models/user/perfil.dart';
import 'package:mi_utem/core/models/user/persona/rut.dart';
import 'package:mi_utem/utils/string_utils.dart';

class Estudiante extends TokenizedUser {

  final Rut rut;
  final String nombreCompleto;
  final String correoPersonal;
  final String correoUtem;
  final String fotoUrl;
  final List<Perfil> perfiles;

  Estudiante({
    required super.token,
    required this.rut,
    required this.nombreCompleto,
    required this.correoPersonal,
    required this.correoUtem,
    required this.fotoUrl,
    required this.perfiles,
  });

  String get nombreCompletoCapitalizado => capitalize(nombreCompleto.trim());
  String get primerNombre => nombreCompletoCapitalizado.split(' ')[0];
  String get iniciales => nombreCompletoCapitalizado.split(' ').map((it) => it[0]).join('');

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    final datosPersona = json['datos_persona'];

    return Estudiante(
      token: json['token'],
      rut: Rut.fromString("${datosPersona['rut']}"),
      nombreCompleto: datosPersona['nombre_completo'],
      correoPersonal: datosPersona['correo_personal'],
      correoUtem: datosPersona['correo_utem'],
      fotoUrl: datosPersona['foto'],
      perfiles: Perfil.values.where((perfil) => (datosPersona['perfiles'] as List).contains(perfil.name)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
    'datos_persona': {
      'rut': rut.rut,
      'nombre_completo': nombreCompleto,
      'correo_personal': correoPersonal,
      'correo_utem': correoUtem,
      'foto': fotoUrl,
      'perfiles': perfiles.map((perfil) => perfil.name).toList(),
    },
  };

  @override
  String toString() => jsonEncode(toJson());
}