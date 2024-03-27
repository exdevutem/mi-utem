import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/widgets/acerca/acerca_screen.dart';

class CreditosApp extends StatelessWidget {

  const CreditosApp({
    super.key
  });

  get _creditText {
    final texts = jsonDecode(RemoteConfigService.creditos) as List<dynamic>;
    return texts[Random().nextInt(texts.length)];
  }

  @override
  Widget build(BuildContext context) => Expanded(
    child: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: SafeArea(
              child: GestureDetector(
                child: MarkdownBody(
                  selectable: false,
                  styleSheet: MarkdownStyleSheet(
                    textAlign: WrapAlignment.center,
                    p: TextStyle(color: Colors.white),
                  ),
                  data: _creditText,
                ),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (context) => AcercaScreen(),
                  fullscreenDialog: true,
                )),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}