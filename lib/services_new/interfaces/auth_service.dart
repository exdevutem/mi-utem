import 'package:flutter/widgets.dart';
import 'package:mi_utem/models/user/user.dart';

abstract class AuthService {

  Future<bool> isFirstTime();

  Future<bool> isLoggedIn();

  Future<void> login();

  Future<void> logout(BuildContext? context);

  Future<User?> getUser();

  Future<void> setUser(User? user);

  Future<User?> updateProfilePicture(String image);

  Future<void> saveFCMToken();

  Future<void> deleteFCMToken();
}