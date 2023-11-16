
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:mi_utem/services/update_service.dart';
import 'package:mi_utem/widgets/login_screen/creditos_app.dart';
import 'package:mi_utem/widgets/login_screen/formulario_credenciales.dart';
import 'package:mi_utem/widgets/login_screen/login_button.dart';
import 'package:video_player/video_player.dart';

part '_background.dart';

class LoginScreen extends StatefulWidget {

  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    widget._correoController.text = "";
    widget._contraseniaController.text = "";

    UpdateService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: KeyboardVisibilityBuilder(
        builder: (context, isKeyboardVisible) {
          return _Background(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(
                      minHeight: constraints.maxHeight,
                      maxHeight: double.infinity,
                    ),
                    child: IntrinsicHeight(
                      child: Form(
                        key: widget._formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(height: constraints.maxHeight * 0.1),
                            Expanded(
                              child: SafeArea(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Hero(
                                      tag: 'utemLogo',
                                      child: Image.asset('assets/images/utem_logo_color_blanco.png', width: 250),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(height: constraints.maxHeight * 0.1),
                            FormularioCredenciales(correoController: widget._correoController, contraseniaController: widget._contraseniaController),
                            LoginButton(correoController: widget._correoController, contraseniaController: widget._contraseniaController, formKey: widget._formKey),
                            Container(height: constraints.maxHeight * 0.1),
                            if (!isKeyboardVisible)
                              CreditosApp(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
