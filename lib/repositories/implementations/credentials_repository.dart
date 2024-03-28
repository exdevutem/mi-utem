import 'dart:convert';

import 'package:mi_utem/config/secure_storage.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/repositories/interfaces/credentials_repository.dart';

class CredentialsRepositoryImplementation implements CredentialsRepository {

  @override
  Future<Credentials?> getCredentials() async  {
    final data = await secureStorage.read(key: "credentials");
    if(data == null || data == "null") {
      return null;
    }

    return Credentials.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  @override
  Future<bool> hasCredentials() async => await secureStorage.containsKey(key: "credentials");

  @override
  Future<void> setCredentials(Credentials? credential) async => await secureStorage.write(key: "credentials", value: credential != null ? credential.toString() : null);
  
}