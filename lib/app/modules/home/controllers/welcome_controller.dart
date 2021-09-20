import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../splash/controllers/splash_controller.dart';

class WelcomeController extends GetxController {

  SplashController homeController = Get.find<SplashController>();

  late User user;


  @override
  void onInit() async {
    super.onInit();
    user = Get.arguments['currentUser'];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void logout() async {
    // aca implementamos el cierre de sesión dentro de la función logout.
    await homeController.googleSign.disconnect();
    await homeController.firebaseAuth.signOut();
  }
}
