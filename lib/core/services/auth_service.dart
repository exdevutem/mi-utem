import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/user/user.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/preferencia.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/repositories/credentials_repository.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/utils/http/http_client.dart';

class AuthService {

  final httpClient = HttpClient.httpClient;
  final CredentialsRepository _credentialsService = Get.find<CredentialsRepository>();

  Future<bool> isFirstTime() async => (await Preferencia.lastLogin.exists()) == false;

  Future<bool> isLoggedIn() async => (await getUser()) != null;

  Future<User> login({ bool forceRefresh = false }) async {
    final credentials = await _getCredential();
    if(credentials == null) {
      logger.d("[AuthService#isLoggedIn]: No se encontraron credenciales.");
      throw CustomException.custom();
    }

    final user = await getUser();
    if (user != null && !forceRefresh) {
      return user;
    }

    try {
      final response = await httpClient.post("$sigaServiceUri/autenticacion/login/", data: 'username=${Uri.encodeFull(credentials.email)}&password=${Uri.encodeFull(credentials.password)}', options: Options(
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        }
      ));

      if(response.statusCode != 200 || response.data['status_code'] != 200) {
        throw CustomException.custom(message: "No logramos autenticarte.");
      }

      final user = User.fromJson(response.data['response'] as Map<String, dynamic>);
      await setUser(user);
      return user;
    } on DioError catch (e) {
      if(e.response?.statusCode == 401) {
        throw CustomException(message: "Credenciales incorrectas. Por favor intenta nuevamente.", statusCode: 401);
      }
      throw CustomException(message: e.response?.statusMessage ?? 'Error al iniciar sesión.', statusCode: e.response?.statusCode ?? 0, internalCode: 0.1);
    } catch (e) {
      logger.e(e);
      throw CustomException(message: "Ocurrió un error al autenticar. Por favor intenta más tarde.", internalCode: 0.2);
    }
  }

  Future<void> logout({ BuildContext? context}) async {
    await setUser(null);
    await _credentialsService.setCredentials(null);
    if(context != null) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (ctx) => LoginScreen()));
    }
  }

  Future<void> saveFCMToken() async {
    final user = await getUser();
    if(user == null) {
      return;
    }

    String? fcmToken;
    try {
      fcmToken = await NotificationService.fcm.requestFirebaseAppToken();
    } catch (e) {
      logger.e("[AuthService#saveFCMToken]: Error al obtener FCM Token", e);
      return;
    }

    final usersCollection = FirebaseFirestore.instance.collection('usuarios');

    try {
      await this.deleteFCMToken();
    } catch (e) {
      logger.e("[AuthService#saveFCMToken]: Error al eliminar FCM Token", e);
    }

    try {
      usersCollection.doc(user.persona.rut.rut.toString()).set({
        'fcmTokens': FieldValue.arrayUnion([fcmToken]),
      }, SetOptions(merge: true));
    } catch (e) {
      logger.e("[AuthService#saveFCMToken]: Error al guardar FCM Token", e);
    }
  }

  Future<void> deleteFCMToken() async {
    String? fcmToken;
    try {
      fcmToken = await NotificationService.fcm.requestFirebaseAppToken();
    } catch (e) {
      logger.e("[AuthService#deleteFCMToken]: Error al obtener FCM Token", e);
      return;
    }

    final usersCollection = FirebaseFirestore.instance.collection('usuarios');

    QuerySnapshot<Map<String, dynamic>> snapshotRepeated;
    try {
      snapshotRepeated = await usersCollection.where('fcmTokens', arrayContains: fcmToken).get();
    } on FirebaseException catch(e) {
      print(e);
      return;
    } catch (e) {
      logger.e("[AuthService#deleteFCMToken]: Error al obtener usuarios con FCM Token", e);
      return;
    }

    try {
      for(final doc in snapshotRepeated.docs) {
        doc.reference.set({
          "fcmTokens": FieldValue.arrayRemove([fcmToken]),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      logger.e("[AuthService#deleteFCMToken]: Error al eliminar FCM Token", e);
    }
  }

  Future<User?> getUser() async {
    final data = await secureStorage.read(key: "user");
    if(data == null || data == "null") {
      return null;
    }

    return User.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  Future<void> setUser(User? user) async => await secureStorage.write(key: "user", value: user.toString());

  Future<Credentials?> _getCredential() async {
    final hasCredential = await _credentialsService.hasCredentials();
    final credential = await _credentialsService.getCredentials();
    if(!hasCredential || credential == null) {
      return null;
    }

    return credential;
  }
}