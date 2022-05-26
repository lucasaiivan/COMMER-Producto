import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loadany/loadany_widget.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import '../../splash/controllers/splash_controller.dart';

class WelcomeController extends GetxController {
  // controllers
  SplashController homeController = Get.find<SplashController>();

  // state update
  bool _stateUpdate = false;
  set setStateUpdate(bool value) {
    _stateUpdate = value;
    homeController.update(['AllView']);
  }

  bool get getStateUpdate => _stateUpdate;

  // app options : select items of catalogue
  bool selectItems = false;
  bool get getSelectItems => selectItems;
  set setSelectItems(bool state) {
    selectItems = state;
    defaultSelectItems();
    update(['tab']);
    update(['catalogue']);
  }

  int _itemsSelectLength = 0;
  int get getItemsSelectLength => _itemsSelectLength;
  set setItemsSelectLength(int length) {
    _itemsSelectLength = length;
  }

  // state select all
  bool _stateSelectAll = false;
  bool get getStateSelectAll => _stateSelectAll;
  set setStateSelectAll(bool state) {
    _stateSelectAll = state;
    if (state)
      selectItemsAll();
    else
      defaultSelectItems();
  }

  void defaultSelectItems() {
    _itemsSelectLength = 0;
    for (var item in getCataloProducts) {
      item.select = false;
    }
    updateSelectItemsLength();
  }

  void selectItemsAll() {
    for (var item in getCataloProducts) {
      item.select = true;
    }
    updateSelectItemsLength();
  }

  void updateSelectItemsLength() {
    setItemsSelectLength = 0;
    for (var item in getCataloProducts) {
      if (item.select) {
        setItemsSelectLength = getItemsSelectLength + 1;
      }
    }
    update(['tab']);
    update(['catalogue']);
  }

  // text tab
  String _textTab = 'Todos';
  String get getTextTab => _textTab;
  set setTextTab(String text) {
    _textTab = text;
    update(['tab']);
  }

  //  authentication account profile
  late User _userAccountAuth;
  User get getUserAccountAuth => _userAccountAuth;
  set setUserAccountAuth(User user) => _userAccountAuth = user;

  // profile of the selected account
  static RxString idAccountSelected = ''.obs;
  set setIdAccountSelected(String value) {
    idAccountSelected.value = value;
    if (value != '') {
      readProfileAccountStream(id: value);
    } else {
      // default
      setProfileAccountSelected =
          ProfileAccountModel(creation: Timestamp.now());
      setMarkSelect = Mark(upgrade: Timestamp.now(), creation: Timestamp.now());
      setCategorySelect = Category();
      setsubCategorySelect = Category();
      setCatalogueProducts = [];
    }
    // actualizamos la vista
    update(['accountUpdate']);
  }

  String get getIdAccountSelecte => idAccountSelected.value;
  Rx<ProfileAccountModel> _profileAccount =
      ProfileAccountModel(creation: Timestamp.now()).obs;
  ProfileAccountModel get getProfileAccountSelected => _profileAccount.value;
  set setProfileAccountSelected(ProfileAccountModel user) =>
      _profileAccount.value = user;
  bool getSelected({required String id}) {
    bool isSelected = false;
    for (ProfileAccountModel obj in getManagedAccountData) {
      if (obj.id == getIdAccountSelecte) {
        if (id == getIdAccountSelecte) {
          isSelected = true;
        }
      }
    }

    return isSelected;
  }

  // Cambiar de cuenta
  void accountChange({required String idAccount}) {
    // save key/values Storage
    GetStorage().write('idAccount', idAccount);
    Get.offAllNamed(Routes.WELCOME, arguments: {
      'currentUser': getUserAccountAuth,
      'idAccount': idAccount,
    });
  }

  // variable para comprobar cuando se han cargado los datos del perfil de la cuenta
  RxBool _loadDataProfileBusiness = false.obs;
  bool get loadProfileBusiness => _loadDataProfileBusiness.value;
  set setLoadProfileBusiness(bool value) =>
      _loadDataProfileBusiness.value = value;

  // catalog product list
  RxList<Product> _listSuggestedProducts = <Product>[].obs;
  List<Product> get getListSuggestedProducts => _listSuggestedProducts;
  set setListSuggestedProducts(List<Product> products) =>
      _listSuggestedProducts.value = products;

  // catalogue
  RxList<ProductCatalogue> _catalogueBusiness = <ProductCatalogue>[].obs;
  List<ProductCatalogue> get getCataloProducts => _catalogueBusiness;
  set setCatalogueProducts(List<ProductCatalogue> products) {
    _catalogueBusiness.value = products;
    catalogueFilter();
  }

