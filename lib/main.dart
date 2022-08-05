import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app/modules/splash/bindings/splash_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/dynamicTheme_lb.dart';

void main() async {

  // init
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  HomeBinding().dependencies();
  await GetStorage.init();

  bool isDark = (GetStorage().read('isDarkMode') ?? false);

  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDark
          ? ThemesDataApp.colorBlack
          : ThemesDataApp.colorLight,
      statusBarColor:isDark
          ? ThemesDataApp.colorBlack
          : ThemesDataApp.colorLight,
      statusBarBrightness:
         isDark? Brightness.dark : Brightness.light,
      statusBarIconBrightness:
         isDark? Brightness.dark : Brightness.light,
      systemNavigationBarIconBrightness:
         isDark? Brightness.light : Brightness.dark,
      systemNavigationBarDividerColor:isDark
          ?ThemesDataApp.colorBlack
          : ThemesDataApp.colorLight,
    ));
  }
  // theme data
  ThemeData themeDataLight = ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: ThemesDataApp.colorLight,
        backgroundColor: Colors.grey[200],
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue),
        cardColor: Color.fromARGB(255, 19, 20, 24),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                Colors.deepPurple,
              ),
              padding: MaterialStateProperty.all(EdgeInsets.all(14))),
        ),
      );
      ThemeData themeDataDark = ThemeData.dark().copyWith(
        useMaterial3: true,
        scaffoldBackgroundColor: ThemesDataApp.colorBlack,
        backgroundColor: Color.fromRGBO(59, 24, 95, 1.0),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue),
        cardColor: Color.fromARGB(255, 19, 20, 24),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                Colors.deepPurple,
              ),
              padding: MaterialStateProperty.all(EdgeInsets.all(14))),
        ),
      );

  runApp(
    
    // GetMaterialApp no ​​es un MaterialApp modificado, es solo un Widget preconfigurado, que tiene el MaterialApp predeterminado como elemento secundario.
    GetMaterialApp(
      title: "Producto",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      themeMode: isDark? ThemeMode.dark:ThemeMode.light,
      theme: themeDataLight,
      darkTheme:themeDataDark,
    ),
  );
}
