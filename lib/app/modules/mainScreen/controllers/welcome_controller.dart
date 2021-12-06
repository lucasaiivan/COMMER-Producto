import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loadany/loadany_widget.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import '../../splash/controllers/splash_controller.dart';

class WelcomeController extends GetxController {
  SplashController homeController = Get.find<SplashController>();

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

  //  account profile
  Rx<UsersModel> _userAccount = UsersModel().obs;
  UsersModel get getUserAccount => _userAccount.value;
  set setUsetAccount(UsersModel user) => _userAccount.value = user;

  // profile of the selected account
  RxString idAccountSelected = ''.obs;
  set setIdAccountSelected(String value) {
    idAccountSelected.value = value;
    if (value != '') {
      readProfileAccountStream(id: value);
    }
    // actualizamos la vista
    update(['accountUpdate']);
  }

  String get getIdAccountSelecte => idAccountSelected.value;
  Rx<ProfileBusinessModel> _profileAccount = ProfileBusinessModel().obs;
  ProfileBusinessModel get getProfileAccountSelected => _profileAccount.value;
  set setProfileAccountSelected(ProfileBusinessModel user) =>
      _profileAccount.value = user;
  bool getSelected({required String id}) {
    bool isSelected = false;
    for (ProfileBusinessModel obj in getManagedAccountData) {
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

  // variable para comprobar cuando se han cargado los datos del perfil del usuario
  RxBool _loadDataProfileUser = false.obs;
  bool get getLoadDataProfileUser => _loadDataProfileUser.value;
  set setLoadDataProfileUser(bool value) => _loadDataProfileUser.value = value;

  // variable para comprobar cuando se han cargado los datos del perfil de la cuenta
  RxBool _loadDataProfileBusiness = false.obs;
  bool get loadProfileBusiness => _loadDataProfileBusiness.value;
  set setLoadProfileBusiness(bool value) =>
      _loadDataProfileBusiness.value = value;

  // catalog product list
  RxList<Producto> _listSuggestedProducts = <Producto>[].obs;
  List<Producto> get getListSuggestedProducts => _listSuggestedProducts;
  set setListSuggestedProducts(List<Producto> products) =>
      _listSuggestedProducts.value = products;

  // catalogue
  RxList<ProductoNegocio> _catalogueBusiness = <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getCataloProducts => _catalogueBusiness;
  set setCatalogueProducts(List<ProductoNegocio> products) {
    _catalogueBusiness.value = products;
    catalogueFilter();
  }

  // filter catalog
  RxList<ProductoNegocio> _catalogueFilter = <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getCatalogueFilter => _catalogueFilter;
  set setCatalogueFilter(List<ProductoNegocio> products) =>
      _catalogueFilter.value = products;
  void catalogueFilter() {
    List<ProductoNegocio> list = [];
    // si los filtros son nulos muestra todos los elemtos del cátalogo
    if (getMarkSelect.id == '' &&
        getCategorySelect.id == '' &&
        getsubCategorySelect.id == '') {
      list = getCataloProducts;
    }
    //filter
    if (getMarkSelect.id != '') {
      getCataloProducts.forEach((element) {
        if (getMarkSelect.id == element.idMarca) {
          list.add(element);
        }
      });
    } else {
      if (getsubCategorySelect.id != '') {
        getCataloProducts.forEach((element) {
          if (getsubCategorySelect.id == element.subcategoria) {
            list.add(element);
          }
        });
      } else if (getCategorySelect.id != '') {
        getCataloProducts.forEach((element) {
          if (getCategorySelect.id == element.categoria) {
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
    setMarkSelect = Marca(
        timestampActualizado: Timestamp.now(),
        timestampCreacion: Timestamp.now());
    setCategorySelect = Categoria();
    setsubCategorySelect = Categoria();
    catalogueFilter();
    // actualiza el texto del 'TabBar'
    setTextTab = 'Todos';
    update(['tab']);
  }

  // load catalog
  List<ProductoNegocio> _catalogueLoad = <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getCatalogueLoad => _catalogueLoad;
  set setCatalogueLoad(List<ProductoNegocio> products) =>
      _catalogueLoad = products;

  // variable para comprobar cuando se han cargado todos los productos del cátalogo
  RxBool _loadDataCatalogue = false.obs;
  bool get getLoadDataCatalogue => _loadDataCatalogue.value;
  set setLoadDataCatalogue(bool value) => _loadDataCatalogue.value = value;

  // variable para comprobar cuando se han cargado todos las marcas para mostrar
  RxBool _loadDataCatalogueMarks = false.obs;
  bool get getLoadDataCatalogueMarks => _loadDataCatalogueMarks.value;
  set setLoadDataCatalogueMarks(bool value) =>
      _loadDataCatalogueMarks.value = value;

  //  mark selected
  Rx<Marca> _markSelect = Marca(
          timestampActualizado: Timestamp.now(),
          timestampCreacion: Timestamp.now())
      .obs;
  Marca get getMarkSelect => _markSelect.value;
  set setMarkSelect(Marca value) {
    _markSelect.value = value;
    catalogueFilter();
    // actualiza el texto del 'TabBar'
    setTextTab = _markSelect.value.titulo;
    update(['tab']);
  }

  //  category selected
  Rx<Categoria> _categorySelect = Categoria().obs;
  Categoria get getCategorySelect => _categorySelect.value;
  set setCategorySelect(Categoria value) {
    // default value
    setMarkSelect = Marca(
        timestampActualizado: Timestamp.now(),
        timestampCreacion: Timestamp.now());
    // set
    _categorySelect.value = value;
    catalogueFilter();
    // actualiza el texto del 'TabBar'
    setTextTab = _categorySelect.value.nombre;
    update(['tab']);
  }
  Future<void> categoryDelete({required String idCategory}) async => await Database.refFirestoreCategory(idAccount:getProfileAccountSelected.id).doc(idCategory).delete();
  Future<void> categoryUpdate({required Categoria categoria}) async{
    // ref
    var documentReferencer = Database.refFirestoreCategory(idAccount:getProfileAccountSelected.id).doc(categoria.id);
    // Actualizamos los datos
    documentReferencer.set(Map<String, dynamic>.from(categoria.toJson()), SetOptions(merge: true))
        .whenComplete(() {print("######################## FIREBASE updateAccount whenComplete");
    }).catchError((e) => print("######################## FIREBASE updateAccount catchError: $e"));
  }
  
  //  subCategory selected
  Rx<Categoria> _subCategorySelect = Categoria().obs;
  Categoria get getsubCategorySelect => _subCategorySelect.value;
  set setsubCategorySelect(Categoria value) {
    // default value
    setMarkSelect = Marca(
        timestampActualizado: Timestamp.now(),
        timestampCreacion: Timestamp.now());
    // set
    _subCategorySelect.value = value;
    catalogueFilter();
    // actualiza el texto del 'TabBar'
    setTextTab = _subCategorySelect.value.nombre;
    update(['tab']);
  }

  // category list
  RxList<Categoria> _categoryList = <Categoria>[].obs;
  List<Categoria> get getCatalogueCategoryList => _categoryList;
  set setCatalogueCategoryList(List<Categoria> value) {
    _categoryList.value = value;
  }

  // subcategory list selected
  RxList<Categoria> _subCategoryList = <Categoria>[].obs;
  List<Categoria> get getsubCatalogueCategoryList => _subCategoryList;
  set setCataloguesubCategoryList(List<Categoria> value) {
    _subCategoryList.value = value;
  }

  //  estado de la carga de obj en el grid del cátalogo
  Rx<LoadStatus> _loadGridCatalogueStatus = LoadStatus.normal.obs;
  LoadStatus get getLoadGridCatalogueStatus => _loadGridCatalogueStatus.value;
  set setLoadGridCatalogueStatus(LoadStatus value) {
    _loadGridCatalogueStatus.value = value;
  }

  // marks
  RxList<Marca> _marks = <Marca>[].obs;
  List<Marca> get getCatalogueMarks => _marks;
  set setCatalogueMarks(List<Marca> value) => _marks.value = value;
  void addMark({required Marca markParam}) {
    // cada ves que se agrega un obj se asegura que en la lista no alla ninguno repetido
    bool repeated = false;
    for (Marca mark in getCatalogueMarks) {
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
  RxList<Marca> _marksFilter = <Marca>[].obs;
  List<Marca> get getCatalogueMarksFilter => _marksFilter;
  set setCatalogueMarksFilter(List<Marca> value) => _marksFilter.value = value;

  // accounts reference identifiers
  RxList<String> _accountsReferenceIdentifiers = <String>[].obs;
  List<String> get getAccountsReferenceIdentifiers =>
      _accountsReferenceIdentifiers;
  set setAccountsReferenceIdentifiers(List<String> value) =>
      _accountsReferenceIdentifiers.value = value;

  // managed accounts data
  RxList<ProfileBusinessModel> _managedAccountDataList =
      <ProfileBusinessModel>[].obs;
  List<ProfileBusinessModel> get getManagedAccountData =>
      _managedAccountDataList;
  set setManagedAccountData(List<ProfileBusinessModel> value) =>
      _managedAccountDataList.value = value;
  void addManagedAccount(
      {required ProfileBusinessModel profileData,
      required AdminUsuarioCuenta adminUsuarioCuentaData}) {
    switch (adminUsuarioCuentaData.tipocuenta) {
      case 0:
        break;
      case 1:
        profileData.admin = 'Administrador';
        break;
      case 2:
        profileData.admin = 'Estandar';
        break;
    }
    return _managedAccountDataList.add(profileData);
  }

  // verifica si el usuario ya creo una cuenta
  bool _isExistAccount = true;
  get getIsExistAccount {
    _isExistAccount = false;
    for (ProfileBusinessModel obj in getManagedAccountData) {
      if (getUserAccountAuth.uid == obj.id) {
        _isExistAccount = false;
      }
    }
    return _isExistAccount;
  }

  @override
  void onInit() async {
    // obtenemos por parametro los datos de la cuenta de atentificaión
    setUserAccountAuth = Get.arguments['currentUser'];
    try {
      setIdAccountSelected = Get.arguments['idAccount'];
    } catch (e) {
      setIdAccountSelected = '';
    }

    // cargamos los datos de la cuenta de autentificación
    if (getUserAccountAuth.uid != '') {
      readProfileUserStream(id: _userAccountAuth.uid);
      readManagedAccountsReference(idUser: _userAccountAuth.uid);
    }
    // verificamos si recibimos id de cuenta por parametro
    if (getIdAccountSelecte != '') {
      readProfileAccountStream(id: getIdAccountSelecte);
    }
    // verificamos que el usuario ha seleccionado una cuenta
    /* if (getIdAccountSelecte != '') {
      readProfileAccountStream(id: getIdAccountSelecte);
    } */
    // cargamos los datos de la app desde la db
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
    Get.toNamed(Routes.PRODUCT,arguments: {'product': porduct.convertProductCatalogue()});
  }

  int getNumeroDeProductosDeMarca({required String id}) {
    int cantidad = 0;

    for (ProductoNegocio item in getCataloProducts) {
      if (item.idMarca == id) {
        cantidad++;
      }
    }

    return cantidad;
  }

  void readProfileAccountStream({required String id}) {
    // creamos un ayente
    Database.readProfileBusinessModelStream(id).listen((event) {
      setProfileAccountSelected =  ProfileBusinessModel.fromDocumentSnapshot(documentSnapshot: event);
      setLoadProfileBusiness = true;
      readCatalogueListProductsStream(id: getIdAccountSelecte);
      readListCategoryListFuture();
    }).onError((error) {
      print('######################## readProfileBursinesStreaml: ' +
          error.toString());
      setLoadProfileBusiness = false;
    });
  }

  Future<Marca> readMark({required String id}) async {
    return Database.readMarkFuture(id: id)
        .then((value) => Marca.fromDocumentSnapshot(documentSnapshot: value))
        .catchError((error) => Marca(
            timestampActualizado: Timestamp.now(),
            timestampCreacion: Timestamp.now()));
  }

  void readProfileBursinesFuture({required String id}) {
    // obtenemos una sola ves el perfil de la cuenta de un negocio
    Database.readUserModelFuture(id).then((value) {
      // ignore: unused_local_variable \
      ProfileBusinessModel.fromDocumentSnapshot(documentSnapshot: value);
    }).catchError((error) {
      print('######################## readProfileBursinesFuture: ' +
          error.toString());
    });
  }

  void readManagedAccountsReference({required String idUser}) {
    // obtenemos las cuentas adminitradas por este usuario
    Database.readManagedAccountsQueryStream(id: idUser).listen((value) {
      value.docs.forEach((element) => readManagedAccountsData(
          idAccountUser: idUser, idAccountBussiness: element.id));
    }).onError((error) {
      print('######################## readManagedAccountsReference: ' +
          error.toString());
      setLoadDataProfileUser = false;
    });
  }

  void readManagedAccountsData(
      {required String idAccountBussiness, required String idAccountUser}) {
    // obtenemos los datos dela cuenta adminitrada por este usuario
    Database.readManagedAccounts(
            idAccount: idAccountBussiness, idUser: idAccountUser)
        .then((value) {
      AdminUsuarioCuenta adminUsuarioCuenta =
          AdminUsuarioCuenta.fromDocumentSnapshot(documentSnapshot: value);

      // obtenemos una sola ves el perfil de la cuenta de un negocio
      Database.readProfileBusinessModelFuture(adminUsuarioCuenta.idAccount)
          .then((value) {
        ProfileBusinessModel profileAccount =
            ProfileBusinessModel.fromDocumentSnapshot(documentSnapshot: value);
        //  agregamos los datos del perfil de la cuenta en la lista para mostrar al usuario
        addManagedAccount(
            profileData: profileAccount,
            adminUsuarioCuentaData: adminUsuarioCuenta);
      }).catchError((error) {
        print('######################## readProfileBursinesFuture: ' +
            error.toString());
      });
    }).catchError((error) {
      print('######################## readManagedAccountsData: ' +
          error.toString());
    });
  }

  void readProfileUserStream({required String id}) {
    //  leemos el perfil de la cuenta del usuario en la db de firestore
    Database.readUserModelStream(id).listen((event) {
      setUsetAccount = UsersModel.fromDocumentSnapshot(documentSnapshot: event);
      setLoadDataProfileUser = true;
    }).onError((error) {
      print(
          '######################## readUserModelStream: ' + error.toString());
      setLoadDataProfileUser = false;
    });
  }

  void readListCategoryListFuture() {
    // obtenemos la categorias creadas por el usuario
    Database.readCategoriesQueryStream(idAccount: getProfileAccountSelected.id).listen((event) {
      List<Categoria> list = [];
      event.docs.forEach((element) => list.add(Categoria.fromMap(element.data())));
      setCatalogueCategoryList = list;
    });
  }

  void readListSuggestedProductsFuture() {
    // obtenemos tres primeros obj(productos) desctacados para mostrarle al usuario
    Database.readProductsFuture(limit: 3).then((value) {
      List<Producto> list = [];
      value.docs.forEach((element) => list.add(Producto.fromMap(element.data())));
      setListSuggestedProducts = list;
    });
  }

  void readCatalogueListProductsStream({required String id}) {
    // obtenemos los obj(productos) del catalogo de la cuenta del negocio
    Database.readProductsCatalogueStream(id: id).listen((value) {
      List<ProductoNegocio> list = [];
      value.docs.forEach(
          (element) => list.add(ProductoNegocio.fromMap(element.data())));
      setCatalogueProducts = list;
      setCatalogueFilter = list;
      getCatalogueMoreLoad();
      _loadMarksAll(list: list);
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
  void _loadMarksAll({required List<ProductoNegocio> list}) {
    // recorremos las lista de los productos
    // obtenemos la marca de cada producto en un nueva lista
    // y finamente la agregamos con los datos cargados para mostrar al usuario
    for (var productoNegocio in list) {
      if (productoNegocio.idMarca != ''){
        readMark(id: productoNegocio.idMarca).then((value) => addMark(markParam: value));
      }
        
    }
  }

  void filterMarks({required List<ProductoNegocio> catalogueFilter}) {
    // recorresmos las lista de elementos para mostras las marcas al usuario
    List<String> idList = [];
    // extraemos los ids de las marcas
    for (var product in catalogueFilter) {
      // asignamos un estado para saber si tenemos una id repetida
      bool repeated = false;
      // recorremos las lista de ids
      for (String id in idList) {
        if (id == product.idMarca) repeated = true;
      }
      // si no se repite se agrega a la lista
      if (repeated == false) {
        idList.add(product.idMarca);
      }
    }
    // creamos una nueva lista con las marca y los datos ya cargados
    List<Marca> markList = [];
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
    // duración por defecto de la carga de datos
    Timer.periodic(Duration(milliseconds: 2000), (Timer timer) {
      timer.cancel();

      // creamos una nueva variable con los datos ya mostrados al usuario
      List<ProductoNegocio> listLoad = getCatalogueLoad;

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
    });
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
              // instancias de GoogleSignIn para proceder a cerrar sesión en el proveedor de cuentas
              late final GoogleSignIn googleSign = GoogleSignIn();
              await googleSign.signIn().then((value) async {
                // instancias de FirebaseAuth para proceder a cerrar sesión
                final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                await firebaseAuth.signOut().then((value) {
                  // value default
                  GetStorage().write('idAccount', '');
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
}
