import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/config/routes.dart';
import 'package:mi_utem/models/asignatura.dart';
import 'package:mi_utem/themes/theme.dart';

class AsignaturaListTile extends StatelessWidget {

  const AsignaturaListTile({
    Key? key,
    required this.asignatura,
  }) : super(key: key);

  final Asignatura asignatura;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: 10.0,
    ),
    child: Card(
      child: InkWell(
        onTap: () => Get.toNamed('${Routes.asignatura}/${asignatura.id}'),
        child: Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                asignatura.nombre!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: MainTheme.theme.textTheme.titleMedium,
                textAlign: TextAlign.start,
              ),
              Container(height: 10),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(asignatura.codigo!),
                  Text(asignatura.tipoHora!),
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}