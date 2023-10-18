import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mdi/mdi.dart';
import 'package:mi_utem/config/routes/routes.dart';
import 'package:mi_utem/models/usuario.dart';
import 'package:mi_utem/services/remote_config/keys.dart';
import 'package:mi_utem/widgets/banner.dart';
import 'package:mi_utem/widgets/custom_drawer.dart';

part 'defaults.dart';

class RemoteConfigService {
  static final _firebaseRemoteConfigInstance = FirebaseRemoteConfig.instance;

  static final instance = RemoteConfigService._();

  static final defaults = _defaults;

  static String _getString(String key) =>
      _firebaseRemoteConfigInstance.getString(key);
  static bool _getBool(String key) =>
      _firebaseRemoteConfigInstance.getBool(key);
  static double _getDouble(String key) =>
      _firebaseRemoteConfigInstance.getDouble(key);
  static int _getInt(String key) => _firebaseRemoteConfigInstance.getInt(key);

  static final banners = IBanner.fromJsonList(
      jsonDecode(_getString(RemoteConfigServiceKeys.banners)));
  static final creditos = _getString(RemoteConfigServiceKeys.creditos);
  static final clubRedes = _getString(RemoteConfigServiceKeys.clubRedes);
  static final clubNombre = _getString(RemoteConfigServiceKeys.clubNombre);
  static final clubDescripcion =
      _getString(RemoteConfigServiceKeys.clubDescripcion);
  static final clubLogo = _getString(RemoteConfigServiceKeys.clubLogo);
  static final miutemDescripcion =
      _getString(RemoteConfigServiceKeys.miutemDescripcion);
  static final miutemDesarrolladores =
      _getString(RemoteConfigServiceKeys.miutemDesarrolladores);
  static final miutemPortada =
      _getString(RemoteConfigServiceKeys.miutemPortada);
  static final credencialBarras =
      _getString(RemoteConfigServiceKeys.credencialBarras);
  static final credencialDisclaimer =
      _getString(RemoteConfigServiceKeys.credencialDisclaimer);
  static final credencialInfo =
      _getString(RemoteConfigServiceKeys.credencialInfo);
  static final credencialSibutemLogo =
      _getString(RemoteConfigServiceKeys.credencialSibutemLogo);
  static final calculadoraMostrar =
      _getBool(RemoteConfigServiceKeys.calculadoraMostrar);
  static final horarioZoom = _getDouble(RemoteConfigServiceKeys.horarioZoom);
  static final homeProntoIcono =
      _getInt(RemoteConfigServiceKeys.homeProntoIcono);
  static final homeProntoTexto =
      _getString(RemoteConfigServiceKeys.homeProntoTexto);
  static final prontoEg = _getString(RemoteConfigServiceKeys.prontoEg);
  static final egHabilitados = _getBool(RemoteConfigServiceKeys.egHabilitados);
  static final drawerMenu = IDrawerItem.fromJsonList(
      jsonDecode(_getString(RemoteConfigServiceKeys.drawerMenu)));
  static final greetings =
      (jsonDecode(_getString(RemoteConfigServiceKeys.greetings))
              as List<dynamic>)
          .map((e) => e.toString())
          .toList();
  static final quickMenu = _getString(RemoteConfigServiceKeys.quickMenu);

  factory RemoteConfigService() => instance;

  RemoteConfigService._();

  static Future initialize() async {
    try {
      await _firebaseRemoteConfigInstance.setDefaults(defaults);
      await _firebaseRemoteConfigInstance.fetchAndActivate();
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }

  static Future update() async {
    try {
      await _firebaseRemoteConfigInstance.setConfigSettings(
        RemoteConfigSettings(
          minimumFetchInterval: Duration.zero,
          fetchTimeout: Duration(minutes: 1),
        ),
      );
      await _firebaseRemoteConfigInstance.fetchAndActivate();
      await _firebaseRemoteConfigInstance.setConfigSettings(
        RemoteConfigSettings(
          minimumFetchInterval: Duration(hours: 12),
          fetchTimeout: Duration(minutes: 1),
        ),
      );
    } catch (exception) {
      print(
          'Unable to fetch remote config. Cached or default values will be used');
    }
  }
}
