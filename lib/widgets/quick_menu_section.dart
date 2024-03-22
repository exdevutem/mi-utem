import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/widgets/quick_menu_card.dart';

class QuickMenuSection extends StatelessWidget {
  const QuickMenuSection({Key? key}) : super(key: key);

  List<dynamic> get _quickMenu {
    return jsonDecode(RemoteConfigService.quickMenu);
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
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
