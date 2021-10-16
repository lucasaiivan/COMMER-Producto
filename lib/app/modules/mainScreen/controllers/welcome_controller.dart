import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:loadany/loadany_widget.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';
import '../../splash/controllers/splash_controller.dart';

class WelcomeController extends GetxController {
  SplashController homeController = Get.find<SplashController>();

  //  authentication account profile
  static late User _userAccountAuth;
  User get getUserAccountAuth => _userAccountAuth;
  set setUserAccountAuth(User user) => _userAccountAuth = user;

  //  account profile
  static Rx<UsersModel> _userAccount = UsersModel().obs;
  UsersModel get getUserAccount => _userAccount.value;
  set setUsetAccount(UsersModel user) => _userAccount.value = user;

  //  business account profile
  static Rx<ProfileBusinessModel> _businessAccount =
      ProfileBusinessModel().obs; // perfil del negocio
  ProfileBusinessModel get profileBusiness => _businessAccount.value;
  set setProfileBusiness(ProfileBusinessModel user) =>
      _businessAccount.value = user;

  // variable para comprobar cuando se han cargado los datos del perfil del usuario
  static RxBool _loadDataProfileUser = false.obs;
  bool get getLoadDataProfileUser => _loadDataProfileUser.value;
  set setLoadDataProfileUser(bool value) => _loadDataProfileUser.value = value;

  // variable para comprobar cuando se han cargado los datos del perfil de la cuenta
  static RxBool _loadDataProfileBusiness = false.obs;
  bool get loadProfileBusiness => _loadDataProfileBusiness.value;
  set setLoadProfileBusiness(bool value) =>
      _loadDataProfileBusiness.value = value;

  // Si esta variable es diferente de 'vacía' mostrará el catálogo del id de la cuenta seleccionada
  static RxString _selectBusinessId = ''.obs;
  String get getSelectBusinessId => _selectBusinessId.value;
  set setSelectBusinessId(String value) => _selectBusinessId.value = value;

  // catalog product list
  static RxList<Producto> _listSuggestedProducts = <Producto>[].obs;
  List<Producto> get getListSuggestedProducts => _listSuggestedProducts;
  set setListSuggestedProducts(List<Producto> products) =>
      _listSuggestedProducts.value = products;

  // catalogue
  static RxList<ProductoNegocio> _catalogueBusiness = <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getCatalogueBusiness => _catalogueBusiness;
  set setCatalogueBusiness(List<ProductoNegocio> products) =>
      _catalogueBusiness.value = products;

  // filter catalog
  static RxList<ProductoNegocio> _catalogueFilter = <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getCatalogueFilter => _catalogueFilter;
  set setCatalogueFilter(List<ProductoNegocio> products) =>
      _catalogueFilter.value = products;

  // load catalog
  static List<ProductoNegocio> _catalogueLoad = <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getCatalogueLoad => _catalogueLoad;
  set setCatalogueLoad(List<ProductoNegocio> products) =>
      _catalogueLoad = products;

  // variable para comprobar cuando se han cargado todos los productos del cátalogo
  static RxBool _loadDataCatalogue = false.obs;
  bool get getLoadDataCatalogue => _loadDataCatalogue.value;
  set setLoadDataCatalogue(bool value) => _loadDataCatalogue.value = value;

  // Si esta variable es diferente de 'vacía' mostrará el catálogo solo los productos de esa categoria
  static RxString _selectCategoryId = ''.obs;
  String get getSelectCategoryId => _selectCategoryId.value;
  set setSelectCategoryId(String value) => _selectCategoryId.value = value;

  // Si esta variable es diferente de 'vacía' mostrará el catálogo solo los productos de esa subcategoria
  static RxString _selectSubcategoryId = ''.obs;
  String get getSelectSubcategoryId => _selectSubcategoryId.value;
  set setSelectSubcategoryId(String value) =>
      _selectSubcategoryId.value = value;

  // Si esta variable es diferente de 'vacía' mostrará el catálogo solo los productos de esa categoría
  static RxString _selectMarkId = ''.obs;
  String get getSelectMarkId => _selectMarkId.value;
  set setSelectMarkId(String value) => _selectMarkId.value = value;

  //  account profile
  static Rx<Categoria> _categorySelect = Categoria().obs; // perfil del usuario
  Categoria get getCategorySelect => _categorySelect.value;
  set setCategorySelect(Categoria value) => _categorySelect.value = value;

  //  estado de la carga de obj en el grid del cátalogo
  Rx<LoadStatus> _loadGridCatalogueStatus = LoadStatus.normal.obs;
  LoadStatus get getLoadGridCatalogueStatus => _loadGridCatalogueStatus.value;
  set setLoadGridCatalogueStatus(LoadStatus value) =>
      _loadGridCatalogueStatus.value = value;

  // load catalog
  static RxList<Marca> _marks = <Marca>[].obs;
  List<Marca> get getCatalogueMarks => _marks;
  set setCatalogueMarks(List<Marca> value) => _marks.value = value;
  void addMark({required Marca markParam}) {
    // cada ves que se agrega un obj se asegura que en la lista no alla ninguno repetido
    bool repeated = false;
    for (Marca mark in getCatalogueMarks) {
      if (mark.id == markParam.id) repeated=true ;
    }
    // si 'repeated' es falso procede a agregar a la lista
    if(repeated==false)_marks.add(markParam);
  }

