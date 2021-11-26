
import 'package:get/get.dart';
import 'package:producto/app/modules/product/controllers/product_controller.dart';
import 'package:producto/app/modules/product/controllers/productsSearch_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductController>(ProductController());
  }
}

class ProductsSarchBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ControllerProductsSearch>(ControllerProductsSearch());
  }
}