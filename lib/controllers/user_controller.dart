import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/controllers/carreras_controller.dart';
import 'package:mi_utem/controllers/lunch_coupons_controller.dart';
import 'package:mi_utem/models/carrera.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/analytics_service.dart';
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

  final user = Rxn<Usuario>(null);
  final selectedCarrera = Rxn<Carrera>();
  final roles = RxList<Role>([]);

  FutureOr<String?>? _tokenRefresher;

  @override
  void onInit() {
    super.onInit();

    final user = _getStoredUser();
    if (user != null) {
      this.user.value = user;
    }

    ever(this.user, (Usuario? user) {
      if (UserController.to.isLoggedIn && user != null) {
        AnalyticsService.setUser(user);
      } else {
        AnalyticsService.removeUser();
      }
    });

    ever(this.selectedCarrera, (Carrera? carrera) {
      _setRoles();
    });

    ever(LunchBenefitController.to.state.obs, (LunchBenefit? couponsView) {
      _setRoles();
    });
  }

  Future<Usuario> login(String correo, String contrasenia) async {
    try {
      final user = await AuthService.login(correo, contrasenia);

      _box.write(_storageFirstTimeKey, true);

      _storeCredentials(user, contrasenia);
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
    return user.value != null;
  }

  Future<void> logOut() async {
    try {
      invalidateToken();
      _box.remove(_storageUserKey);
      await _secureStorage.deleteAll();
      try {
        await PerfilService.deleteFcmToken();
      } catch (e) {}
      user.value = null;
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<String> refreshToken() async {
    log("refreshToken");

    if (_tokenRefresher != null) {
      log("refreshToken _tokenRefresher != null $_tokenRefresher");
      final token = await (_tokenRefresher as FutureOr<String>);

      log("refreshToken _tokenRefresher != null token $token");

      return token;
    }

    log("refreshToken _tokenRefresher == null");

    try {
      final email = user.value?.correoUtem;
      final password = await _secureStorage.read(key: _storagePasswordKey);

      log("refreshToken _tokenRefresher == null email $email password $password");

      if (email != null && password != null) {
        _tokenRefresher = AuthService.refreshToken(email, password);
        final token = await (_tokenRefresher as FutureOr<String>);
        _storeToken(token);

        _tokenRefresher = null;

        log("refreshToken _tokenRefresher == null token $token");

        return token;
      }
      throw Exception("No se pudo refrescar el token");
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  void _storeUser(Usuario userToStore) async {
    user.value = userToStore;

    _box.write(_storageUserKey, jsonEncode(userToStore.toJson()));
  }

  static void _storeCredentials(Usuario user, String contrasenia) async {
    _box.write(_storageTokenKey, user.token);
    await _secureStorage.write(key: _storagePasswordKey, value: contrasenia);
  }

  Usuario? _getStoredUser() {
    final user = _box.read(_storageUserKey);
    if (user == null) return null;

    return Usuario.fromJson(jsonDecode(user));
  }

  static void _storeToken(String token) async {
    _box.write(_storageTokenKey, token);
  }

  String getToken() {
    final token = _box.read(_storageTokenKey);
    if (token == null) throw Exception("No se ha encontrado el token");

    return token;
  }

  void invalidateToken() async {
    _box.remove(_storageTokenKey);
  }

  void _setRoles() {
    final user = this.user.value;
    final carreras = CarrerasController.to.state;
    final lunchBenefit = LunchBenefitController.to.state;

    final roles = <Role>[];

    if (user != null) {
      if (carreras != null && carreras.length > 0) {
        roles.add(Role.hasCareers);
        final hasActive = carreras.firstWhereOrNull((c) => c.isActive) != null;

        if (hasActive) {
          roles.add(Role.hasActiveCareer);
        }
      }

      if (lunchBenefit?.hasBenefit == true) {
        roles.add(Role.hasLunchBenefit);
      }
    }
    this.roles.value = roles;
  }

  void selectCarrera(Carrera carrera) {
    selectedCarrera.value = carrera;
  }
}
