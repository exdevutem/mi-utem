import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mi_utem/core/utils/http/http_client.dart';
import 'package:mi_utem/services/remote_config/remote_config.dart';
import 'package:mi_utem/widgets/snackbar.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AcercaApp extends StatelessWidget {

  const AcercaApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
    future: PackageInfo.fromPlatform(),
    builder: (ctx, snapshot) {
      final data = snapshot.data;
      if(snapshot.connectionState != ConnectionState.done || data == null){
        return const SizedBox();
      }

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text("Acerca de la App",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MarkdownBody(
                selectable: false,
                styleSheet: MarkdownStyleSheet(
                  textAlign: WrapAlignment.start,
                  p: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                data: RemoteConfigService.miutemAcercaDeLaApp.replaceAll("%version", data.version)
                    .replaceAll("%compilacion", data.buildNumber == data.version ? "1" : data.buildNumber)
                    .replaceAll("%paquete", data.packageName)
                    .replaceAll("%nombre", data.appName),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await HttpClient.clearCache();

                    showTextSnackbar(context, title: 'Listo!', message: 'Se ha limpiado el cache!');
                  },
                  child: Text('Limpiar Cache'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}