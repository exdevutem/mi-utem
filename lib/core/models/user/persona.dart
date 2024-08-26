import 'dart:convert';

import 'package:mi_utem/core/models/user/perfil.dart';
import 'package:mi_utem/models/user/rut.dart';
import 'package:mi_utem/utils/string_utils.dart';

class Persona {

  final Rut rut;
  final String nombreCompleto;
  final String correoPersonal;
  final String correoUtem;
  final String fotoUrl;
  final List<Perfil> perfiles;

  Persona({
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

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
    rut: Rut.fromString("${json['rut']}"),
    nombreCompleto: json['nombre_completo'],
    correoPersonal: json['correo_personal'],
    correoUtem: json['correo_utem'],
    fotoUrl: json['foto'],
    perfiles: Perfil.values.where((perfil) => (json['perfiles'] as List).contains(perfil.name)).toList(),
  );

  Map<String, dynamic> toJson() => {
    'rut': rut.rut,
    'nombre_completo': nombreCompleto,
    'correo_personal': correoPersonal,
    'correo_utem': correoUtem,
    'foto': fotoUrl,
    'perfiles': perfiles.map((perfil) => perfil.name).toList(),
  };

  @override
  String toString() => jsonEncode(toJson());
}