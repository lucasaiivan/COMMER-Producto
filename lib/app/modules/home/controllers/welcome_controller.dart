import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/services/database.dart';
import '../../splash/controllers/splash_controller.dart';

class WelcomeController extends GetxController {
  SplashController homeController = Get.find<SplashController>();

  static late User userAuth; // perfil auth user
  static Rx<UsersModel> _userModel = UsersModel().obs; // perfil del usuario
  static Rx<ProfileBusinessModel> _profileBusiness = ProfileBusinessModel().obs; // perfil del negocio
  static Rx<bool> loadData = false.obs;
  static Rx<bool> loadDataProfileBusiness = false.obs;
  static Rx<String> nameBusiness = ''.obs;



  bool get load => loadData.value;
  UsersModel get userProfile => _userModel.value;
  bool get loadProfileBusiness => loadDataProfileBusiness.value;
  String get nameProfileBusiness => nameBusiness.value;
  ProfileBusinessModel get profileBusiness => _profileBusiness.value;

  set setProfileBusiness(ProfileBusinessModel user) => _profileBusiness.value = user;
  set setUser(UsersModel user) => _userModel.value = user;
  set setLoad(bool value) => loadData.value = value;
  set setLoadProfileBusiness(bool value) => loadDataProfileBusiness.value = value;
  set setnameProfileBusiness(String value) => nameBusiness.value = value;

  void readProfileBursiness({required String id}) {

    Database.readStreamProfileBusinessModel(id).listen((event) {
      setProfileBusiness = ProfileBusinessModel.fromDocumentSnapshot(documentSnapshot: event);
      setnameProfileBusiness = event['nombre_negocio'];
      setLoadProfileBusiness = true;
     }).onError( (error) {
          print('######################## Database.readUserModel: ' + error.toString());
          setLoadProfileBusiness = false;
        });

   /*  Database.readFutureUserModel(id).then((value) {
      setUser = UsersModel.fromDocumentSnapshot(documentSnapshot: value);
      setLoad = true;
    }).catchError(
        // ignore: invalid_return_type_for_catch_error
        (error) {
          print('######################## Database.readUserModel: ' + error.toString());
          setLoad = false;
        }
    ); */
  }
  void readProfileUser({required String id}) {

    Database.readStreamUserModel(id).listen((event) {
      setUser = UsersModel.fromDocumentSnapshot(documentSnapshot: event);
      setLoad = true;
      readProfileBursiness(id: userProfile.idBusiness); // read profile from business
     }).onError( (error) {
          print('######################## Database.readUserModel: ' + error.toString());
          setLoad = false;
        });
  }

  @override
  void onInit() async {
    userAuth = Get.arguments['currentUser'];
    if (userAuth.uid != '')
      readProfileUser(id: userAuth.uid); // read profile from user
      

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
