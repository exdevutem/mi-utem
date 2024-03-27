abstract class PreferencesRepository {

  /* Revisa si el usuario tiene un alias guardado */
  Future<bool> hasAlias();

  /* Guarda el alias del usuario */
  Future<void> setAlias(String? alias);

  /* Obtiene el alias del usuario */
  Future<String?> getAlias();

  /* Revisa si el usuario tiene último inicio de sesión */
  Future<bool> hasLastLogin();

  /* Guarda el último inicio de sesión */
  Future<void> setLastLogin(DateTime? lastLogin);

  /* Obtiene el último inicio de sesión */
  Future<DateTime?> getLastLogin();

  /* Revisa si ha hecho el onboarding */
  Future<bool> hasCompletedOnboarding();

  /* Guarda el paso actual del onboarding */
  Future<void> setOnboardingStep(String? step);

  /* Obtiene el paso actual del onboarding */
  Future<String?> getOnboardingStep();

}