  // filter catalog
  RxList<ProductCatalogue> _catalogueFilter = <ProductCatalogue>[].obs;
  List<ProductCatalogue> get getCatalogueFilter => _catalogueFilter;
  set setCatalogueFilter(List<ProductCatalogue> products) =>
      _catalogueFilter.value = products;
  void catalogueFilter() {
    List<ProductCatalogue> list = [];
    // si los filtros son nulos muestra todos los elemtos del cátalogo
    if (getMarkSelect.id == '' &&
        getCategorySelect.id == '' &&
        getsubCategorySelect.id == '') {
      list = getCataloProducts;
    }
    //filter
    if (getMarkSelect.id != '') {
      getCataloProducts.forEach((element) {
        if (getMarkSelect.id == element.idMark) {
          list.add(element);
        }
      });
    } else {
      if (getsubCategorySelect.id != '') {
        getCataloProducts.forEach((element) {
          if (getsubCategorySelect.id == element.subcategory) {
            list.add(element);
          }
        });
      } else if (getCategorySelect.id != '') {
        getCataloProducts.forEach((element) {
          if (getCategorySelect.id == element.category) {
            list.add(element);
          }
        });
      }
    }
    // set
    setCatalogueFilter = list;
    // actualiza el estado del widget 'LoadAny'
    setLoadGridCatalogueStatus = LoadStatus.normal;
    setCatalogueLoad = [];
    //  agrega los primeros 15 elementos
    for (var i = 0; i < 15; ++i) {
      // agrega de a 15 elemntos hasta completar la lista filtrada
      if (getCatalogueLoad.length < getCatalogueFilter.length) {
        getCatalogueLoad.add(getCatalogueFilter[i]);
      }
    }

    // update views
    if (getMarkSelect.id == '') {
      filterMarks(catalogueFilter: getCatalogueFilter);
    }
    update(['catalogue']);
  }

  void catalogueFilterReset() {
    // resetea los valores de los filtros para mostrar todos los productos
    setMarkSelect = Mark(upgrade: Timestamp.now(), creation: Timestamp.now());
    setCategorySelect = Category();
    setsubCategorySelect = Category();
    catalogueFilter();
    // actualiza el texto del 'TabBar'
    setTextTab = 'Todos';
    update(['tab']);
  }

  // load catalog
  List<ProductCatalogue> _catalogueLoad = <ProductCatalogue>[].obs;
  List<ProductCatalogue> get getCatalogueLoad => _catalogueLoad;
  set setCatalogueLoad(List<ProductCatalogue> products) =>
      _catalogueLoad = products;

  // variable para comprobar cuando se han cargado todos los productos del cátalogo
  RxBool _loadDataCatalogue = false.obs;
  bool get getLoadDataCatalogue => _loadDataCatalogue.value;
  set setLoadDataCatalogue(bool value) => _loadDataCatalogue.value = value;

  // variable para comprobar cuando se han cargado todos las marcas para mostrar
  RxBool _loadDataCatalogueMarks = false.obs;
  bool get getLoadDataCatalogueMarks => _loadDataCatalogueMarks.value;
  set setLoadDataCatalogueMarks(bool value) {
    _loadDataCatalogueMarks.value = value;
    update(['marks']);
  }

  //  mark selected
  Rx<Mark> _markSelect =
      Mark(upgrade: Timestamp.now(), creation: Timestamp.now()).obs;
  Mark get getMarkSelect => _markSelect.value;
  set setMarkSelect(Mark value) {
    _markSelect.value = value;
    catalogueFilter();
    // actualiza el texto del 'TabBar'
    setTextTab = _markSelect.value.name;
    update(['tab']);
  }

  //  category selected
  Rx<Category> _categorySelect = Category().obs;
  Category get getCategorySelect => _categorySelect.value;
  set setCategorySelect(Category value) {
    // default value
    setMarkSelect = Mark(upgrade: Timestamp.now(), creation: Timestamp.now());
    // set
    _subCategorySelect.value = Category();
    _categorySelect.value = value;
    catalogueFilter();
    // actualiza el texto del 'TabBar'
    setTextTab = _categorySelect.value.name;
    update(['tab']);
  }

  Future<void> categoryDelete({required String idCategory}) async =>
      await Database.refFirestoreCategory(
              idAccount: getProfileAccountSelected.id)
          .doc(idCategory)
          .delete();
  Future<void> categoryUpdate({required Category categoria}) async {
    // ref
    var documentReferencer =
        Database.refFirestoreCategory(idAccount: getProfileAccountSelected.id)
            .doc(categoria.id);
    // Actualizamos los datos
    documentReferencer
        .set(Map<String, dynamic>.from(categoria.toJson()),
            SetOptions(merge: true))
        .whenComplete(() {
      print("######################## FIREBASE updateAccount whenComplete");
    }).catchError((e) => print(
            "######################## FIREBASE updateAccount catchError: $e"));
  }

