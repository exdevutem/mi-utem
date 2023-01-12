import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:mi_utem/screens/asignaturas_screen.dart';
import 'package:mi_utem/screens/credencial_screen.dart';
import 'package:mi_utem/screens/horario_screen.dart';

class QuickMenuCard extends StatelessWidget {
  const QuickMenuCard({Key? key, required this.card}) : super(key: key);

  final Map<String, dynamic> card;

  Widget? get _route {
    switch (card["route"]) {
      case "/AsignaturasScreen":
        return AsignaturasScreen();
      case "/HorarioScreen":
        return HorarioScreen();
      case "/CredencialScreen":
        return CredencialScreen();
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: 150,
      child: GradientCard(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        gradient: LinearGradient(
          colors: card["degradado"]["colors"]
              .map<Color>((dynamic c) => HexColor(c.toString()))
              .toList(),
          stops: card["degradado"]["stops"]
              ?.map<double>((num s) => s.toDouble())
              .toList(),
          begin: card["degradado"]["begin"] != null
              ? Alignment(
                  card["degradado"]["begin"][0].toDouble(),
                  card["degradado"]["begin"][1].toDouble(),
                )
              : Alignment.centerLeft,
          end: card["degradado"]["end"] != null
              ? Alignment(
                  card["degradado"]["end"][0].toDouble(),
                  card["degradado"]["end"][1].toDouble(),
                )
              : Alignment.centerRight,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _route != null
                ? () {
                    //TODO: Cambiar cuando haya router
                    if (_route is HorarioScreen) {
                      Get.to(_route, binding: HorarioBinding());
                    } else {
                      Get.to(() => _route!);
                    }
                  }
                : null,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    IconData(
                      card["icono"]["codePoint"],
                      fontFamily: card["icono"]["fontFamily"],
                      fontPackage: card["icono"]["fontPackage"],
                    ),
                    color: Colors.white,
                    size: 30,
                  ),
                  Container(height: 10),
                  Text(
                    card["nombre"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Get.textTheme.headline6!.copyWith(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
