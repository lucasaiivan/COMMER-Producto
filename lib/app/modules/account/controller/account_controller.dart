import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // state validation accoun
  bool newAccount = false;
  // state loading
  bool stateLoding = true;

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
  Rx<ProfileAccountModel> _profileAccount =
      ProfileAccountModel(creation: Timestamp.now()).obs;
  ProfileAccountModel get profileAccount => _profileAccount.value;
  set setProfileAccount(ProfileAccountModel user) =>
      _profileAccount.value = user;

  // load save indicator
  final RxBool _savingIndicator = false.obs;
  bool get getSavingIndicator => _savingIndicator.value;
  set setSavingIndicator(bool value) {
    _savingIndicator.value = value;
    update(['load']);
  }

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
    verifyAccount(idAccount: welcomeController.getUserAccountAuth.uid);

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void verifyAccount({required String idAccount}) {
    Database.readProfileAccountModelFuture(idAccount).then((value) {
      if (value.exists) {
        // get
        ProfileAccountModel accountProfile =
            ProfileAccountModel.fromDocumentSnapshot(documentSnapshot: value);
        // set
        setProfileAccount = accountProfile;
        newAccount = false;
        setControllerTextEditProvincia =
            TextEditingController(text: profileAccount.province);
        setControllerTextEditPais =
            TextEditingController(text: profileAccount.country);
        setControllerTextEditSignoMoneda =
            TextEditingController(text: profileAccount.currencySign);
        stateLoding = false;
        update(['load']);
      } else {
        profileAccount.id = idAccount;
        newAccount = true;
        stateLoding = false;
        update(['load']);
      }
    }).catchError((error) {
      Get.back();
      Get.snackbar('Mi perfil',
          'Se ha producido un error, compruebe su conexión a Internet');
    });
  }

  void saveAccount() async {
    if (profileAccount.name != "") {
      if (getControllerTextEditProvincia.text != "") {
        if (getControllerTextEditPais.text != "") {
          // get
          _profileAccount.value.province = getControllerTextEditProvincia.text;
          _profileAccount.value.country = getControllerTextEditPais.text;
          _profileAccount.value.currencySign =
              getControllerTextEditSignoMoneda.text;
          setSavingIndicator = true;

          // comprobar existencia de creacion de cuenta
          if (newAccount) {
            profileAccount.id = welcomeController.getUserAccountAuth.uid;
          }
          // si se cargo una nueva imagen procede a guardar la imagen en Storage
          if (getImageUpdate) {
            UploadTask uploadTask =
                Database.referenceStorageAccountImageProfile(
                        id: profileAccount.id)
                    .putFile(File(getxFile.path));
            // para obtener la URL de la imagen de firebase storage
            profileAccount.image =
                await (await uploadTask).ref.getDownloadURL();
          }

          // actualizar los datos
          newAccount
              ? createAccount(data: profileAccount.toJson())
              : updateAccount(data: profileAccount.toJson());
        } else {
          Get.snackbar('', 'Debe proporcionar un pais de origen');
        }
      } else {
        Get.snackbar('', 'Debe proporcionar una provincia');
      }
    } else {
      Get.snackbar('', 'Debe proporcionar un nombre');
    }
  }

  Future<void> updateAccount({required Map<String, dynamic> data}) async {
    if (data['id'] != '') {
      // db ref
      var documentReferencer = Database.refFirestoreAccount().doc(data['id']);
      // Actualizamos los datos de la cuenta
      documentReferencer
          .update(Map<String, dynamic>.from(data))
          .whenComplete(() {
        Get.back();
        print("######################## FIREBASE updateAccount whenComplete");
      }).catchError((e) {
        setSavingIndicator = false;
        Get.snackbar('No se puedo guardar los datos',
            'Puede ser un problema de conexión');
        print("######################## FIREBASE updateAccount catchError: $e");
      });
    }
  }

  Future<void> createAccount({required Map<String, dynamic> data}) async {
    // Esto guarda un documento con los datos de la cuenta por crear
    if (data['id'] != '') {
      // db ref
      var documentReferencer = Database.refFirestoreAccount().doc(data['id']);
      await documentReferencer.set(data).whenComplete(() {
        welcomeController.accountChange(idAccount: data['id']);
        Get.back();
        print("######################## FIREBASE saveAccount whenComplete");
      }).catchError((e) {
        setSavingIndicator = false;
        Get.snackbar('No se puedo guardar los datos',
            'Puede ser un problema de conexión');
        print("######################## FIREBASE saveAccount catchError: $e");
      });
    }
  }
}
