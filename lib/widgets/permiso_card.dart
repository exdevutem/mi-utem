import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/screens/permiso_covid_screen.dart';
import 'package:mi_utem/themes/theme.dart';

class PermisoCard extends StatelessWidget {
  const PermisoCard({Key? key, required this.permiso}) : super(key: key);

  final PermisoCovid permiso;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 155,
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 114,
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code_2,
                    color: Colors.black,
                    size: 40,
                  ),
                  Container(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(permiso.perfil!),
                        Text(
                          permiso.motivo!,
                          style: Get.textTheme.bodyText1!.copyWith(
                            color: MainTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (permiso.campus != null)
                          Text(
                            "${permiso.campus ?? ''} (${permiso.campus!})",
                            style: Get.textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Color(0xFFBDBDBD), thickness: 0.3, height: 0.3),
            Container(
              height: 40,
              child: InkWell(
                onTap: () => Get.to(
                  () => PermisoCovidScreen(
                    permiso: permiso,
                  ),
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
    );
  }
}
