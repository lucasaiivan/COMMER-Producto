import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/services/database.dart';

class AccountController extends GetxController {
  late final WelcomeController welcomeController;

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

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  void saveAccount({required ProfileBusinessModel perfilNegocio}) async {
    setSavingIndicator = true;
    // si se cargo una nueva imagen procede a guardar la imagen en Storage
    if (getImageUpdate) {
      UploadTask uploadTask =
          Database.referenceStorageAccountImageProfile(id: perfilNegocio.id)
              .putFile(File(getxFile.path));
      // para obtener la URL de la imagen de firebase storage
      perfilNegocio.imagenPerfil = await (await uploadTask).ref.getDownloadURL();
    }

    // Cuando se crea una cuenta , se copia referencias del id de usuario de la cuenta
    if (perfilNegocio.id == '') {
      // guarda un documento con la referencia del id de la cuenta en una lista en los datos del usuario
      await saveIdAccountRefForUserData(data: {'id': perfilNegocio.id});

      // TODO: (delete) por el momento vamos a probar omitir guardar los datos del usuario
      /* // Guarda datos del usuario y la referencia del id de la cuenta
      await Global.getDataUsuario(idUsuario: firebaseUser.uid)
          .upSetDocument(new Usuario(
                  email: firebaseUser.email,
                  id: firebaseUser.uid,
                  id_cuenta_negocio: firebaseUser.uid,
                  nombre: firebaseUser.displayName,
                  urlfotoPerfil: firebaseUser.photoURL,
                  timestamp_creation:
                      Timestamp.fromDate(new DateTime.now()))
              .toJson()); */

      // guarda un documento con la referencia del usuario, en la lista de administradores de la cuenta administrada
      await saveIdUserRefForAccountData(
          data: AdminUsuarioCuenta(
                  idAccount: perfilNegocio.id,
                  idUser: perfilNegocio.id,
                  tipocuenta: 0)
              .toJson());

      // crear cuenta
      createAccount(data: perfilNegocio.toJson());
      await Future.delayed(Duration(seconds: 2))
          .then((value) => setSavingIndicator = false);
    } else {
      // guarda los datos de la cuenta
      updateAccount(data: perfilNegocio.toJson());
      await Future.delayed(Duration(seconds: 2))
          .then((value) => setSavingIndicator = false);
    }
  }

  Future<void> saveIdAccountRefForUserData(
      {required Map<String, dynamic> data}) async {
    // Esto guarda una referencia en los datos de la cuenta
    var documentReferencer = Database.refFirestoreUserAdmin(idUser: data['id'])
        .doc(welcomeController.getUserAccountAuth.uid);
    await documentReferencer
        .update(data)
        .whenComplete(() => print(
            "######################## FIREBASE saveIdAccountRefForUserData whenComplete"))
        .catchError((e) => print(
            "######################## FIREBASE saveIdAccountRefForUserData catchError: $e"));
  }

  Future<void> saveIdUserRefForAccountData(
      {required Map<String, dynamic> data}) async {
    // Esto guarda una referencia en los datos del usurio en los datos de la cuenta administrada por el mismo
    var documentReferencer = Database.refFirestoreAccountAdmin(
            idAccount: welcomeController.getUserAccountAuth.uid)
        .doc(welcomeController.getUserAccountAuth.uid);
    await documentReferencer
        .update(data)
        .whenComplete(() => print(
            "######################## FIREBASE saveIdUserRefForAccountData whenComplete"))
        .catchError((e) => print(
            "######################## FIREBASE saveIdUserRefForAccountData catchError: $e"));
  }

  Future<void> updateAccount({required Map<String, dynamic> data}) async {
    // Esto guarda una referencia en los datos del usurio en los datos de la cuenta administrada por el mismo
    var documentReferencer = Database.refFirestoreAccount()
        .doc(welcomeController.getUserAccountAuth.uid);
    // Actualizamos los datos de la cuenta
    documentReferencer
        .set(Map<String, dynamic>.from(data), SetOptions(merge: true))
        .whenComplete(() => print(
            "######################## FIREBASE updateAccount whenComplete"))
        .catchError((e) => print(
            "######################## FIREBASE updateAccount catchError: $e"));
  }

  Future<void> createAccount({required Map<String, dynamic> data}) async {
    // Esto guarda una referencia en los datos del usurio en los datos de la cuenta administrada por el mismo
    var documentReferencer = Database.refFirestoreAccount()
        .doc(welcomeController.getUserAccountAuth.uid);

    await documentReferencer
        .update(data)
        .whenComplete(() =>
            print("######################## FIREBASE saveAccount whenComplete"))
        .catchError((e) => print(
            "######################## FIREBASE saveAccount catchError: $e"));
  }
}
