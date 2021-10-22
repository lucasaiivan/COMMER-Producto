
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app/modules/splash/bindings/splash_binding.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/dynamicTheme_lb.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp();
  HomeBinding().dependencies(); 
  await GetStorage.init();
  

  Color colorBlack =  Color.fromARGB(255,43, 45, 57);
  Color colorLight = Color.fromARGB(255, 238, 238, 238);

  runApp(
    GetMaterialApp(
      title: "Producto",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      themeMode: (GetStorage().read('isDarkMode')??false)?ThemeMode.dark:ThemeMode.light,
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor:colorLight,
        backgroundColor: Colors.grey[200],
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue),
        cardColor: Color.fromARGB(255, 19, 20,24),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),),
              backgroundColor: MaterialStateProperty.all(Colors.deepPurple,),
              padding: MaterialStateProperty.all(EdgeInsets.all(14))),
        ),
      ),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor:colorBlack,
        backgroundColor: Color.fromRGBO(59, 24, 95, 1.0),
        textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.blue),
        cardColor: Color.fromARGB(255, 19, 20,24),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),),
              backgroundColor: MaterialStateProperty.all( Colors.deepPurple,),
              padding: MaterialStateProperty.all(EdgeInsets.all(14))),
        ),
      ),
    ),
  );
}
