import 'dart:convert';

import 'package:mi_utem/core/models/user/credential.dart';
import 'package:mi_utem/core/models/user/estudiante.dart';
import 'package:mi_utem/core/utils/constants.dart';

const CREDENTIALS_KEY = "auth_credentials";
const ESTUDIANTE_KEY = "estudiante";

class SecureStorageRepository {

  /* Estudiante */
  Future<Estudiante?> getEstudiante() async {
    if(!await hasEstudiante()) {
      return null;
    }

    final data = await secureStorage.read(key: ESTUDIANTE_KEY);
    if(data == null) {
      return null;
    }

    return Estudiante.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<bool> hasEstudiante() async => await secureStorage.containsKey(key: ESTUDIANTE_KEY);

  Future<void> setEstudiante(Estudiante? estudiante) async => estudiante == null ? await secureStorage.delete(key: ESTUDIANTE_KEY) : await secureStorage.write(key: ESTUDIANTE_KEY, value: estudiante.toString());

  /* Credentials */
  Future<Credentials?> getCredentials() async  {
    if(!await hasCredentials()) {
      return null;
    }

    final data = await secureStorage.read(key: CREDENTIALS_KEY);
    if(data == null) {
      return null;
    }

    return Credentials.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<bool> hasCredentials() async => await secureStorage.containsKey(key: CREDENTIALS_KEY);

  Future<void> setCredentials(Credentials? credential) async => credential == null ? await secureStorage.delete(key: CREDENTIALS_KEY) : await secureStorage.write(key: CREDENTIALS_KEY, value: credential.toString());
}