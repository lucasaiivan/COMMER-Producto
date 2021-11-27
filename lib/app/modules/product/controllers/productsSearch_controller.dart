import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';

class ControllerProductsSearch extends GetxController {
  late final WelcomeController welcomeController;

  @override
  void onInit() {
    // obtenemos los datos del controlador principal
    welcomeController = Get.find();
    // llamado inmediatamente después de que se asigna memoria al widget - ej. fetchApi();
    setCodeBar = Get.arguments['idProduct'];
    super.onInit();
  }

  @override
  void onReady() {
    // llamado después de que el widget se representa en la pantalla - ej. showIntroDialog();
    super.onReady();
  }

  @override
  void onClose() {
    // llamado justo antes de que el controlador se elimine de la memoria - ej. closeStream();
    super.onClose();
  }

  // result text
  RxString _codeBar = "".obs;
  set setCodeBar(String text) => _codeBar.value = text;
  get getCodeBar => _codeBar.value;

  // Color de fondo
  Rx<Color> _colorFondo = Colors.deepPurple.obs;
  set setColorFondo(Color color) => _colorFondo.value = color;
  get getColorFondo => _colorFondo.value;

  // color text button
  Rx<Color> _colorTextButton = Colors.white.obs;
  set setColorTextButton(Color color) => _colorTextButton.value = color;
  get getColorTextButton => _colorTextButton.value;

  // TextEditingController
  Rx<TextEditingController> textEditingController =
      new TextEditingController().obs;
  set setTextEditingController(TextEditingController editingController) =>
      textEditingController.value = editingController;
  get getTextEditingController => textEditingController.value;

  // state search
  RxBool _buscando = false.obs;
  set setStateSearch(bool state) => _buscando.value = state;
  get getStateSearch => _buscando.value;

  // visibility button add
  RxBool _buttonAddVisivility = false.obs;
  set setButtonAddVisivility(bool state) => _buttonAddVisivility.value = state;
  get getButtonAddVisivility => _buttonAddVisivility.value;

  // state result
  RxBool _resultState = true.obs;
  set setResultState(bool state) => _resultState.value = state;
  get getResultState => _resultState.value;

  // result text
  RxString _textResult = "".obs;
  set setTextResult(String text) => _textResult.value = text;
  get getTextResult => _textResult.value;

  // FUCTIONS
  void queryProduct({required String id}) {
    if (id != '') {
      // set
      setStateSearch = true;
      setButtonAddVisivility = false;
      // query
      Database.readProductGlobalFuture(id: id).then((value) {
        Producto productoNegocio = Producto.fromMap(value.data() as Map);
        Get.back();
        Get.toNamed(Routes.PRODUCT, arguments: {'product': productoNegocio.convertProductCatalogue()});
      }).onError((error, stackTrace) {
        // set
        setStateSearch = false;
        setButtonAddVisivility = true;
        setColorFondo = Colors.red;
        setResultState = false;
      });
    }
  }

 /*  Future<bool> queryExistProductCatalogue({required String id}) async {
    // Va a comprobar si el producto ya existe en el cátalogo de la cuenta
    bool state = false;
    welcomeController.getCataloProducts.forEach((element) {
      if (element.id == id) {
        state = true;
      }
    });
    return state;
  } */

  void barCode({required String barcodeScannes}) {
    textEditingController.value.text = barcodeScannes;
    setCodeBar = barcodeScannes;
    setStateSearch = false;
    setButtonAddVisivility = false;
    queryProduct(id: barcodeScannes);
  }
}
