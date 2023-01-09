import 'package:flutter/material.dart';

import 'package:get/get.dart';

class LoginTextFormField extends StatefulWidget {
  LoginTextFormField(
      {Key? key,
      this.hintText,
      this.labelText,
      this.icon,
      this.onSaved,
      this.obscureText = false,
      this.validator,
      this.textCapitalization,
      this.keyboardType})
      : super(key: key);

  final String? hintText, labelText;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final IconData? icon;
  final Function? onSaved, validator;
  final bool obscureText;

  @override
  _LoginTextFormFieldState createState() => _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  FocusNode? _focusNode;
  TextEditingController? _controller;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode!.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        style: TextStyle(color: Colors.white),
        controller: _controller,
        textCapitalization: widget.textCapitalization!,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.white, width: 2)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Get.theme.primaryColor, width: 2)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Get.theme.primaryColor, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.red, width: 2)),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          labelStyle: TextStyle(
              color: _focusNode!.hasFocus
                  ? Get.theme.primaryColor
                  : (_error ? Get.theme.errorColor : Color(0x80FFFFFF))),
          errorStyle: TextStyle(color: Colors.red),
          hintStyle: TextStyle(color: Color(0x80FFFFFF)),
          prefixIcon: Icon(widget.icon,
              color: _focusNode!.hasFocus
                  ? Get.theme.primaryColor
                  : (_error ? Get.theme.errorColor : Colors.white)),
          hintText: widget.hintText,
          labelText: widget.labelText,
        ),
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        onSaved: (String? value) => widget.onSaved!(value),
        validator: (String? value) {
          String? errorMsg = widget.validator!(value);

          if (errorMsg != null) {
            setState(() => _error = true);
          }
          return errorMsg;
        },
      ),
    );
  }
}
