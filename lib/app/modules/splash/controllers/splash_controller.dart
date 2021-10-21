import 'package:producto/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../mainScreen/customFullScreenDialog.dart';

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
    // verificamos que alla un usaario autentificado
    isSignIn.value = firebaseAuth.currentUser != null;
    // escuchamos el cambio de estado de la autentifiación del usuario
    firebaseAuth.authStateChanges().listen((event) =>isSignIn.value = event != null);

    super.onReady();
  }

  @override
  void onClose() {}

// manejar el estado de autenticación
  void handleAuthStateChanged(isLoggedIn) {

    // visualizamos un diálogo alerta
    CustomFullScreenDialog.showDialog(); 
    // aquí, según el estado, redirigir al usuario a la vista correspondiente
    if (isLoggedIn) {
      Get.offAllNamed(Routes.WELCOME,arguments: {'currentUser': firebaseAuth.currentUser});
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
    // finalizamos el diálogo alerta
    CustomFullScreenDialog.cancelDialog();
  }
}
