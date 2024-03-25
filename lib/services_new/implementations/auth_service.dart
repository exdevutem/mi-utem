import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/config/secure_storage.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/repositories/auth_repository.dart';
import 'package:mi_utem/services_new/interfaces/repositories/credentials_repository.dart';
import 'package:watch_it/watch_it.dart';

class AuthServiceImplementation implements AuthService {

  final _authRepository = di.get<AuthRepository>();
  final _credentialsService = di.get<CredentialsRepository>();

  @override
  Future<bool> isFirstTime() async => !(await secureStorage.containsKey(key: "last_login"));

  @override
  Future<bool> isLoggedIn({ bool forceRefresh = false }) async {
    final credentials = await _getCredential();
    if(credentials == null) {
      logger.d("[AuthService#isLoggedIn]: no credential");
      return false;
    }

    final user = await getUser();
    final userToken = user?.token;
    if(user == null || userToken == null) {
      logger.d("[AuthService#isLoggedIn]: user || token => false => ${user == null} || ${userToken == null}");
      return false;
    }

    final lastLogin = await secureStorage.read(key: "last_login");
    if(lastLogin == null) {
      logger.d("[AuthService#isLoggedIn]: no last login");
      return false;
    }

    final lastLoginDate = DateTime.fromMillisecondsSinceEpoch(int.parse(lastLogin));
    final now = DateTime.now();
    final difference = now.difference(lastLoginDate);
    if(difference.inMinutes < 5 && !forceRefresh) {
      return true;
    }

    try {
      final token = await _authRepository.refresh(token: userToken, credentials: credentials);

      final userJson = user.toJson();
      userJson["token"] = token;
      await setUser(User.fromJson(userJson));
      await secureStorage.write(key: "last_login", value: "${DateTime.now().millisecondsSinceEpoch}");
      return true;
    } catch (e) {
      logger.e("[AuthService#isLoggedIn]: Error al refrescar token", e);
    }

    return false;
  }

  @override
  Future<void> login() async {
    final credentials = await _getCredential();
    if(credentials == null) {
      return;
    }

    final user = await _authRepository.auth(credentials: credentials);

    await setUser(user);
    await secureStorage.write(key: "last_login", value: "${DateTime.now().millisecondsSinceEpoch}");
  }

  @override
  Future<void> logout(BuildContext? context) async {
    setUser(null);
    _credentialsService.setCredentials(null);
    
    if(context != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) => LoginScreen()));
    }
  }

  @override
  Future<User?> getUser() async {
    final data = await secureStorage.read(key: "user");
    if(data == null || data == "null") {
      return null;
    }

    return User.fromJson(jsonDecode(data) as Map<String, dynamic>);
  }

  @override
  Future<void> setUser(User? user) async => await secureStorage.write(key: "user", value: user.toString());

  Future<Credentials?> _getCredential() async {
    final hasCredential = await _credentialsService.hasCredentials();
    final credential = await _credentialsService.getCredentials();
    if(!hasCredential || credential == null) {
      return null;
    }

    return credential;
  }

  @override
  Future<User?> updateProfilePicture(String image) async {
    final user = await getUser();
    if(user == null) {
      return null;
    }

    final _fotoUrl = _authRepository.updateProfilePicture(image: image);
    final jsonUser = user.toJson();
    jsonUser["fotoUrl"] = _fotoUrl;
    await setUser(User.fromJson(jsonUser));
    return user;
  }

  @override
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

  @override
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