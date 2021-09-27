import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/services/database.dart';
import '../../splash/controllers/splash_controller.dart';

class WelcomeController extends GetxController {
  SplashController homeController = Get.find<SplashController>();

  static late User userAuth; // perfil auth user
  static Rx<UsersModel> _userModel = UsersModel().obs; // perfil del usuario
  static Rx<bool> loadData = false.obs;

  bool get load => loadData.value;
  UsersModel get userProfile => _userModel.value;
  set setUser(UsersModel user) => _userModel.value = user;
  set setLoad(bool value) => loadData.value = value;

  void initUser({required String id}) =>
      Database.readUserModel(id).then((value) {
        setUser = UsersModel.fromDocumentSnapshot(documentSnapshot: value);
        setLoad = true;
      }).catchError(
          // ignore: invalid_return_type_for_catch_error
          (error) {
        print('######################## Database.readUserModel: ' + error.toString());
        setLoad = false;
      });

  @override
  void onInit() async {
    userAuth = Get.arguments['currentUser'];
    if (userAuth.uid != '')
      initUser(id: userAuth.uid); // read profile from user

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
}
