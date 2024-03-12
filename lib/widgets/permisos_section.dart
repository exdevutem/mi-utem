import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/controllers/qr_passes_controller.dart';
import 'package:mi_utem/models/exceptions/custom_exception.dart';
import 'package:mi_utem/models/permiso_covid.dart';
import 'package:mi_utem/services_new/interfaces/qr_pass_service.dart';
import 'package:mi_utem/widgets/loading_indicator.dart';
import 'package:mi_utem/widgets/permiso_card.dart';
import 'package:watch_it/watch_it.dart';

class PermisosCovidSection extends StatelessWidget {

  const PermisosCovidSection({
    super.key,
  });

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
        SizedBox(height: 10),
        SizedBox(
          height: 155,
          child: FutureBuilder<List<PermisoCovid>?>(
            future: di.get<QRPassService>().getPermisos(),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return LoadingIndicator(
                  message: "Esto tardará un poco, paciencia...",
                );
              }

              if(snapshot.hasError) {
                final error = snapshot.error is CustomException ? (snapshot.error as CustomException).message : "Ocurrió un error al cargar los permisos";
                return Text(error);
              }

              if(snapshot.data == null || snapshot.data?.isNotEmpty != true) {
                return Text('No hay permisos de ingresos');
              }

              return ListView.separated(
                itemCount: snapshot.data!.length,
                padding: EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => Container(width: 10),
                itemBuilder: (context, index) => PermisoCard(
                  permiso: snapshot.data![index],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
