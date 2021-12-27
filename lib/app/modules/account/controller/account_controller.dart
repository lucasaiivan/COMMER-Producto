import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/services/database.dart';

class AccountController extends GetxController {
  // controllers
  late final WelcomeController welcomeController;

  // variable para validar si se trata de una cuenta nueva
  bool isNew = false;

  void refresh() => update(['load']);

  late final Rx<TextEditingController> _controllerTextEditProvincia =
      TextEditingController().obs;
  TextEditingController get getControllerTextEditProvincia =>
      _controllerTextEditProvincia.value;
  set setControllerTextEditProvincia(TextEditingController value) =>
      _controllerTextEditProvincia.value = value;

  late final Rx<TextEditingController> controllerTextEditPais =
      TextEditingController().obs;
  TextEditingController get getControllerTextEditPais =>
      controllerTextEditPais.value;
  set setControllerTextEditPais(TextEditingController value) =>
      controllerTextEditPais.value = value;

  late final Rx<TextEditingController> controllerTextEditSignoMoneda =
      TextEditingController().obs;
  TextEditingController get getControllerTextEditSignoMoneda =>
      controllerTextEditSignoMoneda.value;
  set setControllerTextEditSignoMoneda(TextEditingController value) =>
      controllerTextEditSignoMoneda.value = value;

  // values
  final RxList<String> _listCities = [
    'Buenos Aires',
    'Catamarca',
    'Chaco',
    'Chubut',
    'Córdoba',
    'Corrientes',
    'Entre Ríos',
    'Formosa',
    'Jujuy',
    'La Pampa',
    'La Rioja',
    'Mendoza',
    'Misiones',
    'Neuquén',
    'Río Negro',
    'Salta',
    'San Juan',
    'San Luis',
    'Santa Cruz',
    'Santa Fe',
    'Santiago del Estero',
    'Tucumán',
    'Tierra del Fuego',
  ].obs;
  List<String> get getCities => _listCities;
  final RxList<String> _listountries = [
    'Argentina',
  ].obs;
  List<String> get getCountries => _listountries;

  // account profile
  Rx<ProfileAccountModel> _profileAccount = ProfileAccountModel().obs;
  ProfileAccountModel get getProfileAccount => _profileAccount.value;
  set setProfileAccount(ProfileAccountModel user) =>
      _profileAccount.value = user;

  // load save indicator
  final RxBool _savingIndicator = false.obs;
  bool get getSavingIndicator => _savingIndicator.value;
  set setSavingIndicator(bool value) {
    _savingIndicator.value = value;
    update(['load']);
  }

  /* void sleep() async {
    setSavingIndicator = true;
    await Future.delayed(Duration(seconds: 3))
        .then((value) => setSavingIndicator = false);
  } */

  // image update
  final RxBool _imageUpdate = false.obs;
  bool get getImageUpdate => _imageUpdate.value;
  set setImageUpdate(bool value) => _imageUpdate.value = value;
  // load image local
  final ImagePicker _picker = ImagePicker();
  late XFile _xFile = XFile('');
  XFile get getxFile => _xFile;
  set setxFile(XFile value) => _xFile = value;
  void setImageSource({required ImageSource imageSource}) async {
    setxFile = (await _picker.pickImage(
        source: imageSource,
        maxWidth: 720.0,
        maxHeight: 720.0,
        imageQuality: 55))!;
    setImageUpdate = true;
    update(['image']);
  }

