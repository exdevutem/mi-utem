import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/utils/dio_miutem_client.dart';

class PerfilService {
  static final Dio _dio = DioMiUtemClient.authDio;
  static final GetStorage box = GetStorage();

  static Future<Usuario?> changeFoto(String imagen) async {
    String uri = "/v1/usuarios/foto";

    try {
      dynamic data = {'imagen': imagen};

      Response response = await _dio.put(uri, data: data);

      String fotoUrl = response.data["fotoUrl"];

      box.write('fotoUrl', fotoUrl);

      return UserController.to.user.value;
    } on DioError catch (e) {
      print(e.message);
      throw e;
    }
  }

  static Future<void> deleteFcmToken() async {
    String? fcmToken = await NotificationService.fcm.requestFirebaseAppToken();
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
      String? fcmToken =
          await NotificationService.fcm.requestFirebaseAppToken();
      Usuario? usuario = UserController.to.user.value;
      CollectionReference usuariosCollection =
          FirebaseFirestore.instance.collection('usuarios');

      await PerfilService.deleteFcmToken();

      usuariosCollection.doc(usuario!.rut!.numero.toString()).set(
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
