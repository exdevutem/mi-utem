import 'dart:convert';

import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/http_clients.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/repositories/interfaces/auth_repository.dart';

class AuthRepositoryImplementation extends AuthRepository {

  @override
  Future<User> auth({
    required Credentials credentials,
  }) async {
    final response = await httpClient.post(Uri.parse("$apiUrl/v1/auth"),
      body: credentials.toString(),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'App/MiUTEM',
      },
    );


    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map<String, dynamic> && json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return User.fromJson(json as Map<String, dynamic>);
  }

  @override
  Future<String> refresh({
    required String token,
    required Credentials credentials
  }) async {
    final response = await httpClient.post(Uri.parse("$apiUrl/v1/auth/refresh"),
      body: credentials.toString(),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'App/MiUTEM',
        'Authorization': 'Bearer $token',
      },
    );


    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map<String, dynamic> && json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return json["token"];
  }

  @override
  Future<String> updateProfilePicture({required String image}) async {
    final response = await authClient.put(Uri.parse("$apiUrl/v1/usuarios/foto"),
      body: jsonEncode({"imagen": image}),
    );

    final json = jsonDecode(response.body);

    if(response.statusCode != 200) {
      if(json is Map<String, dynamic> && json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    return json["fotoUrl"] as String;
  }

}