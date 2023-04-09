import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mi_utem/themes/theme.dart';

class BloqueDiasCard extends StatelessWidget {
  final String day;
  final double width;
  final double height;
  final bool active;
  final Color backgroundColor;

  BloqueDiasCard({
    Key? key,
    required this.day,
    required this.width,
    required this.height,
    this.active = false,
    this.backgroundColor = MainTheme.lightGrey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
      ),
      height: height,
      width: width,
      child: Column(
        children: <Widget>[
          Text(
            day.trim(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF363636),
              fontSize: 24,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}
