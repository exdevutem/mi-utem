import 'package:mi_utem/core/models/user/persona/rut.dart';
import 'package:mi_utem/utils/string_utils.dart';

class Persona {

  final Rut? rut;
  final String nombreCompleto;

  const Persona({
    this.rut,
    required this.nombreCompleto,
  });

  String get nombreCompletoCapitalizado => capitalize(nombreCompleto.trim());
  String get primerNombre => nombreCompletoCapitalizado.split(' ')[0];
  String get iniciales => nombreCompletoCapitalizado.split(' ').map((it) => it[0]).join('');

  factory Persona.fromJson(Map<String, dynamic> json) => Persona(
      rut: json.containsKey("rut") ? Rut.fromString(json['rut'] as String) : null,
      nombreCompleto: json['nombreCompleto'],
    );

}