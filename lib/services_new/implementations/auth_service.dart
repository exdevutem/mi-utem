import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mi_utem/config/constants.dart';
import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/config/secure_storage.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/user/credential.dart';
import 'package:mi_utem/models/user/user.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/services_new/interfaces/auth_service.dart';
import 'package:mi_utem/services_new/interfaces/credential_service.dart';
import 'package:watch_it/watch_it.dart';

class AuthServiceImplementation implements AuthService {

  final _credentialsService = di.get<CredentialsService>();

  @override
  Future<bool> isFirstTime() async => !(await secureStorage.containsKey(key: "last_login"));

  @override
  Future<bool> isLoggedIn() async {
    final credential = await _getCredential();
    if(credential == null) {
      return false;
    }

    // Get stored user
    final user = await getUser();
    if(user == null) {
      return false;
    }

    try {
      final response = await http.post(Uri.parse("$apiUrl/v1/auth/refresh"),
        body: credential.toString(),
        headers: {
          'Content-Type': 'application/json',
          'User-Agent': 'App/MiUTEM',
          'Authorization': 'Bearer ${user.token}',
        },
      );

      final token = jsonDecode(response.body)["token"] as String;
      final userJson = user.toJson();
      userJson["token"] = token;
      await setUser(User.fromJson(userJson));
      await secureStorage.write(key: "last_login", value: "${DateTime.now().millisecondsSinceEpoch}");
      return true;
    } catch (e) {
      logger.e("[AuthService#isLoggedIn]: $e");
    }

    return false;
  }

  @override
  Future<void> login() async {
    final credential = await _getCredential();
    if(credential == null) {
      return;
    }

    final response = await http.post(Uri.parse("$apiUrl/v1/auth"),
      body: credential.toString(),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'App/MiUTEM',
      },
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if(response.statusCode != 200) {
      if(json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    final user = User.fromJson(json);
    await setUser(user);
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
    if(data == null) {
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

    final response = await http.put(Uri.parse("$apiUrl/v1/usuarios/foto"),
      body: jsonEncode({"imagen": image}),
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'App/MiUTEM',
        'Authorization': 'Bearer ${user.token}',
      },
    );

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if(response.statusCode != 200) {
      if(json.containsKey("error")) {
        throw CustomException.fromJson(json);
      }

      throw CustomException.custom(response.reasonPhrase);
    }

    user.fotoUrl = json["fotoUrl"] as String;
    await setUser(user);

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