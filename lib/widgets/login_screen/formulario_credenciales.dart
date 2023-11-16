import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../login_text_form_field.dart';

class FormularioCredenciales extends StatefulWidget {

  final TextEditingController _correoController;
  final TextEditingController _contraseniaController;


  FormularioCredenciales({ required TextEditingController correoController, required TextEditingController contraseniaController }) : _contraseniaController = contraseniaController, _correoController = correoController;

  @override
  State<StatefulWidget> createState() => _FormularioCredencialesState();
}

class _FormularioCredencialesState extends State<FormularioCredenciales> {

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Column(
        children: [
          LoginTextFormField(
            controller: widget._correoController,
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
            controller: widget._contraseniaController,
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