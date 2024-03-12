
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:mi_utem/services/update_service.dart';
import 'package:mi_utem/widgets/login_screen/background.dart';
import 'package:mi_utem/widgets/login_screen/creditos_app.dart';
import 'package:mi_utem/widgets/login_screen/formulario_credenciales.dart';
import 'package:mi_utem/widgets/login_screen/login_button.dart';
import 'package:mi_utem/widgets/login_screen/login_form.dart';
import 'package:video_player/video_player.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: Colors.black,
    body: LoginBackground(
      child: LayoutBuilder(
        builder: (context, BoxConstraints constraints) => LoginForm(
          constraints: constraints,
        ),
      ),
    ),
  );
}

