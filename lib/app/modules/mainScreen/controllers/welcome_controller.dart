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
    // actualizamos la vista completa
    update(['accountUpdate']);
  }

  String get getIdAccountSelecte => idAccountSelected.value;
  Rx<ProfileBusinessModel> _profileAccount = ProfileBusinessModel().obs;
  ProfileBusinessModel get getProfileAccountSelected => _profileAccount.value;
  set setProfileAccountSelected(ProfileBusinessModel user) =>  _profileAccount.value = user;
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
  List<ProductoNegocio> get getCatalogueBusiness => _catalogueBusiness;
  set setCatalogueBusiness(List<ProductoNegocio> products) =>
      _catalogueBusiness.value = products;

  // filter catalog
  RxList<ProductoNegocio> _catalogueFilter = <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getCatalogueFilter => _catalogueFilter;
  set setCatalogueFilter(List<ProductoNegocio> products) =>
      _catalogueFilter.value = products;

  // load catalog
  List<ProductoNegocio> _catalogueLoad = <ProductoNegocio>[].obs;
  List<ProductoNegocio> get getCatalogueLoad => _catalogueLoad;
  set setCatalogueLoad(List<ProductoNegocio> products) =>
      _catalogueLoad = products;

  // variable para comprobar cuando se han cargado todos los productos del cátalogo
  RxBool _loadDataCatalogue = false.obs;
  bool get getLoadDataCatalogue => _loadDataCatalogue.value;
  set setLoadDataCatalogue(bool value) => _loadDataCatalogue.value = value;

  // Si esta variable es diferente de 'vacía' mostrará el catálogo solo los productos de esa categoria
  RxString _selectCategoryId = ''.obs;
  String get getSelectCategoryId => _selectCategoryId.value;
  set setSelectCategoryId(String value) => _selectCategoryId.value = value;

  // Si esta variable es diferente de 'vacía' mostrará el catálogo solo los productos de esa subcategoria
  RxString _selectSubcategoryId = ''.obs;
  String get getSelectSubcategoryId => _selectSubcategoryId.value;
  set setSelectSubcategoryId(String value) =>
      _selectSubcategoryId.value = value;

  // Si esta variable es diferente de 'vacía' mostrará el catálogo solo los productos de esa categoría
  RxString _selectMarkId = ''.obs;
  String get getSelectMarkId => _selectMarkId.value;
  set setSelectMarkId(String value) => _selectMarkId.value = value;

  //  account profile
  Rx<Categoria> _categorySelect = Categoria().obs; // perfil del usuario
  Categoria get getCategorySelect => _categorySelect.value;
  set setCategorySelect(Categoria value) => _categorySelect.value = value;

  //  estado de la carga de obj en el grid del cátalogo
  Rx<LoadStatus> _loadGridCatalogueStatus = LoadStatus.normal.obs;
  LoadStatus get getLoadGridCatalogueStatus => _loadGridCatalogueStatus.value;
  set setLoadGridCatalogueStatus(LoadStatus value) =>
      _loadGridCatalogueStatus.value = value;

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
    if (repeated == false) _marks.add(markParam);
  }

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
    Get.toNamed(Routes.PRODUCT,
        arguments: {'product': porduct.convertProductCatalogue()});
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

  void readProfileAccountStream({required String id}) {
    // creamos un ayente
    Database.readProfileBusinessModelStream(id).listen((event) {
      setProfileAccountSelected =
          ProfileBusinessModel.fromDocumentSnapshot(documentSnapshot: event);
      setLoadProfileBusiness = true;
      readCatalogueListProductsStream(id: getIdAccountSelecte);
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
            idAccountBussiness: idAccountBussiness,
            idAccountUser: idAccountUser)
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