  @override
  void onInit() async {
    // obtenemos los datos del controlador principal
    welcomeController = Get.find();
    // set
    setProfileAccount = welcomeController.getProfileAccountSelected;
    if (getProfileAccount.id == '') {
      getProfileAccount.id = welcomeController.getUserAccountAuth.uid;
      isNew = true;
    } else {
      isNew = false;
    }

    setControllerTextEditProvincia =
        TextEditingController(text: getProfileAccount.provincia);
    setControllerTextEditPais =
        TextEditingController(text: getProfileAccount.pais);
    setControllerTextEditSignoMoneda =
        TextEditingController(text: getProfileAccount.signoMoneda);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void saveAccount() async {
    if (getProfileAccount.id != "") {
      if (getProfileAccount.nombreNegocio != "") {
        if (getControllerTextEditProvincia.text != "") {
          if (getControllerTextEditPais.text != "") {
            // get
            _profileAccount.value.provincia =
                getControllerTextEditProvincia.text;
            _profileAccount.value.pais = getControllerTextEditPais.text;
            _profileAccount.value.signoMoneda =
                getControllerTextEditSignoMoneda.text;
            setSavingIndicator = true;

            // si se cargo una nueva imagen procede a guardar la imagen en Storage
            if (getImageUpdate) {
              UploadTask uploadTask =
                  Database.referenceStorageAccountImageProfile(
                          id: getProfileAccount.id == ''
                              ? welcomeController.getUserAccountAuth.uid
                              : getProfileAccount.id)
                      .putFile(File(getxFile.path));
              // para obtener la URL de la imagen de firebase storage
              getProfileAccount.imagenPerfil =
                  await (await uploadTask).ref.getDownloadURL();
            }

            // Cuando se crea una cuenta , se copia referencias del id de usuario de la cuenta
            if (isNew) {
              getProfileAccount.id = welcomeController.getUserAccountAuth.uid;

              // guarda la referencia del id de la cuenta en una colección de cunetas administradas en los datos del usuario
              await saveIdAccountRefForUserData(
                  data: {'id': getProfileAccount.id});

              // guarda la referencia del usuario en una colección de administradores en los datos de la cuenta
              await saveIdUserRefForAccountData(
                  data: AdminUsuarioCuenta(
                          idAccount: getProfileAccount.id,
                          idUser: getProfileAccount.id,
                          tipocuenta: 1,
                          estadoCuentaUsuario: true)
                      .toJson());

              // crear una nueva cuenta
              createAccount(data: getProfileAccount.toJson());
              Future.delayed(Duration(seconds: 3)).then((value) => welcomeController.accountChange(idAccount: getProfileAccount.id));
            } else {
              // actualizar los datos
              updateAccount(data: getProfileAccount.toJson());
              Future.delayed(Duration(seconds: 3)).then((value) => Get.back());
            }
          } else {
            Get.snackbar('', 'Debe proporcionar un pais de origen');
          }
        } else {
          Get.snackbar('', 'Debe proporcionar una provincia');
        }
      } else {
        Get.snackbar('', 'Debe proporcionar un nombre');
      }
    } else {
      Get.snackbar('', 'El ID del usuario de proveedor es NULO');
    }
  }

  Future<void> saveIdAccountRefForUserData(
      {required Map<String, dynamic> data}) async {
    // Esto guarda una referencia en los datos de la cuenta en la lista de cuentas administradas del usuario
    var documentReferencer = Database.refFirestoreUserAdmin(idUser: data['id'])
        .doc(getProfileAccount.id);
    await documentReferencer
        .set(data)
        .whenComplete(() => print(
            "######################## FIREBASE saveIdAccountRefForUserData whenComplete"))
        .catchError((e) => print(
            "######################## FIREBASE saveIdAccountRefForUserData catchError: $e"));
  }

  Future<void> saveIdUserRefForAccountData(
      {required Map<String, dynamic> data}) async {
    // Esto guarda una referencia en los datos del usurio en los datos de la cuenta administrada por el mismo
    var documentReferencer =
        Database.refFirestoreAccountAdmin(idAccount: getProfileAccount.id)
            .doc(welcomeController.getUserAccountAuth.uid);
    await documentReferencer
        .set(data)
        .whenComplete(() => print(
            "######################## FIREBASE saveIdUserRefForAccountData whenComplete"))
        .catchError((e) => print(
            "######################## FIREBASE saveIdUserRefForAccountData catchError: $e"));
  }

  Future<void> updateAccount({required Map<String, dynamic> data}) async {
    // Esto guarda una referencia en los datos del usurio en los datos de la cuenta administrada por el mismo
    var documentReferencer =
        Database.refFirestoreAccount().doc(getProfileAccount.id);
    // Actualizamos los datos de la cuenta
    documentReferencer.update(Map<String, dynamic>.from(data)).whenComplete(() {
      print("######################## FIREBASE updateAccount whenComplete");
    }).catchError((e) => print(
        "######################## FIREBASE updateAccount catchError: $e"));
  }

  Future<void> createAccount({required Map<String, dynamic> data}) async {
    // Esto guarda un documento con los datos de la cuenta por crear
    var documentReferencer =
        Database.refFirestoreAccount().doc(getProfileAccount.id);
    await documentReferencer.set(data).whenComplete(() {
      print("######################## FIREBASE saveAccount whenComplete");
    }).catchError((e) =>
        print("######################## FIREBASE saveAccount catchError: $e"));
  }
}