  @override
  void onInit() async {
    setUserAccountAuth = Get.arguments['currentUser'];
    if (getUserAccountAuth.uid != '')
      readProfileUserStream(id: _userAccountAuth.uid);
    readListSuggestedProductsFuture();

    super.onInit();
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

  void toProductView({required Producto porduct}) {
    Get.toNamed(Routes.PRODUCT, arguments: {'product': porduct.convertProductCatalogue()});
  }

  int getNumeroDeProductosDeMarca({required String id}) {
    int cantidad = 0;

    for (ProductoNegocio item in getCatalogueBusiness) {
      if (item.idMarca == id) {
        cantidad++;
      }
    }

    return cantidad;
  }

  void readProfileBursinesStream({required String id}) {
    // creamos un ayente
    Database.readProfileBusinessModelStream(id).listen((event) {
      setProfileBusiness =
          ProfileBusinessModel.fromDocumentSnapshot(documentSnapshot: event);
      setSelectBusinessId = profileBusiness.id;
      setLoadProfileBusiness = true;
      readCatalogueListProductsStream(id: getSelectBusinessId);
    }).onError((error) {
      print('######################## readProfileBursinesStreaml: ' +
          error.toString());
      setLoadProfileBusiness = false;
    });
  }

  Future<Marca> readMark({required String id}) async {
    return Database.readMarkFuture(id: id)
        .then((value) => Marca.fromDocumentSnapshot(documentSnapshot: value))
        .catchError((error) =>Marca(timestampActualizado: Timestamp.now(), timestampCreacion: Timestamp.now()));
  }

  void readProfileBursinesFuture({required String id}) {
    // obtenemos una sola ves el perfil de la cuenta de un negocio
    Database.readUserModelFuture(id).then((value) {
      // ignore: unused_local_variable \
      ProfileBusinessModel.fromDocumentSnapshot(documentSnapshot: value);
      /* 
      .
      ..
      ...
      */
    }).catchError((error) {
      print('######################## readProfileBursinesFuture: ' +
          error.toString());
    });
  }

  void readProfileUserStream({required String id}) {
    //  leemos el perfil de la cuenta del usuario en la db de firestore
    Database.readUserModelStream(id).listen((event) {
      setUsetAccount = UsersModel.fromDocumentSnapshot(documentSnapshot: event);
      setLoadDataProfileUser = true;
      readProfileBursinesStream(id: getUserAccount.idBusiness);
    }).onError((error) {
      print(
          '######################## readUserModelStream: ' + error.toString());
      setLoadDataProfileUser = false;
    });
  }

  void readListSuggestedProductsFuture() {
    // obtenemos tres primeros obj(productos) desctacados para mostrarle al usuario
    Database.readProductsFuture(limit: 3).then((value) {
      List<Producto> list = [];
      value.docs
          .forEach((element) => list.add(Producto.fromMap(element.data())));
      setListSuggestedProducts = list;
    });
  }

  void readCatalogueListProductsStream({required String id}) {
    // obtenemos los obj(productos) del catalogo de la cuenta del negocio
    Database.readProductsCatalogueStream(id: id).listen((value) {
      List<ProductoNegocio> list = [];
      value.docs.forEach(
          (element) => list.add(ProductoNegocio.fromMap(element.data())));
      setCatalogueBusiness = list;
      setCatalogueFilter = list;
      getCatalogueMoreLoad();
      _updateMarks(list: list);
      setLoadDataCatalogue = true;
    }).onError((error) {
      print('######################## readCatalogueListProductsStream: ' +
          error.toString());
      setLoadDataProfileUser = false;
    });
  }

  //  Función -  obtenemos los datos de la marca //
  // release
  // obtenemos un lista de las id de cada marca y procedemos a hacer una consulta en la db
  // y lo guardamos en las lista para mostrar al usuario
  void _updateMarks({required List<ProductoNegocio> list}) {
    // recorremos las lista de los productos
    // obtenemos de la db los datos de la marca
    // y finamente la agregamos con los datos cargados para mostrar al usuario

    for (var productoNegocio in list) {
      if (productoNegocio.idMarca != '')
        readMark(id: productoNegocio.idMarca)
            .then((value) => addMark(markParam: value));
    }
  }

  //  Future - 'LoadAny' widget //
  // readme
  // esta función para el parametro 'onLoadMore' de nuestro widget 'LoadAny' para controlar la carga de lementos
  // primero actualizamos a un estado de 'loading', emula un carga de 3 segundos
  // mientras se ejecuta la lógica
  Future<void> getCatalogueMoreLoad() async {
    // estado de nuestro widget 'LoadAny'
    setLoadGridCatalogueStatus = LoadStatus.loading;
    // duración por defecto de la carga de datos
    Timer.periodic(Duration(milliseconds: 2000), (Timer timer) {
      timer.cancel();
      List<ProductoNegocio> listLoad = getCatalogueLoad;

      for (var i = 0; i < 15; ++i) {
        // si nuestra carga es menor a una total  sigue agregando los elementos
        if (listLoad.length < getCatalogueFilter.length) {
          listLoad.add(getCatalogueFilter[listLoad.length + i]);
        }
      }

      // cuando termina actualiza los datos
      setCatalogueLoad = listLoad;

      // tambien actualizamos el estado de nuestro widget 'LoadAny' para mostrar más elementos
      setLoadGridCatalogueStatus = listLoad.length >= getCatalogueFilter.length
          ? LoadStatus.completed
          : LoadStatus.normal;
    });
  }
}
