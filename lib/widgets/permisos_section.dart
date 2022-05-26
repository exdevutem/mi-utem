import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/permiso_card.dart';

class PermisosCovidSection extends StatefulWidget {
  final List<PermisoCovid>? permisos;
  const PermisosCovidSection({
    Key? key,
    required this.permisos,
  }) : super(key: key);

  @override
  State<PermisosCovidSection> createState() => _PermisosCovidSectionState();
}

class _PermisosCovidSectionState extends State<PermisosCovidSection> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "Permisos activos".toUpperCase(),
                style: Get.textTheme.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        Container(height: 10),
        SizedBox(
          height: 155,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (widget.permisos == null) {
                return LoadingIndicator(
                  message: "Esto tardará un poco, paciencia...",
                );
              }

              if (widget.permisos!.length == 0) {
                return Text('No hay permisos de ingresos');
              }

              return ListView.separated(
                itemCount: widget.permisos!.length,
                padding: EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Container(width: 10),
                itemBuilder: (context, index) => PermisoCard(
                  permiso: widget.permisos![index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
