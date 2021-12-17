/* Este paquete gestiona el cambio de su tema durante el tiempo de ejecución y su persistencia. */

/* FUNCIONES */
/* 1 * Cambia el brillo del tema actual (oscuro/luz) */

/* Paquetes internos */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
/* Paquetes externos */
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
export 'package:animate_do/animate_do.dart';

class Themes {
  static final light = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Color.fromARGB(255, 238, 238, 238),
  );
  static final dark = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Color.fromARGB(255, 43, 45, 57),
  );
}

class ThemeService {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  /// Get isDarkMode info from local storage and return ThemeMode
  ThemeMode get theme => _loadisDArkMode() ? ThemeMode.dark : ThemeMode.light;

  /// Load isDArkMode from local storage and if it's empty, returns false (that means default theme is light)
  bool _loadisDArkMode() => _box.read(_key) ?? false;

  /// Save isDarkMode to local storage
  _saveSsDarkMode(bool isDarkMode) => _box.write(_key, isDarkMode);

  /// Switch theme and save to local storage
  void switchTheme() {
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: _loadisDArkMode()
            ? Themes.light.scaffoldBackgroundColor
            : Themes.dark.scaffoldBackgroundColor,
        statusBarColor: _loadisDArkMode()
            ? Themes.light.scaffoldBackgroundColor
            : Themes.dark.scaffoldBackgroundColor,
        statusBarBrightness: _loadisDArkMode()?Brightness.light:Brightness.dark,
        statusBarIconBrightness: _loadisDArkMode()?Brightness.light:Brightness.dark,
        systemNavigationBarIconBrightness: _loadisDArkMode()?Brightness.dark:Brightness.light,
        systemNavigationBarDividerColor: _loadisDArkMode()
            ? Themes.light.scaffoldBackgroundColor
            : Themes.dark.scaffoldBackgroundColor, 
      ));
    }
    
    Get.changeThemeMode(_loadisDArkMode() ? ThemeMode.light : ThemeMode.dark);
    _saveSsDarkMode(!_loadisDArkMode());
  }
}
