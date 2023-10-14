import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/auth_service.dart';
import 'package:mi_utem/services/perfil_service.dart';

class UserController extends GetxController {
  static const _storageTokenKey = 'token';
  static const _storageUserKey = 'user';
  static const _storageFirstTimeKey = 'esAntiguo';
  static const _storagePasswordKey = 'contrasenia';

  static final GetStorage _box = GetStorage();
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static UserController get to => Get.find();

  Future<Usuario> login(String correo, String contrasenia) async {
    try {
      final user = await AuthService.login(correo, contrasenia);

      if (user.token != null) {
        _box.write(_storageTokenKey, user.token!);
      }

      _box.write(_storageFirstTimeKey, true);

      await _secureStorage.write(key: _storagePasswordKey, value: contrasenia);

      _storeUser(user);

      return user;
    } catch (e) {
      throw e;
    }
  }

  bool get isFirstTime {
    return _box.read(_storageFirstTimeKey).toString() == 'true';
  }

  bool get isLoggedIn {
    try {
      String? token = _box.read(_storageTokenKey);
      Usuario? user = _getUser();

      return token != null && token.isNotEmpty && user != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> logOut() async {
    try {
      _box.remove(_storageTokenKey);
      _box.remove(_storageUserKey);
      await _secureStorage.deleteAll();
      try {
        await PerfilService.deleteFcmToken();
      } catch (e) {}
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<String> refreshToken() async {
    try {
      final user = getUser();
      final email = user.correoUtem;
      final password = await _secureStorage.read(key: _storagePasswordKey);

      if (email != null && password != null) {
        final token = await AuthService.refreshToken(email, password);
        _storeToken(token);

        return token;
      }
      throw Exception("No se pudo refrescar el token");
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  static void _storeUser(Usuario user) async {
    _box.write(_storageUserKey, jsonEncode(user.toJson()));
  }

  Usuario getUser() {
    final user = _getUser();
    if (user == null) throw Exception("No se ha encontrado el usuario");

    return user;
  }

  Usuario? _getUser() {
    final user = _box.read(_storageUserKey);
    if (user == null) return null;

    return Usuario.fromJson(jsonDecode(user));
  }

  static void _storeToken(String token) async {
    _box.write('token', token);
  }

  String getToken() {
    final token = _box.read('token');
    if (token == null) throw Exception("No se ha encontrado el token");

    return token;
  }

  void invalidateToken() async {
    _box.remove('token');
  }
}
