import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';
import 'package:producto/app/utils/dynamicTheme_lb.dart';
import '../../mainScreen/controllers/welcome_controller.dart';

class ProductController extends GetxController {
  // admob
  static bool _stateAds = false;
  bool get getstateAds => _stateAds;

  final Rx<BannerAd> bannerAd = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',//TODO : release: 'ca-app-pub-8441738551183357/4747810514' , test: 'ca-app-pub-3940256099942544/6300978111',
    request: AdRequest(),
    size: AdSize.banner,
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        print('################################## onAdLoaded:  $ad.');
        _stateAds = true;
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        print('################################## onAdFailedToLoad: $ad ');
        _stateAds = false;
      },
      onAdOpened: (Ad ad) {
        {
          print('################################## onAdOpened. $ad');
          _stateAds = false;
        }
      },
      onAdClosed: (Ad ad) {
        print('################################## onAdClosed.  $ad');
        _stateAds = false;
      },
      onAdWillDismissScreen: (Ad ad) {
        print('################################## onAdWillDismissScreen. $ad');
        _stateAds = false;
      },
    ),
  ).obs;

  // controllers
  static WelcomeController welcomeController = Get.find<WelcomeController>();

  static Rx<ProfileAccountModel> _profileBusinessModel =
      ProfileAccountModel(creation: Timestamp.now()).obs;
  ProfileAccountModel get getProfileBusiness => _profileBusinessModel.value;
  set setProfileBusiness(ProfileAccountModel model) =>
      _profileBusinessModel.value = model;

  static Rx<ProductCatalogue> _listSuggestedProducts = ProductCatalogue(upgrade: Timestamp.now(), creation: Timestamp.now()).obs;
  ProductCatalogue get getProduct => _listSuggestedProducts.value;
  set setProduct(ProductCatalogue product) =>
      _listSuggestedProducts.value = product;

  static Rx<Mark> _mark = Mark(upgrade: Timestamp.now(), creation: Timestamp.now()).obs;
  Mark get getMark => _mark.value;
  set setMark(Mark value) => _mark.value = value;

  static Rx<Category> _category = Category(id: '', name: '').obs;
  Category get getCategory => _category.value;
  set setCategory(Category value) => _category.value = value;

  static Rx<Category> _subcategory = Category(id: '', name: '').obs;
  Category get getSubcategory => _subcategory.value;
  set setSubcategory(Category value) => _subcategory.value = value;

  // otros productos de la misma marca
  static RxList<Product> _listOthersProductsForMark = <Product>[].obs;
  List<Product> get getListOthersProductsForMark => _listOthersProductsForMark;
  set setListOthersProductsForMark(List<Product> value) =>
      _listOthersProductsForMark.value = value;

  static RxBool _stateViewProductsMark = false.obs;
  bool get getStateViewProductsMark => _stateViewProductsMark.value;
  set setStateViewProductsMark(bool value) =>
      _stateViewProductsMark.value = value;

  // otros productos de la misma categoria del cátalogo
  static RxList<ProductCatalogue> _listOthersProductsForCategoryCatalogue = <ProductCatalogue>[].obs;
  List<ProductCatalogue> get getListOthersProductsForCategoryCatalogue =>
      _listOthersProductsForCategoryCatalogue;
  set setListOthersProductsForCategoryCatalogue(List<ProductCatalogue> value) =>
      _listOthersProductsForCategoryCatalogue.value = value;

  static RxList<Price> _listPricesForProduct = <Price>[].obs;
  List<Price> get getListPricesForProduct => _listPricesForProduct;
  set setListPricesForProduct(List<Price> value) =>_listPricesForProduct.value = value;

  static RxInt _everagePrice =  0.obs;
  int get getEveragePrice => _everagePrice.value;
  set setEveragePrice(int value) {
    _everagePrice.value = value;
  }

  @override
  void onInit() async {

    // set - values default
    setEveragePrice=0;
    _listPricesForProduct = <Price>[].obs;
    _listOthersProductsForCategoryCatalogue = <ProductCatalogue>[].obs;
    _stateViewProductsMark = false.obs;
    _mark = Mark(upgrade: Timestamp.now(), creation: Timestamp.now()).obs;
    setStateViewProductsMark = false;
    _listSuggestedProducts = ProductCatalogue(upgrade: Timestamp.now(), creation: Timestamp.now()).obs;

    // init
    initAds();
    setProduct = Get.arguments['product']??ProductCatalogue(upgrade: Timestamp.now(), creation: Timestamp.now());
    if(welcomeController.isCatalogue(id:getProduct.id)){
      //  verigicamos si esta en el cátalogo
      setProduct = welcomeController.getProductCatalogue(id: getProduct.id);
    }
    readCategory();
    readMark();
    readOthersProductsCategoryCatalogue();
    readListPricesForProduct(limit: true);
    setTheme();
    super.onInit();
  }

  @override
  void onReady() {
    setTheme();
    super.onReady();
  }

  @override
  void onClose() {
    _listOthersProductsForMark = <Product>[].obs;
   _stateAds = false;
    bannerAd.value.dispose();
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

  

// Functions
  void initAds() {
    bannerAd.value.load();
  }

  void setTheme() {
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

  void readMark() {
    Database.readMarkFuture(id: getProduct.idMark).then((value) => setMark = Mark.fromMap(value.data() as Map));
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
    setStateViewProductsMark = true;
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

  void readListPricesForProduct({bool limit = false}) {
    // devuelve una lista con los precios más actualizados del producto
    Database.readListPricesProductFuture(id: getProduct.id, limit: limit ? 9 : 25)
        .then(( value) {
          int averagePrice = 0;
          List<Price> list = [];
          value.docs.forEach((element) {
          Price price = Price.fromMap(element.data());
          list.add(price);
          averagePrice=averagePrice+price.price.toInt();
      });
          setEveragePrice= averagePrice~/list.length;
          setListPricesForProduct = list.cast<Price>();

    });
  }

  // navigator
  void toProductEdit() {
    Get.toNamed(Routes.PRODUCTS_EDIT, arguments: {'product': getProduct});
  }

}
