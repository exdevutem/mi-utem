import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/models/rut.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class PerfilService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Usuario getLocalUsuario() {
    try {
      String? token = box.read("token");
      String? nombres = box.read("nombres");
      String? apellidos = box.read("apellidos");
      String? nombre = box.read("nombre");
      String? fotoUrl = box.read("fotoUrl");
      Rut? rut = box.read("rut") != null
          ? (box.read("rut") is int
              ? Rut.deEntero(box.read("rut"))
              : Rut.deString(box.read("rut")))
          : null;
      String? correoUtem = box.read("correoUtem");
      String? correoPersonal = box.read("correoPersonal");

      return Usuario(
        token: token,
        nombres: nombres,
        fotoUrl: fotoUrl,
        nombre: nombre,
        apellidos: apellidos,
        rut: rut,
        correoUtem: correoUtem,
        correoPersonal: correoPersonal,
      );
    } catch (e) {
      print(e);
      throw e;
    }
  }

  static Future<Usuario> changeFoto(String imagen) async {
    String uri = "/v1/usuarios/foto";

    try {
      dynamic data = {'imagen': imagen};

      Response response = await _dio.put(uri, data: data);

      String fotoUrl = response.data["fotoUrl"];

      box.write('fotoUrl', fotoUrl);

      Usuario usuario = await getLocalUsuario();

      return usuario;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<void> deleteFcmToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
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
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      Usuario usuario = await PerfilService.getLocalUsuario();
      CollectionReference usuariosCollection =
          FirebaseFirestore.instance.collection('usuarios');

      await PerfilService.deleteFcmToken();

      usuariosCollection.doc(usuario.rut!.numero.toString()).set(
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
