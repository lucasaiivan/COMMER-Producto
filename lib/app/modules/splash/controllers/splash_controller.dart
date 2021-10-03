import 'package:producto/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../home/customFullScreenDialog.dart';

class SplashController extends GetxController {
  
  var isSignIn = false.obs;
  // instancias de FirebaseAuth y GoogleSignIn
  late GoogleSignIn googleSign = GoogleSignIn();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    ever(isSignIn, handleAuthStateChanged);
    isSignIn.value = firebaseAuth.currentUser != null;
    firebaseAuth.authStateChanges().listen((event) {
      isSignIn.value = event != null;
    });

    super.onReady();
  }

  @override
  void onClose() {}

  void handleAuthStateChanged(isLoggedIn) {
    CustomFullScreenDialog.showDialog(); // visualizamos un diálogo alerta

    if (isLoggedIn) {
      Get.offAllNamed(Routes.WELCOME,arguments: {'currentUser': firebaseAuth.currentUser});
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }

    CustomFullScreenDialog.cancelDialog(); // finalizamos el diálogo alerta
  }
}
