import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/qr_passes_controller.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/permiso_card.dart';

class PermisosCovidSection extends GetView<QrPassesController> {
  const PermisosCovidSection({
    Key? key,
  }) : super(key: key);

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
                style: Get.textTheme.titleMedium!.copyWith(
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
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return LoadingIndicator(
                  message: "Esto tardará un poco, paciencia...",
                );
              }

              if (controller.passes.length == 0) {
                return Text('No hay permisos de ingresos');
              }

              return ListView.separated(
                itemCount: controller.passes.length,
                padding: EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Container(width: 10),
                itemBuilder: (context, index) => PermisoCard(
                  permiso: controller.passes[index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
