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

  static Rx<ProductoNegocio> listSuggestedProducts = ProductoNegocio(timestampActualizacion: Timestamp.now(),timestampCreation: Timestamp.now()).obs;
  ProductoNegocio get getProduct => listSuggestedProducts.value;
  set setProduct(ProductoNegocio product) =>
      listSuggestedProducts.value = product;

  static Rx<Marca> mark = Marca(
          timestampUpdate: Timestamp.now(), timestampCreacion: Timestamp.now())
      .obs;
  Marca get getMark => mark.value;
  set setMark(Marca value) => mark.value = value;

  static Rx<Categoria> category = Categoria(id: '', nombre: '').obs;
  Categoria get getCategory => category.value;
  set setCategory(Categoria value) => category.value = value;

  static Rx<Categoria> subcategory = Categoria(id: '', nombre: '').obs;
  Categoria get getSubcategory => subcategory.value;
  set setSubcategory(Categoria value) => subcategory.value = value;

  // otros productos de la misma marca
  static RxList<Producto> listOthersProductsForMark = <Producto>[].obs;
  List<Producto> get getListOthersProductsForMark => listOthersProductsForMark;
  set setListOthersProductsForMark(List<Producto> value) =>
      listOthersProductsForMark.value = value;

  // otros productos de la misma categoria del cátalogo
  static RxList<ProductoNegocio> listOthersProductsForCategoryCatalogue =
      <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getListOthersProductsForCategoryCatalogue =>
      listOthersProductsForCategoryCatalogue;
  set setListOthersProductsForCategoryCatalogue(List<ProductoNegocio> value) =>
      listOthersProductsForCategoryCatalogue.value = value;

  static RxList<Precio> listPricesForProduct = <Precio>[].obs;
  List<Precio> get getListPricesForProduct => listPricesForProduct;
  set setListPricesForProduct(List<Precio> value) =>
      listPricesForProduct.value = value;

  @override
  void onInit() async {
    setProduct = Get.arguments['product'];
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
            setSubcategory = Categoria(id: key,nombre: value);
          }
        });
      }
    });
  }

  void readMarkProducts() {
    Database.readMarkFuture(id: getProduct.idMarca)
        .then((value) => setMark = Marca.fromMap(value.data() as Map));
  }

  void readProfileBusiness({required String id}) {
    Database.readProfileBusinessModelFuture(id).then((value) =>
        setProfileBusiness = ProfileAccountModel.fromMap(value.data() as Map));
  }

  void readOthersProductsCategoryCatalogue() {
    List<ProductoNegocio> list = [];
    welcomeController.getCataloProducts.forEach((element) {
      if (getCategory.id == element.categoria ||
          getSubcategory.id == element.subcategoria) {
        list.add(element);
      }
    });
    setListOthersProductsForCategoryCatalogue = list.cast<ProductoNegocio>();
  }

  void readOthersProductsMark() {
    Database.readProductsForMakFuture(idMark: getProduct.idMarca).then((value) {
      List<Producto> list = [];
      value.docs.forEach((element) {
        list.add(Producto.fromMap(element.data()));
      });
      setListOthersProductsForMark = list.cast<Producto>();
    });
  }

  void readListPricesForProduct() {
    Database.readListPricesProductFuture(id: getProduct.id).then((value) {
      List<Precio> list = [];
      value.docs.forEach((element) {
        list.add(Precio.fromMap(element.data()));
      });
      setListPricesForProduct = list.cast<Precio>();
    });
  }

  // navigator
  void toProductEdit() {
    Get.toNamed(Routes.PRODUCTS_EDIT, arguments: {'product': getProduct});
  }
}
