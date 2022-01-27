import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';
import 'package:producto/app/utils/dynamicTheme_lb.dart';
import '../../mainScreen/controllers/welcome_controller.dart';

class ProductController extends GetxController {
  // controllers
  WelcomeController welcomeController = Get.find<WelcomeController>();

  static Rx<ProfileAccountModel> profileBusinessModel =
      ProfileAccountModel(creation: Timestamp.now()).obs;
  ProfileAccountModel get getProfileBusiness => profileBusinessModel.value;
  set setProfileBusiness(ProfileAccountModel model) =>
      profileBusinessModel.value = model;

  static Rx<ProductCatalogue> listSuggestedProducts =
      ProductCatalogue(upgrade: Timestamp.now(), creation: Timestamp.now()).obs;
  ProductCatalogue get getProduct => listSuggestedProducts.value;
  set setProduct(ProductCatalogue product) =>
      listSuggestedProducts.value = product;

  static Rx<Mark> mark =
      Mark(upgrade: Timestamp.now(), creation: Timestamp.now()).obs;
  Mark get getMark => mark.value;
  set setMark(Mark value) => mark.value = value;

  static Rx<Category> category = Category(id: '', name: '').obs;
  Category get getCategory => category.value;
  set setCategory(Category value) => category.value = value;

  static Rx<Category> subcategory = Category(id: '', name: '').obs;
  Category get getSubcategory => subcategory.value;
  set setSubcategory(Category value) => subcategory.value = value;

  // otros productos de la misma marca
  static RxList<Product> listOthersProductsForMark = <Product>[].obs;
  List<Product> get getListOthersProductsForMark => listOthersProductsForMark;
  set setListOthersProductsForMark(List<Product> value) =>
      listOthersProductsForMark.value = value;

  // otros productos de la misma categoria del cátalogo
  static RxList<ProductCatalogue> listOthersProductsForCategoryCatalogue =
      <ProductCatalogue>[].obs;
  List<ProductCatalogue> get getListOthersProductsForCategoryCatalogue =>
      listOthersProductsForCategoryCatalogue;
  set setListOthersProductsForCategoryCatalogue(List<ProductCatalogue> value) =>
      listOthersProductsForCategoryCatalogue.value = value;

  static RxList<Price> listPricesForProduct = <Price>[].obs;
  List<Price> get getListPricesForProduct => listPricesForProduct;
  set setListPricesForProduct(List<Price> value) {
    listPricesForProduct.value = value;
  }

  @override
  void onInit() async {
    setProduct = Get.arguments['product'] ??ProductCatalogue(upgrade: Timestamp.now(), creation: Timestamp.now());
    readCategory();
    readMarkProducts();
    readOthersProductsMark();
    readOthersProductsCategoryCatalogue();
    readListPricesForProduct();

    super.onInit();
  }

  @override
  void onReady() {

    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Get.theme.cardColor,
        statusBarColor: Get.theme.scaffoldBackgroundColor,
        statusBarBrightness: Get.theme.brightness,
        statusBarIconBrightness: Get.theme.brightness,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarDividerColor: Get.theme.cardColor,
      ));
    }

    super.onReady();
  }

  @override
  void onClose() {
    
    if (Platform.isAndroid) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Get.theme.brightness == Brightness.light
            ? ThemesDataApp.light.scaffoldBackgroundColor
            : ThemesDataApp.dark.scaffoldBackgroundColor,
        statusBarColor: Get.theme.brightness == Brightness.light
            ? ThemesDataApp.light.scaffoldBackgroundColor
            : ThemesDataApp.dark.scaffoldBackgroundColor,
        statusBarBrightness: Get.theme.brightness == Brightness.light
            ? Brightness.light
            : Brightness.dark,
        statusBarIconBrightness: Get.theme.brightness == Brightness.light
            ? Brightness.dark
            : Brightness.light,
        systemNavigationBarIconBrightness:
            Get.theme.brightness == Brightness.light
                ? Brightness.dark
                : Brightness.light,
        systemNavigationBarDividerColor:
            Get.theme.brightness == Brightness.light
                ? ThemesDataApp.light.scaffoldBackgroundColor
                : ThemesDataApp.dark.scaffoldBackgroundColor,
      ));
    }

    super.onClose();
  }

  void readCategory() {
    // aignamos los datos de la cátegoria y subcátegoria del producto
    welcomeController.getCatalogueCategoryList.forEach((element) {
      if (getProduct.category == element.id) {
        // set category
        setCategory = element;
        element.subcategories.forEach((key, value) {
          if (getProduct.subcategory == key) {
            // set subcategory
            setSubcategory = Category(id: key, name: value);
          }
        });
      }
    });
  }

  void readMarkProducts() {
    Database.readMarkFuture(id: getProduct.idMark)
        .then((value) => setMark = Mark.fromMap(value.data() as Map));
  }

  void readProfileBusiness({required String id}) {
    Database.readProfileBusinessModelFuture(id).then((value) =>
        setProfileBusiness = ProfileAccountModel.fromMap(value.data() as Map));
  }

  void readOthersProductsCategoryCatalogue() {
    List<ProductCatalogue> list = [];
    welcomeController.getCataloProducts.forEach((element) {
      if (getCategory.id == element.category ||
          getSubcategory.id == element.subcategory) {
        list.add(element);
      }
    });
    setListOthersProductsForCategoryCatalogue = list.cast<ProductCatalogue>();
  }

  void readOthersProductsMark() {
    //esta verificación evita que cargue productos que no tengas especificada la marca
    if (getProduct.idMark != '') {
      Database.readProductsForMakFuture(idMark: getProduct.idMark)
          .then((value) {
        List<Product> list = [];
        value.docs.forEach((element) {
          list.add(Product.fromMap(element.data()));
        });
        setListOthersProductsForMark = list.cast<Product>();
      });
    }
  }

  void readListPricesForProduct() {
    Database.readListPricesProductFuture(id: getProduct.id).then((value) {
      List<Price> list = [];
      value.docs.forEach((element) {
        list.add(Price.fromMap(element.data()));
      });
      setListPricesForProduct = list.cast<Price>();
    });
  }

  // navigator
  void toProductEdit() {
    Get.toNamed(Routes.PRODUCTS_EDIT, arguments: {'product': getProduct});
  }
}
