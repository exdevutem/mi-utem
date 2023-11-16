import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

import '../../config/routes.dart';
import '../../services/remote_config/remote_config.dart';

class CreditosApp extends StatelessWidget {

  String get _creditText {
    List<dynamic> texts = jsonDecode(RemoteConfigService.creditos);

    Random random = new Random();

    return texts[random.nextInt(texts.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(10),
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
                  onTap: () {
                    Get.toNamed(Routes.about);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}