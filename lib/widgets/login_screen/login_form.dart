import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_utem/services/update_service.dart';
import 'package:mi_utem/services_new/interfaces/repositories/credentials_repository.dart';
import 'package:mi_utem/widgets/login_screen/creditos_app.dart';
import 'package:mi_utem/widgets/login_screen/formulario_credenciales.dart';
import 'package:mi_utem/widgets/login_screen/login_button.dart';
import 'package:watch_it/watch_it.dart';

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

  final _credentialService = di.get<CredentialsRepository>();

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

    _credentialService.getCredentials().then((credential){
      if(credential == null) {
        return;
      }

      _correoController.text = credential.email;
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
              Container(height: widget.constraints.maxHeight * 0.1),
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
              Container(height: widget.constraints.maxHeight * 0.1),
              FormularioCredenciales(
                correoController: _correoController,
                contraseniaController: _contraseniaController,
              ),
              LoginButton(
                correoController: _correoController,
                contraseniaController: _contraseniaController,
                formKey: _formKey,
              ),
              Container(height: widget.constraints.maxHeight * 0.1),
              const CreditosApp(),
            ],
          ),
        ),
      ),
    ),
  );
}
