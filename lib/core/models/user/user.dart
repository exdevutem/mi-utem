import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:mi_utem/core/models/user/persona.dart';

class User {
  final String token;
  final Persona persona;

  User({
    required this.token,
    required this.persona,
  });

  JWT? decodeToken() => JWT.tryDecode(token);

  bool isTokenExpired() {
    final exp = decodeToken()?.payload['exp'];
    if(exp == null) {
      return true;
    }

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= exp;
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    token: json['token'],
    persona: Persona.fromJson(json['datos_persona']),
  );

  @override
  String toString() => jsonEncode(toJson());

  Map<String, dynamic> toJson() => {
    'token': token,
    'datos_persona': persona.toJson(),
  };
}