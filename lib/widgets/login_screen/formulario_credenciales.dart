import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mi_utem/controllers/auth/login_action.dart';
import 'package:mi_utem/widgets/login_screen/login_text_form_field.dart';

class FormularioCredenciales extends StatefulWidget {

  final GlobalKey<FormState> formKey;
  final TextEditingController correoController;
  final TextEditingController contraseniaController;

  const FormularioCredenciales({
    super.key,
    required this.formKey,
    required this.correoController,
    required this.contraseniaController,
  });

  @override
  State<StatefulWidget> createState() => _FormularioCredencialesState();
}

class _FormularioCredencialesState extends State<FormularioCredenciales> {

  final _passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) => AutofillGroup(
    onDisposeAction: AutofillContextAction.commit,
    child: Column(
      children: [
        LoginTextFormField(
          controller: widget.correoController,
          hintText: 'usuario@utem.cl',
          labelText: 'Usuario/Correo UTEM',
          textCapitalization: TextCapitalization.none,
          keyboardType: TextInputType.emailAddress,
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(" ")),
          ],
          icon: Icons.person,
          autofillHints: [AutofillHints.email, AutofillHints.username],
          validator: (String value) {
            if (value.isEmpty) {
              return 'Debe ingresar un correo UTEM';
            } else if (value.contains("@") && !value.endsWith("@utem.cl")) {
              return 'Debe ingresar un correo UTEM';
            }
          },
          onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
        ),
        LoginTextFormField(
          controller: widget.contraseniaController,
          hintText: '• • • • • • • • •',
          labelText: 'Contraseña',
          textCapitalization: TextCapitalization.none,
          icon: Icons.lock,
          obscureText: true,
          autofillHints: [AutofillHints.password],
          focusNode: _passwordFocusNode,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Debe ingresar una contraseña';
            }
          },
          onSubmitted: (_) => login(context: context, formKey: widget.formKey, correoController: widget.correoController, contraseniaController: widget.contraseniaController),
        ),
      ],
    ),
  );

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }
}