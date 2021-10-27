import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController {
  // image
  final Rx<ImagePicker> _picker = ImagePicker().obs;
  late final Rx<PickedFile> _pickedFile =PickedFile('').obs;
  PickedFile get getPickedFile => _pickedFile.value;
  set setPickedFile(PickedFile value) => _pickedFile.value = value;
  void setImageSource({required ImageSource imageSource}){
    setPickedFile = ( _picker.value.pickImage(source: imageSource,maxWidth: 720.0,maxHeight: 720.0,imageQuality: 55))  as PickedFile;
  }

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
