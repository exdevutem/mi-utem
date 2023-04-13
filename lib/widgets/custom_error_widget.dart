import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final Object? error;

  CustomErrorWidget({
    Key? key,
    this.emoji = "😕",
    this.title = "Ocurrió un error inesperado",
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            emoji,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50,
            ),
          ),
          Container(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (error != null) ...[
            Container(height: 15),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
