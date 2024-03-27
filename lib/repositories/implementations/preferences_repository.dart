import 'package:mi_utem/config/secure_storage.dart';
import 'package:mi_utem/repositories/interfaces/preferences_repository.dart';

class PreferencesRepositoryImplementation extends PreferencesRepository {

  @override
  Future<bool> hasAlias() async => await secureStorage.containsKey(key: 'alias');

  @override
  Future<void> setAlias(String? alias) async => await secureStorage.write(key: 'alias', value: alias);

  @override
  Future<String?> getAlias() async => await secureStorage.read(key: 'alias');

  @override
  Future<bool> hasLastLogin() async => await secureStorage.containsKey(key: 'last_login');

  @override
  Future<void> setLastLogin(DateTime? lastLogin) async => await secureStorage.write(key: 'last_login', value: lastLogin?.toIso8601String());

  @override
  Future<DateTime?> getLastLogin() async {
    final lastLogin = await secureStorage.read(key: 'last_login');
    return lastLogin != null ? DateTime.parse(lastLogin) : null;
  }

  @override
  Future<bool> hasCompletedOnboarding() async => await secureStorage.containsKey(key: 'onboarding_step') && await getOnboardingStep() == 'complete';

  @override
  Future<void> setOnboardingStep(String? step) async => await secureStorage.write(key: 'onboarding_step', value: step);

  @override
  Future<String?> getOnboardingStep() async => await secureStorage.read(key: 'onboarding_step');

}