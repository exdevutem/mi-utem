import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String emoji;
  final String title;
  final Object? error;

  const CustomErrorWidget({
    super.key,
    this.emoji = "😕",
    this.title = "Ocurrió un error inesperado",
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(emoji,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 50,
            ),
          ),
          const SizedBox(height: 15),
          Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (error != null) ...[
            const SizedBox(height: 15),
            Text("$error",
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