  //  subCategory selected
  Rx<Category> _subCategorySelect = Category().obs;
  Category get getsubCategorySelect => _subCategorySelect.value;
  set setsubCategorySelect(Category value) {
    // default value
    setMarkSelect = Mark(upgrade: Timestamp.now(), creation: Timestamp.now());
    // set
    _subCategorySelect.value = value;
    catalogueFilter();
    // actualiza el texto del 'TabBar'
    setTextTab = _subCategorySelect.value.name;
    update(['tab']);
  }

  // category list
  RxList<Category> _categoryList = <Category>[].obs;
  List<Category> get getCatalogueCategoryList => _categoryList;
  set setCatalogueCategoryList(List<Category> value) {
    _categoryList.value = value;
    update(['tab']);
  }

  // subcategory list selected
  RxList<Category> _subCategoryList = <Category>[].obs;
  List<Category> get getsubCatalogueCategoryList => _subCategoryList;
  set setCataloguesubCategoryList(List<Category> value) {
    _subCategoryList.value = value;
  }

  //  estado de la carga de obj en el grid del cátalogo
  Rx<LoadStatus> _loadGridCatalogueStatus = LoadStatus.normal.obs;
  LoadStatus get getLoadGridCatalogueStatus => _loadGridCatalogueStatus.value;
  set setLoadGridCatalogueStatus(LoadStatus value) {
    _loadGridCatalogueStatus.value = value;
  }

  // marks
  RxList<Mark> _marks = <Mark>[].obs;
  List<Mark> get getCatalogueMarks => _marks;
  set setCatalogueMarks(List<Mark> value) => _marks.value = value;
  void addMark({required Mark markParam}) {
    // cada ves que se agrega un obj se asegura que en la lista no alla ninguno repetido
    bool repeated = false;
    for (Mark mark in getCatalogueMarks) {
      if (mark.id == markParam.id) repeated = true;
    }
    // si 'repeated' es falso procede a agregar a la lista
    if (repeated == false) {
      _marks.add(markParam);
      setLoadDataCatalogueMarks = true;
    }
    filterMarks(catalogueFilter: getCatalogueFilter);
  }

  // marks filter
  RxList<Mark> _marksFilter = <Mark>[].obs;
  List<Mark> get getCatalogueMarksFilter => _marksFilter;
  set setCatalogueMarksFilter(List<Mark> value) => _marksFilter.value = value;

  // accounts reference identifiers
  RxList<String> _accountsReferenceIdentifiers = <String>[].obs;
  List<String> get getAccountsReferenceIdentifiers =>
      _accountsReferenceIdentifiers;
  set setAccountsReferenceIdentifiers(List<String> value) =>
      _accountsReferenceIdentifiers.value = value;

  // managed accounts data
  RxList<ProfileAccountModel> _managedAccountDataList =
      <ProfileAccountModel>[].obs;
  List<ProfileAccountModel> get getManagedAccountData =>
      _managedAccountDataList;
  set setManagedAccountData(List<ProfileAccountModel> value) =>
      _managedAccountDataList.value = value;
  void addManagedAccount({required ProfileAccountModel profileData}) {
    // default values
    _managedAccountDataList = <ProfileAccountModel>[].obs;
    // agregamos la nueva cuenta
    return _managedAccountDataList.add(profileData);
  }

  // verifica si el usuario ya creo una cuenta
  bool _isExistAccount = true;
  get getIsExistAccount {
    _isExistAccount = false;
    for (ProfileAccountModel obj in getManagedAccountData) {
      if (getUserAccountAuth.uid == obj.id) {
        _isExistAccount = false;
      }
    }
    return _isExistAccount;
  }

