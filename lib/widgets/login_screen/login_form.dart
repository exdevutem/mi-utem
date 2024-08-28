import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/auth/login_action.dart';
import 'package:mi_utem/core/repositories/secure_storage_repository.dart';
import 'package:mi_utem/services/update_service.dart';
import 'package:mi_utem/widgets/login_screen/creditos_app.dart';
import 'package:mi_utem/widgets/login_screen/formulario_credenciales.dart';

class LoginForm extends StatefulWidget {
  final BoxConstraints constraints;

  const LoginForm({
    super.key,
    required this.constraints,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contraseniaController = TextEditingController();
  final SecureStorageRepository _secureStorageRepository = Get.find<SecureStorageRepository>();

  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    UpdateService();

    _secureStorageRepository.getCredentials().then((credential){
      if(credential == null) {
        return;
      }

      _correoController.text = credential.username;
      _contraseniaController.text = credential.password;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: ConstrainedBox(
      constraints: widget.constraints.copyWith(
        minHeight: widget.constraints.maxHeight,
        maxHeight: double.infinity,
      ),
      child: IntrinsicHeight(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: widget.constraints.maxHeight * 0.1),
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
              SizedBox(height: widget.constraints.maxHeight * 0.1),
              FormularioCredenciales(
                formKey: _formKey,
                correoController: _correoController,
                contraseniaController: _contraseniaController,
              ),
              TextButton(
                onPressed: () => login(context: context, formKey: _formKey, correoController: _correoController, contraseniaController: _contraseniaController),
                child: Text("Iniciar Sesión"),
              ),
              SizedBox(height: widget.constraints.maxHeight * 0.1),
              const CreditosApp(),
            ],
          ),
        ),
      ),
    ),
  );
}
