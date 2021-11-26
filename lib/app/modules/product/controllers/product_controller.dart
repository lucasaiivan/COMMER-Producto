import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/services/database.dart';
import '../../splash/controllers/splash_controller.dart';

class ProductController extends GetxController {
  SplashController homeController = Get.find<SplashController>();

  static Rx<ProfileBusinessModel> profileBusinessModel = ProfileBusinessModel().obs;
  ProfileBusinessModel get getProfileBusiness => profileBusinessModel.value;
  set setProfileBusiness(ProfileBusinessModel model) => profileBusinessModel.value = model;

  static Rx<ProductoNegocio> listSuggestedProducts = ProductoNegocio().obs;
  ProductoNegocio get getProduct => listSuggestedProducts.value;
  set setProduct(ProductoNegocio product) =>
      listSuggestedProducts.value = product;

  static Rx<Marca> mark = Marca(
          timestampActualizado: Timestamp.now(),
          timestampCreacion: Timestamp.now())
      .obs;
  Marca get getMark => mark.value;
  set setMark(Marca value) => mark.value = value;

  static Rx<Categoria> category =
      Categoria(id: '', nombre: '').obs;
  Categoria get getCategoty => category.value;
  set setCategoty(Categoria value) => category.value = value;

  static Rx<Categoria> subcategory =
      Categoria(id: '', nombre: '').obs;
  Categoria get getSubcategoty => subcategory.value;
  set setSubcategoty(Categoria value) => subcategory.value = value;

  static RxList<Producto> listOthersProductsForMark = <Producto>[].obs;
  List<Producto> get getListOthersProductsForMark => listOthersProductsForMark;
  set setListOthersProductsForMark(List<Producto> value) =>
      listOthersProductsForMark.value = value;

  static RxList<Precio> listPricesForProduct = <Precio>[].obs;
  List<Precio> get getListPricesForProduct => listPricesForProduct;
  set setListPricesForProduct(List<Precio> value) =>
      listPricesForProduct.value = value;

  @override
  void onInit() async {
    setProduct = Get.arguments['product'];
    readMarkProducts();
    readOthersProductsMark();
    readListPricesForProduct();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void readMarkProducts() {
    Database.readMarkFuture(id: getProduct.idMarca).then((value) => setMark = Marca.fromDocumentSnapshot(documentSnapshot: value));
  }
  void readProfileBusiness({required String id}) {
    Database.readProfileBusinessModelFuture(id).then((value) =>setProfileBusiness = ProfileBusinessModel.fromMap(  value.data() as Map  ) );
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
}
