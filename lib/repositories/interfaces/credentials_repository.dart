import 'package:mi_utem/models/user/credential.dart';

abstract class CredentialsRepository {

  /*
    Verifica si existen credenciales guardadas
    @return true si existen credenciales guardadas, false en caso contrario
  */
  Future<bool> hasCredentials();

  /*
    Obtiene las credenciales guardadas
    @return Credenciales guardadas
  */
  Future<Credentials?> getCredentials();

  /*
    Guarda las credenciales
    @param credential Credenciales a guardar
  */
  Future<void> setCredentials(Credentials? credential);
}