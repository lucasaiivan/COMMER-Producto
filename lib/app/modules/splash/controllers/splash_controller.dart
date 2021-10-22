
import 'package:get_storage/get_storage.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../mainScreen/customFullScreenDialog.dart';

class SplashController extends GetxController {
  var isSignIn = false.obs;
  // instancias de FirebaseAuth y GoogleSignIn
  late final GoogleSignIn googleSign = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String idAccount = '';

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {
    ever(isSignIn, handleAuthStateChanged);
    // verificamos que alla un usaario autentificado
    isSignIn.value = firebaseAuth.currentUser != null;
    // escuchamos el cambio de estado de la autentifiación del usuario
    firebaseAuth
        .authStateChanges()
        .listen((event) => isSignIn.value = event != null);

    try {
      idAccount = Get.arguments['idAccount'] as String;
      // Verificamos si tenemos una referencia de una cuenta guardada en storage
      if(idAccount==""){
        GetStorage storage = GetStorage();
        idAccount=storage.read('idAccount')??'';
      }
      
    } catch (e) {
      idAccount = '';
      // Verificamos si tenemos una referencia de una cuenta guardada en storage
      idAccount=GetStorage().read('idAccount')??'';
    }

    super.onReady();
  }

  @override
  void onClose() {}

// manejar el estado de autenticación
  void handleAuthStateChanged(isLoggedIn) async {
    // visualizamos un diálogo alerta
    CustomFullScreenDialog.showDialog();
    // aquí, según el estado, redirigir al usuario a la vista correspondiente
    if (isLoggedIn) {
      Future.delayed(Duration(seconds: 2)).then((_) {
        Get.offAllNamed(Routes.WELCOME, arguments: {
          'currentUser': firebaseAuth.currentUser,
          'idAccount': idAccount,
        });
      });
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
    // finalizamos el diálogo alerta
    CustomFullScreenDialog.cancelDialog();
  }
}
