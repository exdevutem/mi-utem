import 'dart:convert';

import 'package:mi_utem/models/user/rut.dart';

class User {

  String? token;
  Rut? rut;

  String? correoPersonal;
  String? correoUtem;

  String? fotoBase64;
  List<String> perfiles;

  String nombreCompleto;
  String? nombres;
  String? apellidos;

  String? username;
  String? fotoUrl;

  get nombreCompletoCapitalizado => nombreCompleto.toLowerCase().split(' ').map((it) => it[0].toUpperCase() + it.substring(1)).join(' ');
  get nombreDisplayCapitalizado => "${nombres?.split(' ')[0]} $apellidos".toLowerCase().split(' ').map((it) => it[0].toUpperCase() + it.substring(1)).join(' ');
  get primerNombre => nombreCompletoCapitalizado.split(' ')[0];
  get iniciales => nombreCompletoCapitalizado.split(' ').map((it) => it[0].toUpperCase()).join('');

  User({
    this.token,
    this.rut,
    this.correoPersonal = "N/N",
    this.correoUtem,
    this.fotoBase64,
    this.perfiles = const [],
    this.nombreCompleto = "N/N",
    this.nombres,
    this.apellidos,
    this.username,
    this.fotoUrl
  });

  static List<User> fromJsonList(List<dynamic>? list)  => list != null ? list.map((json) => User.fromJson(json as Map<String, dynamic>)).toList() : [];

  factory User.fromJson(Map<String, dynamic> json) => User(
    token: json['token'],
    rut: json.containsKey('rut') ? Rut.fromString("${json['rut']}") : null,
    correoPersonal: json['correoPersonal'],
    correoUtem: json['correoUtem'],
    fotoBase64: json['fotoBase64'],
    perfiles: ((json['perfiles'] as List<dynamic>?) ?? []).map((it) => it.toString()).toList(),
    nombreCompleto: json['nombreCompleto'],
    nombres: json['nombres'],
    apellidos: json['apellidos'],
    username: json['username'],
    fotoUrl: json['fotoUrl'],
  );

  Map<String, dynamic> toJson() => {
    'token': token,
    'rut': rut?.rut,
    'correoPersonal': correoPersonal,
    'correoUtem': correoUtem,
    'fotoBase64': fotoBase64,
    'perfiles': perfiles,
    'nombreCompleto': nombreCompleto,
    'nombres': nombres,
    'apellidos': apellidos,
    'username': username,
    'fotoUrl': fotoUrl
  };

  @override
  String toString() => jsonEncode(toJson());
}