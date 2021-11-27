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
    _codeBarParameter = Get.arguments['idProduct']??'';
    if(_codeBarParameter!=''){queryProduct(id: _codeBarParameter);}
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
  String _codeBarParameter = "";

  // Color de fondo
  Color _colorFondo = Colors.deepPurple;
  set setColorFondo(Color color) => _colorFondo = color;
  get getColorFondo => _colorFondo;

  // TextEditingController
  TextEditingController textEditingController = new TextEditingController();
  set setTextEditingController(TextEditingController editingController) =>
      textEditingController = editingController;
  get getTextEditingController => textEditingController;

  // color component textfield
  Color _textEditingColor = Colors.deepPurple;
  set setTextEditingColor(Color color) => _textEditingColor = color;
  get getTextEditingColor => _textEditingColor;

  // state search
  bool _stateSearch = false;
  set setStateSearch(bool state) => _stateSearch = state;
  get getStateSearch => _stateSearch;

  // state result
  bool _productDoesNotExist = true;
  set setproductDoesNotExist(bool state) {
    setColorFondo = Colors.red;
    setTextEditingColor = Colors.white;
    _productDoesNotExist = state;
  }

  get getproductDoesNotExist => _productDoesNotExist;

  // FUCTIONS
  void queryProduct({required String id}) {
    if (id != '') {
      // set
      setStateSearch = true;
      clean();
      update(['updateAll']);
      // query
      Database.readProductGlobalFuture(id: id).then((value) {
        Producto productoNegocio = Producto.fromMap(value.data() as Map);
        Get.back();
        Get.toNamed(Routes.PRODUCT,
            arguments: {'product': productoNegocio.convertProductCatalogue()});
      }).onError((error, stackTrace) {
        setproductDoesNotExist = false;
        setStateSearch = false;
        update(['updateAll']);
      }).catchError((error) {
        setproductDoesNotExist = false;
        setStateSearch = false;
        update(['updateAll']);
      });
    }
  }

  void clean() {
    textEditingController.clear();
    setproductDoesNotExist = false;
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
}
