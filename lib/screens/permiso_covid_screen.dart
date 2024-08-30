import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/core/models/exceptions/custom_exception.dart';
import 'package:mi_utem/core/models/permiso_ingreso.dart';
import 'package:mi_utem/core/services/permisos_service.dart';
import 'package:mi_utem/core/utils/constants.dart';
import 'package:mi_utem/widgets/custom_app_bar.dart';
import 'package:mi_utem/widgets/custom_error_widget.dart';
import 'package:mi_utem/widgets/loading/loading_indicator.dart';
import 'package:mi_utem/widgets/permiso_ingreso/qr_card.dart';
import 'package:mi_utem/widgets/pull_to_refresh.dart';

class PermisoCovidScreen extends StatefulWidget {
  final String passId;

  const PermisoCovidScreen({
    super.key,
    required this.passId,
  });

  @override
  State<PermisoCovidScreen> createState() => _PermisoCovidScreenState();
}

class _PermisoCovidScreenState extends State<PermisoCovidScreen> {

  final PermisosService _permisosService = Get.find<PermisosService>();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: CustomAppBar(title: Text("Permiso de ingreso")),
    body: SafeArea(child: PullToRefresh(
      onRefresh: () async {
        await _permisosService.getDetallesPermiso(widget.passId, forceRefresh: true);
        setState(() {});
      },
      child: FutureBuilder<PermisoIngreso>(
        future: _permisosService.getDetallesPermiso(widget.passId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final error = snapshot.error is CustomException ? (snapshot.error as CustomException).message : "No sabemos lo que ocurrió. Por favor intenta más tarde.";
            logger.e("Error al cargar permiso", snapshot.error);
            return CustomErrorWidget(error: error);
          }

          final permiso = snapshot.data;
          if(!snapshot.hasData) {
            return LoadingIndicator.centeredDefault();
          }

          if(permiso == null) {
            return const CustomErrorWidget(
              title: "Permiso no encontrado",
              error: "Lo sentimos, no pudimos encontrar el permiso de ingreso. Por favor intenta más tarde.",
              emoji: "\u{1F914}",
            );
          }

          return SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: QRCard(permiso: permiso),
          );
        },
      ),
    )),
  );
}
