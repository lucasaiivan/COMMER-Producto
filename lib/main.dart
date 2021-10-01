
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
      darkTheme: ThemeData.dark().copyWith(
        canvasColor: Color(0xff141A31),
        primaryColor: Color(0xff141A31),
        primaryColorDark: Color(0xff081029),
        scaffoldBackgroundColor: Color(0xff141A31),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.yellow),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),),
              backgroundColor: MaterialStateProperty.all(Colors.yellowAccent),
              padding: MaterialStateProperty.all(EdgeInsets.all(14))),
        ),
      ),
    ),
  );
}
