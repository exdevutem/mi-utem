import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/user_controller.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';

class MainScreenGreetings extends StatelessWidget {
  const MainScreenGreetings({
    Key? key,
  }) : super(key: key);

  String getGreetingText(String firstName) {
    List<String> texts = RemoteConfigService.greetings;

    Random random = new Random();
    String text = texts[random.nextInt(texts.length)];
    text = text.replaceAll("%name", firstName);
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Obx(
        () => MarkdownBody(
          data: getGreetingText(
            UserController.to.user.value?.primerNombre ?? "Desconocido",
          ),
          styleSheet: MarkdownStyleSheet(
            p: Get.textTheme.displayMedium!
                .copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      ),
    );
  }
}
