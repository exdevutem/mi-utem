import 'dart:convert';

class Credentials {

  final String email;
  final String password;

  const Credentials({
    required this.email,
    required this.password,
  });

  toJson() => {
    'correo': email,
    'contrasenia': password,
  };

  @override
  String toString() => jsonEncode(toJson());
  
  factory Credentials.fromJson(Map<String, dynamic> json) => Credentials(
    email: json['correo'] as String,
    password: json['contrasenia'] as String,
  );
}