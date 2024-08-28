import 'package:flutter/material.dart';
import 'package:mi_utem/core/models/preferencia.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/services/notification_service.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/gradient_background.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {

  bool _hasAllowedNotifications = false;

  @override
  void initState() {
    Preferencia.onboardingStep.set("notifications");
    NotificationService.hasAllowedNotifications().then((value) {
      if(value) {
        setState(() => _hasAllowedNotifications = value);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => GradientBackground(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                Icon(Icons.notifications_active_outlined, size: 100, color: Colors.white),
                const SizedBox(height: 50),
                Column(
                  children: [
                    Text(_hasAllowedNotifications ? "Muchas Gracias!" : "Permítenos avisarte",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text("Olvídate sobre revisar la app a cada rato, ${_hasAllowedNotifications ? "te avisaremos" : "permítenos avisarte"} cuando tus notas cambien, o existan otras novedades!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    if(!_hasAllowedNotifications) FilledButton(
                      onPressed: () async => await NotificationService.requestUserPermissionIfNecessary(context).then((value) => setState(() => _hasAllowedNotifications = value)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MainTheme.primaryDarkColor,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text("Permitir Notificaciones",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),

                const Spacer(),

                FilledButton(
                  onPressed: () async {
                    if(!context.mounted) {
                      return;
                    }
                    await Preferencia.onboardingStep.set("complete");
                    Navigator.popUntil(context, (route) => route.isFirst);
                    final alias = await Preferencia.apodo.get();
                    NotificationService.showAnnouncementNotification(
                      title: alias != null ? "¡Hola $alias! 🎉" : "¡Hola! 🎉",
                      body: '¡Te damos la bienvenida a la aplicación Mi UTEM! 🚀',
                    );
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    maximumSize: const Size(double.infinity, 60),
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(_hasAllowedNotifications ? "Finalizar" : "No Gracias, Finalizar",
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

