import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mi_utem/repositories/interfaces/preferences_repository.dart';
import 'package:mi_utem/screens/main_screen.dart';
import 'package:mi_utem/screens/onboarding/notifications_screen.dart';
import 'package:mi_utem/themes/theme.dart';
import 'package:mi_utem/widgets/gradient_background.dart';

class SetAliasScreen extends StatefulWidget {
  const SetAliasScreen({super.key});

  @override
  State<SetAliasScreen> createState() => _SetAliasScreenState();
}

class _SetAliasScreenState extends State<SetAliasScreen> {

  PreferencesRepository _preferencesRepository = Get.find<PreferencesRepository>();

  final _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final _aliasController = TextEditingController();

  @override
  void initState() {
    _preferencesRepository.getOnboardingStep().then((step) {
      if(step == null) {
        _preferencesRepository.setOnboardingStep("alias");
      } else if (step == 'complete') {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const MainScreen()));
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotificationsScreen()));
      }
    });
    _preferencesRepository.getAlias().then((value) => _aliasController.text = value ?? '');
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
                Icon(Icons.tag_faces, size: 100, color: Colors.white),
                const SizedBox(height: 50),
                Column(
                  children: [
                    const Text("Comencemos con tu Apodo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text("¿Cómo quieres que te llamemos?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Form(
                      key: _formKey,
                      child: TextFormField(
                        focusNode: _focusNode,
                        controller: _aliasController,
                        decoration: InputDecoration(
                          errorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          focusedErrorBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
                          hintText: "Juanin",
                          labelText: "Apodo",
                          labelStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                          suffixIcon: _aliasController.text.isNotEmpty == true ? GestureDetector (
                            onTap: () => _aliasController.clear(),
                            behavior: HitTestBehavior.opaque,
                            child: IconButton(
                              icon: const Icon(Icons.clear, color: Colors.white),
                              onPressed: () => _aliasController.clear(),
                            ),
                          ) : null,
                        ),
                        keyboardType: TextInputType.name,
                        textCapitalization: TextCapitalization.words,
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                        autofillHints: const [AutofillHints.nickname],
                        validator: (value) {
                          final val = value?.trim() ?? "";
                          if(val.isEmpty) {
                            return "Debes ingresar un apodo.";
                          }

                          if(val.length > 24) {
                            return "El apodo es muy largo.";
                          }

                          return null;
                        },
                        onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                FilledButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() != true) {
                      return;
                    }
                    _preferencesRepository.setAlias(_aliasController.text);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationsScreen()));
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
                  child: const Text("Continuar",
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