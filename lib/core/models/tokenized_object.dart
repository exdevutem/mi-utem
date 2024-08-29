import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

mixin TokenizedObject {

  String get token;

  JWT? decodeToken() => JWT.tryDecode(token);

  bool isTokenExpired() {
    final exp = decodeToken()?.payload['exp'];
    if(exp == null) {
      return true;
    }

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= exp;
  }
}