  @override
  void onInit() async {
    super.onInit();

    // obtenemos por parametro los datos de la cuenta de atentificación
    Map map = Get.arguments as Map;

    // verificamos y obtenemos los datos pasados por parametro
    setUserAccountAuth = map['currentUser'];
    map.containsKey('idAccount')
        ? setDataAccount(id: Get.arguments['idAccount'])
        : setDataAccount(id: '');
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void setDataAccount({required String id}) {
    // account
    setIdAccountSelected = id;

    // verificamos si el usuario ha seleccionado una cuenta
    if (getIdAccountSelecte != '') {
      readProfileAccountStream(id: getIdAccountSelecte);
    }
    // read accounts managers
    readAccountsData(idAccount: _userAccountAuth.uid);

    // cargamos los datos de la app desde la db
    readListSuggestedProductsFuture();
  }

  void logout() async {
    // aca implementamos el cierre de sesión dentro de la función logout.
    await homeController.googleSign.disconnect();
    await homeController.firebaseAuth.signOut();
  }

  // FUNCTIONS

  void toProductView({required Product porduct}) {
    Get.toNamed(Routes.PRODUCT,
        arguments: {'product': porduct.convertProductCatalogue()});
  }

  int getNumeroDeProductosDeMarca({required String id}) {
    int cantidad = 0;

    for (ProductCatalogue item in getCataloProducts) {
      if (item.idMark == id) {
        cantidad++;
      }
    }

    return cantidad;
  }

  void readProfileAccountStream({required String id}) {
    // creamos un ayente
    Database.readAccountModelStream(id).listen((event) {
      // set
      setProfileAccountSelected =
          ProfileAccountModel.fromDocumentSnapshot(documentSnapshot: event);
      setLoadProfileBusiness = true;
      // read catalogue product
      readCatalogueListProductsStream(id: getIdAccountSelecte);
      // read catalogue categories
      readListCategoryListFuture();
    }).onError((error) {
      print('######################## readProfileBursinesStreaml: ' +
          error.toString());
      setLoadProfileBusiness = false;
    });
  }

  Future<Mark> readMark({required String id}) async {
    return Database.readMarkFuture(id: id)
        .then((value) => Mark.fromMap(value.data() as Map))
        .catchError((error) =>
            Mark(upgrade: Timestamp.now(), creation: Timestamp.now()));
    
  }

  void readAccountsData({required String idAccount}) {
    // obtenemos los datos de la cuenta
    if (idAccount != '') {
      Database.readProfileAccountModelFuture(idAccount).then((value) {
        //get
        if (value.exists) {
          ProfileAccountModel profileAccount =
              ProfileAccountModel.fromDocumentSnapshot(documentSnapshot: value);
          //  agregamos los datos del perfil de la cuenta en la lista para mostrar al usuario
          if (profileAccount.id != '') {
            addManagedAccount(profileData: profileAccount);
          }
        }
      }).catchError((error) {
        print('######################## readManagedAccountsData: ' +
            error.toString());
      });
    }
  }

  void readListCategoryListFuture() {
    // obtenemos la categorias creadas por el usuario
    Database.readCategoriesQueryStream(idAccount: getProfileAccountSelected.id)
        .listen((event) {
      List<Category> list = [];
      event.docs
          .forEach((element) => list.add(Category.fromMap(element.data())));
      setCatalogueCategoryList = list;
    });
  }

  void readListSuggestedProductsFuture() {
    // obtenemos tres primeros obj(productos) desctacados para mostrarle al usuario
    Database.readProductsFavoritesFuture(limit: 4).then((value) {
      List<Product> list = [];
      value.docs
          .forEach((element) => list.add(Product.fromMap(element.data())));
      setListSuggestedProducts = list;
      update(['scanScreen']);
    });
  }

  void readCatalogueListProductsStream({required String id}) {
    // obtenemos los obj(productos) del catalogo de la cuenta del negocio
    if (id != '') {
      Database.readProductsCatalogueStream(id: id).listen((value) {
        List<ProductCatalogue> list = [];
        //  get
        value.docs.forEach(
            (element) => list.add(ProductCatalogue.fromMap(element.data())));
        //  set
        setCatalogueProducts = list;
        setCatalogueFilter = list;
        getCatalogueMoreLoad();
        _loadMarksAll(list: list);
        setLoadDataCatalogue = true;
      }).onError((error) {
        print('######################## readCatalogueListProductsStream: ' +
            error.toString());
        setLoadDataCatalogue = false;
      });
    }
  }

  // function - delete selected items
  void showDialogDeleteSelectedItems() {
    Widget widget = AlertDialog(
      title: new Text("Eliminar elementos"),
      content: new Text(
          "¿Estás seguro de que quieres quitar estos elementos de tu catálogo?"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('cancelar')),
        new TextButton(
            child: Text('si'),
            onPressed: () async {
              // procede a eliminar los elementos seleccionados
              for (var item in getCataloProducts) {
                if (item.select) {
                  Database.refFirestoreCatalogueProduct(
                          idAccount: getProfileAccountSelected.id)
                      .doc(item.id)
                      .delete();
                }
              }
              defaultSelectItems();
              update(['tab']);
              Get.back();
            }),
      ],
    );

    Get.dialog(
      widget,
    );
  }

