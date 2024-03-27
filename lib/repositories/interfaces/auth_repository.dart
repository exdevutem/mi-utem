import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/models/user/user.dart';

abstract class AuthRepository {

  /* Envía las credenciales y retorna al usuario */
  Future<User> auth({
    required Credentials credentials,
  });

  /* Refresca y retorna el nuevo token */
  Future<String> refresh({
    required String token,
    required Credentials credentials,
  });

  /* Actualiza la foto de perfil y retorna la url */
  Future<String> updateProfilePicture({
    required String image,
  });
}