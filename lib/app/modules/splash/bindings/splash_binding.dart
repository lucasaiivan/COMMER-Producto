import 'package:get/get.dart';
import 'package:producto/app/modules/splash/controllers/splash_controller.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(SplashController());
  }
}
