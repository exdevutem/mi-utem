import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../login_text_form_field.dart';

class FormularioCredenciales extends StatefulWidget {

  final TextEditingController correoController;
  final TextEditingController contraseniaController;


  FormularioCredenciales({ required this.correoController, required this.contraseniaController });

  @override
  State<StatefulWidget> createState() => _FormularioCredencialesState(correoController: correoController, contraseniaController: contraseniaController);
}

class _FormularioCredencialesState extends State<FormularioCredenciales> {

  final TextEditingController correoController;
  final TextEditingController contraseniaController;

  _FormularioCredencialesState({ required this.correoController, required this.contraseniaController });

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        children: [
          LoginTextFormField(
            controller: correoController,
            hintText: 'nombre@utem.cl',
            labelText: 'Correo UTEM',
            textCapitalization: TextCapitalization.none,
            keyboardType: TextInputType.emailAddress,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp(" ")),
            ],
            icon: Icons.person,
            autofillHints: [AutofillHints.username],
            validator: (String value) {
              if (value.isEmpty) {
                return 'Debe ingresar un correo UTEM';
              } else if (value.contains("@") &&
                  !value.endsWith("@utem.cl")) {
                return 'Debe ingresar un correo UTEM';
              }
            },
          ),
          LoginTextFormField(
            controller: contraseniaController,
            hintText: '• • • • • • • • •',
            labelText: 'Contraseña',
            textCapitalization: TextCapitalization.none,
            icon: Icons.lock,
            obscureText: true,
            autofillHints: [AutofillHints.password],
            validator: (String value) {
              if (value.isEmpty) {
                return 'Debe ingresar una contraseña';
              }
            },
          )
        ],
      ),
    );
  }
}