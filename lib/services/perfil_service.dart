import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mi_utem/models/rut.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/notificaciones_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilService {
  static final Dio _dio = DioMiUtemClient.authDio;

  static Future<Usuario> getLocalUsuario() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String sesion = prefs.getString("sesion");
      String nombres = prefs.getString("nombres");
      String apellidos = prefs.getString("apellidos");
      String nombre = prefs.getString("nombre");
      String fotoUrl = prefs.getString("fotoUrl");
      Rut rut = prefs.getInt("rut") != null
          ? Rut.deEntero(prefs.getInt("rut"))
          : null;
      String correo = prefs.getString("correo");

      return Usuario(
          sesion: sesion,
          nombres: nombres,
          fotoUrl: fotoUrl,
          nombre: nombre,
          apellidos: apellidos,
          rut: rut,
          correo: correo);
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Usuario> changeFoto(String imagen) async {
    String uri = "/v1/usuarios/foto";

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      dynamic data = {'imagen': imagen};

      Response response = await _dio.put(uri, data: data);

      String fotoUrl = response.data["fotoUrl"];

      prefs.setString('fotoUrl', fotoUrl);

      Usuario usuario = await getLocalUsuario();

      return usuario;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<void> deleteFcmToken() async {
    String fcmToken = await FirebaseMessaging.instance.getToken();
    CollectionReference usuariosCollection =
        FirebaseFirestore.instance.collection('usuarios');

    QuerySnapshot snapshotRepetidas = await usuariosCollection
        .where("fcmTokens", arrayContains: fcmToken)
        .get();

    for (var doc in snapshotRepetidas.docs) {
      print("uno repetido ${doc.id}");
      doc.reference.set(
        {
          "fcmTokens": FieldValue.arrayRemove([fcmToken]),
        },
        SetOptions(
          merge: true,
        ),
      );
    }
  }

  static Future<void> saveFcmToken() async {
    try {
      String fcmToken = await FirebaseMessaging.instance.getToken();
      Usuario usuario = await PerfilService.getLocalUsuario();
      CollectionReference usuariosCollection =
          FirebaseFirestore.instance.collection('usuarios');

      await PerfilService.deleteFcmToken();

      usuariosCollection.doc(usuario.rut.numero.toString()).set(
        {
          "fcmTokens": FieldValue.arrayUnion([fcmToken]),
        },
        SetOptions(
          merge: true,
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
