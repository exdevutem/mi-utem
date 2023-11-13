
import 'package:flutter/material.dart';
import 'package:mi_utem/widgets/acerca/acerca_aplicacion_content.dart';
import 'package:mi_utem/widgets/acerca/club/acerca_club.dart';
import 'package:mi_utem/widgets/acerca/club/acerca_club_desarrolladores.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';

class AcercaScreen extends StatelessWidget {
  AcercaScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: CustomAppBar(
        title: Text(
          "Acerca de Mi UTEM",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AcercaClub(),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: AcercaAplicacionContent(),
              ),
              AcercaClubDesarrolladores()
            ],
          ),
        ),
      ),
    );
  }
}
