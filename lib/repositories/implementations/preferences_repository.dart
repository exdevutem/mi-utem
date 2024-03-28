import 'package:mi_utem/config/logger.dart';
import 'package:mi_utem/config/secure_storage.dart';
import 'package:mi_utem/repositories/interfaces/preferences_repository.dart';

class PreferencesRepositoryImplementation extends PreferencesRepository {
  static const aliasKey = 'apodo';
  static const lastLoginKey = 'ultimo_login';
  static const onboardingStepKey = 'paso_onboarding';

  @override
  Future<bool> hasAlias() async => await secureStorage.containsKey(key: aliasKey);

  @override
  Future<void> setAlias(String? alias) async => await secureStorage.write(key: aliasKey, value: alias);

  @override
  Future<String?> getAlias() async => await secureStorage.read(key: aliasKey);

  @override
  Future<bool> hasLastLogin() async => await secureStorage.containsKey(key: lastLoginKey);

  @override
  Future<void> setLastLogin(DateTime? lastLogin) async => await secureStorage.write(key: lastLoginKey, value: lastLogin?.toString());

  @override
  Future<DateTime?> getLastLogin() async {
    final lastLogin = await secureStorage.read(key: lastLoginKey);
    logger.d("Last login $lastLogin");
    return lastLogin != null ? DateTime.tryParse(lastLogin) : null;
  }

  @override
  Future<bool> hasCompletedOnboarding() async => await secureStorage.containsKey(key: onboardingStepKey) && await getOnboardingStep() == 'complete';

  @override
  Future<void> setOnboardingStep(String? step) async => await secureStorage.write(key: onboardingStepKey, value: step);

  @override
  Future<String?> getOnboardingStep() async => await secureStorage.read(key: onboardingStepKey);

}