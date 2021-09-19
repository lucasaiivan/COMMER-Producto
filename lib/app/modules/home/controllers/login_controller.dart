import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../customFullScreenDialog.dart';
import 'home_controller.dart';

class LoginController extends GetxController {
  HomeController homeController = Get.find<HomeController>();

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void login() async {
    // visualizamos un diálogo alerta
    CustomFullScreenDialog.showDialog();

    // Activar el flujo de autenticación
    GoogleSignInAccount? googleSignInAccount =
        await homeController.googleSign.signIn();
    if (googleSignInAccount == null) {
      CustomFullScreenDialog.cancelDialog();
    } else {
      // Obtenga los detalles de autenticación de la solicitud
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      // Crea una nueva credencial
      OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken);
      // Una vez que haya iniciado sesión, devuelva el UserCredential
      await homeController.firebaseAuth.signInWithCredential(oAuthCredential);

      // finalizamos el diálogo alerta
      CustomFullScreenDialog.cancelDialog();
    }
  }
}
