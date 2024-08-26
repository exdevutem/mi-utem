import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/config/secure_storage.dart';
import 'package:mi_utem/models/preferencia.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/repositories/auth_repository.dart';
import 'package:mi_utem/repositories/credentials_repository.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/utils/http/http_client.dart';
import 'package:mi_utem/utils/utils.dart';

class AuthService {

  AuthRepository _authRepository = Get.find<AuthRepository>();
  CredentialsRepository _credentialsService = Get.find<CredentialsRepository>();

  Future<bool> isFirstTime() async => (await Preferencia.lastLogin.exists()) == false;

  Future<bool> isLoggedIn({ bool forceRefresh = false }) async {
    final credentials = await _getCredential();
    if(credentials == null) {
      logger.d("[AuthService#isLoggedIn]: No se encontraron credenciales.");
      return false;
    }

    final user = await getUser();
    final userToken = user?.token;
    if(user == null || userToken == null) {
      logger.d("[AuthService#isLoggedIn]: Usuario o token nulo (user?: ${user == null}, token?: ${userToken == null})");
      return false;
    }

    final now = DateTime.now();
    final lastLoginDate = let<String, DateTime?>(await Preferencia.lastLogin.get(), (String _lastLogin) => DateTime.tryParse(_lastLogin)) ?? now;
    final difference = now.difference(lastLoginDate);
    final offlineMode = (await Preferencia.isOffline.get()) == "true";
    if((difference.inMinutes < 4 && now != lastLoginDate && !forceRefresh) || offlineMode) {
      return true;
    }

    try {
      final token = await _authRepository.refresh(token: userToken, credentials: credentials);
      await setUser(user.copyWith(token: token));
      Preferencia.lastLogin.set(now.toIso8601String());
      return true;
    } catch (e) {
      logger.e("[AuthService#isLoggedIn]: Error al refrescar token", e);
    }

    return false;
  }

  Future<void> login() async {
    final credentials = await _getCredential();
    if(credentials == null) {
      return;
    }

    final user = await _authRepository.auth(credentials: credentials);

    await setUser(user);
    Preferencia.lastLogin.set(DateTime.now().toIso8601String());
  }

  Future<void> logout({BuildContext? context}) async {
    await setUser(null);
    await _credentialsService.setCredentials(null);
    await Preferencia.onboardingStep.delete();
    await Preferencia.lastLogin.delete();
    await Preferencia.apodo.delete();
    await HttpClient.clearCache();

    if(context != null) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => LoginScreen()));
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

  Future<void> saveFCMToken() async {
    final user = await this.getUser();
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
      usersCollection.doc(user.rut?.rut.toString()).set({
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

}