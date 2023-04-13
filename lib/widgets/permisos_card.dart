import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/screens/permiso_covid_screen.dart';
import 'package:mi_utem/themes/theme.dart';

class PermisosCard extends StatelessWidget {
  const PermisosCard({Key? key, required this.permiso}) : super(key: key);

  final PermisoCovid permiso;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 175,
      child: Card(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.qr_code_2,
                        color: Colors.black,
                        size: 60.0,
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(permiso.perfil!),
                          Text(
                            permiso.motivo!,
                            style: TextStyle(
                              color: MainTheme.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            permiso.campus ?? '',
                            style: TextStyle(
                              color: Color(0xFF363636),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Color(0xFFBDBDBD), thickness: 0.3),
              Expanded(
                flex: 25,
                child: InkWell(
                  onTap: () => Get.to(
                    () => PermisoCovidScreen(
                      permiso: permiso,
                    ),
                    routeName: Routes.permiso,
                  ),
                  child: Center(
                    child: Text(
                      "Ver QR",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
