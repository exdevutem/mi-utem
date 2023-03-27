import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

import 'package:mi_utem/services/config_service.dart';
import 'package:mi_utem/widgets/quick_menu_card.dart';

class QuickMenuSection extends StatefulWidget {
  const QuickMenuSection({Key? key}) : super(key: key);

  @override
  State<QuickMenuSection> createState() => _QuickMenuSectionState();
}

class _QuickMenuSectionState extends State<QuickMenuSection> {
  FirebaseRemoteConfig? _remoteConfig = ConfigService.config;

  @override
  initState() {
    super.initState();
  }

  List<dynamic> get _quickMenu {
    return jsonDecode(_remoteConfig!.getString(
      ConfigService.QUICK_MENU,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Acceso rápido".toUpperCase(),
            style: Get.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(height: 10),
        Container(
          height: 130,
          child: ListView.separated(
            itemCount: _quickMenu.length,
            padding: EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => Container(width: 10),
            itemBuilder: (context, index) {
              Map<String, dynamic> e = _quickMenu[index];
              return QuickMenuCard(card: e);
            },
          ),
        ),
      ],
    );
  }
}
