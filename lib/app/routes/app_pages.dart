
import 'package:producto/app/modules/account/bindings/account_binding.dart';
import 'package:producto/app/modules/account/views/account_view.dart';
import 'package:producto/app/modules/auth/bindings/login_binding.dart';
import 'package:producto/app/modules/auth/views/login_view.dart';
import 'package:producto/app/modules/product/bindings/product_binding.dart';
import 'package:producto/app/modules/product/views/product_view.dart';
import 'package:producto/app/modules/product/views/productsSearch_view.dart';
import 'package:producto/app/modules/splash/bindings/splash_binding.dart';
import 'package:producto/app/modules/mainScreen/bindings/welcome_binding.dart';
import 'package:producto/app/modules/mainScreen/views/mainScreen_view.dart';
import 'package:get/get.dart';
import 'package:producto/app/modules/splash/views/splash_view.dart';

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
      page: () => SplashInit(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: Routes.WELCOME,
      page: () => PagePrincipal(),
      binding: WelcomeBinding(),
    ),
    GetPage(
      name: Routes.PRODUCT,
      page: () => Product(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: Routes.ACCOUNT,
      page: () => AccountView(),
      binding: AccountBinding(),
    ),
    GetPage(
      name: Routes.PRODUCTS_SEARCH,
      page: () => WidgetProductsSearch(),
      binding: ProductsSarchBinding(),
    ),
  ];
}
