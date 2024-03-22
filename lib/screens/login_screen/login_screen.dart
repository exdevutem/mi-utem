import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/login_screen/background.dart';
import 'package:mi_utem/widgets/login_screen/login_form.dart';

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

