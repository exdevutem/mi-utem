import 'package:mi_utem/config/secure_storage.dart';
import 'package:mi_utem/core/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Preferencia {
  apodo,
  lastLogin,
  onboardingStep,
  isOffline(memory: true),
  ;

  final bool memory;

  /// Instancia de una preferencia
  /// Si memory es falso, entonces la preferencia se guardará en el storage, si es verdadero, se guardará en memoria
  const Preferencia({
    this.memory = false
  });

  /// Revisa si la preferencia existe
  Future<bool> exists() async {
    if(!memory) {
      return await secureStorage.containsKey(key: this.name);
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(this.name);
  }

  /// Obtiene la preferencia del storage, pero si no existe retorna el valor por defecto
  /// Si [guardar] es verdadero, entonces si no existe la preferencia, se guardará el valor por defecto
  Future<String?> get({ String? defaultValue, bool guardar = false }) async {
    if(defaultValue != null) {
      await add(defaultValue);
    }

    if(!memory) {
      return await secureStorage.read(key: this.name) ?? defaultValue;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(this.name) ?? defaultValue;
  }

  /// Obtiene la preferencia del storage, pero si no existe retorna el valor por defecto
  /// Si [guardar] es verdadero, entonces si no existe la preferencia, se guardará el valor por defecto
  /// Retorna un valor booleano
  Future<bool> getAsBool({ bool defaultValue = false, bool guardar = false }) async => await get(defaultValue: defaultValue.toString(), guardar: guardar) == "true";

  /// Obtiene la preferencia del storage, pero si no existe retorna el valor por defecto
  /// Si [guardar] es verdadero, entonces si no existe la preferencia, se guardará el valor por defecto
  /// Retorna un valor entero
  Future<num?> getAsNum({ int defaultValue = 0, bool guardar = false }) async => let<String, num?>(await get(defaultValue: defaultValue.toString(), guardar: guardar), (data) => num.tryParse(data));

  /// Guarda la preferencia en el storage
  set(String value) async {
    if(!memory) {
      await secureStorage.write(key: this.name, value: value);
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(this.name, value);
  }

  /// Guarda la preferencia en el storage solo si no existe
  /// Si la preferencia ya existe, no se guardará nada
  add(String value) async {
    if (!(await exists())) {
      await set(value);
    }
  }

  /// Elimina la preferencia del storage
  delete() async {
    if(!memory) {
      await secureStorage.delete(key: this.name);
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(this.name);
  }

}