  //  Función -  obtenemos los datos de la marca //
  // release
  // obtenemos un lista de las id de cada marca y procedemos a hacer una consulta en la db
  // y lo guardamos en las lista para mostrar al usuario
  void _loadMarksAll({required List<ProductCatalogue> list}) {
    // recorremos las lista de los productos
    // obtenemos la marca de cada producto en un nueva lista
    // y finamente la agregamos con los datos cargados para mostrar al usuario
    for (var productoNegocio in list) {
      if (!productoNegocio.idMark.isEmpty) {
        readMark(id: productoNegocio.idMark)
            .then((value) => addMark(markParam: value));
      }
    }
    if (list.length == 0) {
      setLoadDataCatalogueMarks = true;
    }
  }

  void filterMarks({required List<ProductCatalogue> catalogueFilter}) {
    // recorresmos las lista de elementos para mostras las marcas al usuario
    List<String> idList = [];
    // extraemos los ids de las marcas
    for (var product in catalogueFilter) {
      // asignamos un estado para saber si tenemos una id repetida
      bool repeated = false;
      // recorremos las lista de ids
      for (String id in idList) {
        if (id == product.idMark) repeated = true;
      }
      // si no se repite se agrega a la lista
      if (repeated == false) {
        idList.add(product.idMark);
      }
    }
    // creamos una nueva lista con las marca y los datos ya cargados
    List<Mark> markList = [];
    for (var idMark in idList) {
      for (var mark in getCatalogueMarks) {
        if (mark.id == idMark) {
          markList.add(mark);
        }
      }
    }
    // actaulizamos la vista del cátalogo para el usaurio
    setCatalogueMarksFilter = markList;
    update(['marks']);
  }

  //  Future - 'LoadAny' widget //
  // readme
  // esta función para el parametro 'onLoadMore' de nuestro widget 'LoadAny' para controlar la carga de lementos
  // primero actualizamos a un estado de 'loading', emula un carga de 3 segundos
  // mientras se ejecuta la lógica
  Future<void> getCatalogueMoreLoad() async {
    // estado de nuestro widget 'LoadAny'
    setLoadGridCatalogueStatus = LoadStatus.loading;
    update(['catalogue']);

    // creamos una nueva variable con los datos ya mostrados al usuario
    List<ProductCatalogue> listLoad = getCatalogueLoad;

    // agregamos de a 15 elmentos
    for (var i = 0; i < 15; ++i) {
      // si nuestra carga es menor a una total  sigue agregando los elementos
      if (listLoad.length < getCatalogueFilter.length) {
        listLoad.add(getCatalogueFilter[listLoad.length]);
      }
    }

    // cuando termina actualiza los datos
    setCatalogueLoad = listLoad;

    // tambien actualizamos el estado de nuestro widget 'LoadAny' para mostrar más elementos
    setLoadGridCatalogueStatus = listLoad.length < getCatalogueFilter.length
        ? LoadStatus.normal
        : LoadStatus.completed;
    update(['catalogue']);
  }

  // salir del cátalogo
  void catalogueExit() async {
    // default values
    await GetStorage().write('idAccount', '');
    setIdAccountSelected = '';
    Get.back();
  }

  // cerrar sesión
  void showDialogCerrarSesion() {
    Widget widget = AlertDialog(
      title: new Text("Cerrar sesión"),
      content: new Text("¿Estás seguro de que quieres cerrar la sesión?"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('cancelar')),
        new TextButton(
            child: Text('si'),
            onPressed: () async {
              CustomFullScreenDialog.showDialog();

              // set default
              GetStorage().write('idAccount', '');
              setIdAccountSelected = '';
              // instancias de FirebaseAuth para proceder a cerrar sesión
              final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
              Future.delayed(Duration(seconds: 2)).then((_) {
                firebaseAuth.signOut().then((value) async {
                  CustomFullScreenDialog.cancelDialog();
                });
              });
            }),
      ],
    );

    Get.dialog(
      widget,
    );
  }

  // Fuctions
  bool isCatalogue({required String id}) {
    bool iscatalogue = false;
    List list = getCataloProducts;
    list.forEach((element) {
      if (element.id == id) {
        iscatalogue = true;
      }
    });
    return iscatalogue;
  }

  ProductCatalogue getProductCatalogue({required String id}) {
    ProductCatalogue product =
        ProductCatalogue(creation: Timestamp.now(), upgrade: Timestamp.now());
    getCataloProducts.forEach((element) {
      if (element.id == id) {
        product = element;
      }
    });
    return product;
  }
}
