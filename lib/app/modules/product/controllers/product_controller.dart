import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';
import '../../mainScreen/controllers/welcome_controller.dart';

class ProductController extends GetxController {
  // controllers
  WelcomeController welcomeController = Get.find<WelcomeController>();

  static Rx<ProfileAccountModel> profileBusinessModel =
      ProfileAccountModel().obs;
  ProfileAccountModel get getProfileBusiness => profileBusinessModel.value;
  set setProfileBusiness(ProfileAccountModel model) =>
      profileBusinessModel.value = model;

  static Rx<ProductCatalogue> listSuggestedProducts = ProductCatalogue(timestampActualizacion: Timestamp.now(),timestampCreation: Timestamp.now()).obs;
  ProductCatalogue get getProduct => listSuggestedProducts.value;
  set setProduct(ProductCatalogue product) =>
      listSuggestedProducts.value = product;

  static Rx<Mark> mark = Mark(
          timestampUpdate: Timestamp.now(), timestampCreacion: Timestamp.now())
      .obs;
  Mark get getMark => mark.value;
  set setMark(Mark value) => mark.value = value;

  static Rx<Category> category = Category(id: '', nombre: '').obs;
  Category get getCategory => category.value;
  set setCategory(Category value) => category.value = value;

  static Rx<Category> subcategory = Category(id: '', nombre: '').obs;
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
  set setListPricesForProduct(List<Price> value) =>
      listPricesForProduct.value = value;

  @override
  void onInit() async {
    setProduct = Get.arguments['product']?? ProductCatalogue(timestampActualizacion: Timestamp.now(), timestampCreation: Timestamp.now());
    readCategory();
    readMarkProducts();
    readOthersProductsMark();
    readOthersProductsCategoryCatalogue();
    readListPricesForProduct();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void readCategory() {
    // aignamos los datos de la cátegoria y subcátegoria del producto
    welcomeController.getCatalogueCategoryList.forEach((element) {
      if (getProduct.categoria == element.id) {
        // set category
        setCategory = element;
        element.subcategorias.forEach((key, value) {
          if (getProduct.subcategoria == key) {
            // set subcategory
            setSubcategory = Category(id: key,nombre: value);
          }
        });
      }
    });
  }

  void readMarkProducts() {
    Database.readMarkFuture(id: getProduct.idMarca)
        .then((value) => setMark = Mark.fromMap(value.data() as Map));
  }

  void readProfileBusiness({required String id}) {
    Database.readProfileBusinessModelFuture(id).then((value) =>
        setProfileBusiness = ProfileAccountModel.fromMap(value.data() as Map));
  }

  void readOthersProductsCategoryCatalogue() {
    List<ProductCatalogue> list = [];
    welcomeController.getCataloProducts.forEach((element) {
      if (getCategory.id == element.categoria ||
          getSubcategory.id == element.subcategoria) {
        list.add(element);
      }
    });
    setListOthersProductsForCategoryCatalogue = list.cast<ProductCatalogue>();
  }

  void readOthersProductsMark() {

    //esta verificación evita que cargue productos que no tengas especificada la marca
    if( getProduct.idMarca!=''){
      Database.readProductsForMakFuture(idMark: getProduct.idMarca).then((value) {
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
