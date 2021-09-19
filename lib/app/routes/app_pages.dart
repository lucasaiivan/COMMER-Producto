import 'package:producto/app/modules/home/bindings/home_binding.dart';
import 'package:producto/app/modules/home/bindings/login_binding.dart';
import 'package:producto/app/modules/home/bindings/welcome_binding.dart';
import 'package:producto/app/modules/home/views/splash_view.dart';
import 'package:producto/app/modules/home/views/login_view.dart';
import 'package:producto/app/modules/home/views/welcome_view.dart';
import 'package:get/get.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: INITIAL,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.WELCOME,
      page: () => WelcomeView(),
      binding: WelcomeBinding(),
    ),
  ];
}
