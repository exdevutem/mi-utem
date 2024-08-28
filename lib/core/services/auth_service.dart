import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/preferencia.dart';
import 'package:mi_utem/core/models/user/estudiante.dart';
import 'package:mi_utem/core/repositories/secure_storage_repository.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/core/utils/http/functions.dart';
import 'package:mi_utem/screens/login_screen/login_screen.dart';
import 'package:mi_utem/services/notification_service.dart';

class AuthService {

  final SecureStorageRepository _secureStorageRepository = Get.find<SecureStorageRepository>();

  Future<bool> isFirstTime() async => (await Preferencia.lastLogin.exists()) == false;

  Future<bool> isLoggedIn() async => (await _secureStorageRepository.getEstudiante()) != null;

  Future<Estudiante> login({ bool forceRefresh = false }) async {
    final credentials = await _secureStorageRepository.getCredentials();
    if(credentials == null) {
      logger.d("[AuthService#isLoggedIn]: No se encontraron credenciales.");
      throw CustomException.custom();
    }

    Estudiante? estudiante = await _secureStorageRepository.getEstudiante();
    if (estudiante != null && !forceRefresh) {
      return estudiante;
    }

    try {
      final response = await sigaClientRequest("autenticacion/login/",
        method: 'POST',
        data: credentials.toFormUrlEncoded(),
        forceRefresh: forceRefresh,
        contentType: Headers.formUrlEncodedContentType,
      );

      if(response.statusCode != 200 || response.data['status_code'] != 200) {
        throw CustomException.custom(message: "No logramos autenticarte.");
      }

      estudiante = Estudiante.fromJson(response.data['response'] as Map<String, dynamic>);
      await _secureStorageRepository.setEstudiante(estudiante);
      await Preferencia.lastLogin.set(DateTime.now().toIso8601String());
      return estudiante;
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

  /* Obtiene un token activo, si está expirado el actual, obtiene uno nuevo */
  Future<String> activeToken() async {
    Estudiante estudiante = await login();
    if(estudiante.isTokenExpired()) {
      estudiante = await login(forceRefresh: true);
    }

    if(estudiante.isTokenExpired()) {
      throw CustomException.custom(message: "No se pudo obtener un token válido. Por favor intenta más tarde.");
    }

    return estudiante.token;
  }

  /* Obtiene un token activo, de la api de ExDev */
  Future<String> activeTokenExdev({ bool forceRefresh = false}) async {
    try {
      final credentials = await Get.find<SecureStorageRepository>().getCredentials();
      if(credentials == null) {
        throw CustomException.custom(message: 'No se han ingresado credenciales');
      }

      final authResponse = await authClientRequest('auth',
        method: 'POST',
        data: {
          'correo': credentials.username,
          'contrasenia': credentials.password,
        },
        contentType: Headers.jsonContentType,
        forceRefresh: forceRefresh,
      );

      final token = authResponse.data['token'] as String?;
      if(token == null) {
        logger.e('Error al obtener token para obtener permisos');
        throw CustomException.custom(message: 'Error al obtener permisos. Por favor intenta más tarde.');
      }

      // Validar token al realizar solicitud a carreras.
      await authClientRequest('carreras',
        headers: {
          'Authorization': 'Bearer $token'
        },
        contentType: Headers.jsonContentType,
        forceRefresh: forceRefresh,
      );

      return token;
    } on DioError catch (e) {
      logger.e('Error al autenticar para obtener permisos', [e]);
      final data = e.response?.data ?? {
        'mensaje': 'Error al obtener permisos.',
        'codigoHttp': 500,
      };

      throw CustomException.fromJson(data);
    } catch (e) {
      logger.e('Error al autenticar para obtener permisos', [e]);
      throw CustomException.custom(message: 'Error al obtener permisos. Por favor intenta más tarde.');
    }
  }

  Future<void> logout({ BuildContext? context}) async {
    await _secureStorageRepository.setEstudiante(null);
    await _secureStorageRepository.setCredentials(null);
    await Preferencia.onboardingStep.delete();

    if(context != null) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (ctx) => LoginScreen()));
    }
  }

  Future<void> saveFCMToken() async {
    final user = await _secureStorageRepository.getEstudiante();
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
      usersCollection.doc(user.rut.rut.toString()).set({
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