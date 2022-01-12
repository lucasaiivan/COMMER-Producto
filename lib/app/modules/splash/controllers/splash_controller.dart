import 'package:get_storage/get_storage.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';

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

    // Verificamos si tenemos una referencia de una cuenta guardada en storage
    idAccount = GetStorage().read('idAccount') ?? '';

    ever(isSignIn, handleAuthStateChanged);

    // verificamos que alla un usaario autentificado
    isSignIn.value = firebaseAuth.currentUser != null;
    // escuchamos el cambio de estado de la autentifiación del usuario
    firebaseAuth.authStateChanges().listen((event) => isSignIn.value = event != null);


    super.onReady();
  }

  @override
  void onClose() {}

// manejar el estado de autenticación
  void handleAuthStateChanged(isLoggedIn) async {
    // visualizamos un diálogo alerta
    CustomFullScreenDialog.showDialog();
    // aquí, según el estado de autentificación redirigir al usuario a la vista correspondiente
    if (isLoggedIn) {
      // authentication
      Get.offAllNamed(Routes.WELCOME, arguments: {
        'currentUser': firebaseAuth.currentUser,
        'idAccount': idAccount,
      });
    } else {
      // no authentication
      await GetStorage().write('idAccount', '');
      await googleSign.signOut();
      Get.offAllNamed(Routes.LOGIN);
    }
    // finalizamos el diálogo alerta
    CustomFullScreenDialog.cancelDialog();
  }
}
