import 'package:mi_utem/models/user/credential.dart';

abstract class CredentialsService {

  Future<bool> hasCredentials();

  Future<Credentials?> getCredentials();

  Future<void> setCredentials(Credentials? credential);
}