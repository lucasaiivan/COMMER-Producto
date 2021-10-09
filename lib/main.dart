
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app/modules/splash/bindings/splash_binding.dart';
import 'app/routes/app_pages.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  HomeBinding().dependencies(); 

  runApp(
    GetMaterialApp(
      title: "Producto",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        primaryColor: Color.fromRGBO(254, 194, 96, 1.0),
        scaffoldBackgroundColor:Colors.white,
        backgroundColor: Colors.grey[200],
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),),
              backgroundColor: MaterialStateProperty.all(Color.fromRGBO(254, 194, 96, 1.0)),
              padding: MaterialStateProperty.all(EdgeInsets.all(14))),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Color.fromRGBO(254, 194, 96, 1.0),
        scaffoldBackgroundColor:Color.fromRGBO(42, 9, 68, 1.0),
        backgroundColor: Color.fromRGBO(59, 24, 95, 1.0),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),),
              backgroundColor: MaterialStateProperty.all(Color.fromRGBO(254, 194, 96, 1.0)),
              padding: MaterialStateProperty.all(EdgeInsets.all(14))),
        ),
      ),
    ),
  );
}
