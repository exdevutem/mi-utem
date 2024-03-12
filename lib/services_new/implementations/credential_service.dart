import 'dart:convert';

import 'package:mi_utem/config/secure_storage.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/services_new/interfaces/credential_service.dart';

class CredentialsServiceImplementation implements CredentialsService {

  @override
  Future<Credentials?> getCredentials() async  {
    final data = await secureStorage.read(key: "credentials");
    if(data == null) {
      return null;
    }

    return Credentials.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  @override
  Future<bool> hasCredentials() async => await secureStorage.containsKey(key: "credentials");

  @override
  Future<void> setCredentials(Credentials? credential) async => await secureStorage.write(key: "credentials", value: credential.toString());
  
}