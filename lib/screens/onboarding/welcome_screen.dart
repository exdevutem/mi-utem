import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/repositories/interfaces/preferences_repository.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/screens/onboarding/set_alias_screen.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/gradient_background.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  PreferencesRepository _preferencesRepository = Get.find<PreferencesRepository>();

  @override
  void initState() {
    _preferencesRepository.getOnboardingStep().then((step) {
      if(step == null) {
        return;
      } else if (step == 'complete') {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MainScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const SetAliasScreen()));
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
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/launcher_icons/prod/full_icon.png"),
                      fit: BoxFit.contain,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Text("Te damos la bienvenida a Mi UTEM",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text("¡Estás a unos pasos de disfrutar las funcionalidades de Mi UTEM!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),

                const Spacer(),

                FilledButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => const SetAliasScreen())),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    maximumSize: const Size(double.infinity, 60),
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Comenzar",
                    style: TextStyle(
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

