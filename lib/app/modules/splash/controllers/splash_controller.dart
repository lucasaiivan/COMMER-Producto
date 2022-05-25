import 'package:get_storage/get_storage.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';

// Controlador para autentificacion del usuario mediante
// proveedores: GoogleSignIn
// manejador de estados: GetX

class SplashController extends GetxController {

  // FirebaseAuth and GoogleSignIn instances
  late final GoogleSignIn googleSign = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // var
  String idAccount = '';
  var isSignIn = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() async {

    // Verificamos si tenemos una referencia de una cuenta guardada en GetStorage ( API del controlador de almacenamiento )
    idAccount = GetStorage().read('idAccount') ?? '';
    
    /// Workers
    // Los trabajadores lo ayudarán y activarán devoluciones de llamadas específicas cuando ocurra un evento.
    // ever - se llama cada vez que la variable Rx emite un nuevo valor.
    // Se llama cada vez que cambia es estado la variable rx 'isSignIn'
    ever(isSignIn, handleAuthStateChanged);

    // StreamSubscription
    // escuchamos el estado de inicio de sesión del usuario (como inicio de sesión o desconectado)
    firebaseAuth.authStateChanges().listen((event) => isSignIn.value = event != null);

    super.onReady();
  }

  @override
  void onClose() {}

// manejador del estado de autenticación
  void handleAuthStateChanged(isLoggedIn) async {
    // visualizamos un diálogo alerta
    CustomFullScreenDialog.showDialog();
    // aquí, según el estado de autentificación redirigir al usuario a la vista correspondiente
    if (isLoggedIn) {
      // si esta autentificado
      Get.offAllNamed(Routes.WELCOME, arguments: {
        'currentUser': firebaseAuth.currentUser,
        'idAccount': idAccount,
      });
    } else {
      // si no esta autentificado
      await GetStorage().write('idAccount', '');
      await googleSign.signOut();
      Get.offAllNamed(Routes.LOGIN);
    }
    // finalizamos el diálogo alerta
    CustomFullScreenDialog.cancelDialog();
  }
}
