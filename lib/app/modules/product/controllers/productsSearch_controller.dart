import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';

class ButtonData {
  Color colorButton = Colors.purple;
  Color colorText = Colors.white;
  ButtonData({required Color colorButton, required Color colorText}) {
    this.colorButton = colorButton;
    this.colorText = colorText;
  }
}

class ControllerProductsSearch extends GetxController {
  late final WelcomeController welcomeController;

  @override
  void onInit() {
    // obtenemos los datos del controlador principal
    welcomeController = Get.find();
    // llamado inmediatamente después de que se asigna memoria al widget - ej. fetchApi();
    _codeBarParameter = Get.arguments['id'] ?? '';
    if (_codeBarParameter != '') {
      getTextEditingController.text = _codeBarParameter;
      queryProduct(id: _codeBarParameter);
    }
    queryProductSuggestion();

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
  Color _colorFondo = Get.theme.scaffoldBackgroundColor;
  set setColorFondo(Color color) => _colorFondo = color;
  get getColorFondo => _colorFondo;

  // Color de icono y texto de appbar y textfield
  Color? _colorTextField = Get.theme.textTheme.bodyText1!.color;
  set setColorTextField(Color color) => _colorTextField = color;
  get getColorTextField => _colorTextField;

  // TextEditingController
  TextEditingController textEditingController = new TextEditingController();
  set setTextEditingController(TextEditingController editingController) =>  textEditingController = editingController;
  TextEditingController get getTextEditingController => textEditingController;

  // color component textfield
  ButtonData _buttonData =
      ButtonData(colorButton: Get.theme.primaryColor, colorText: Colors.white);
  setButtonData({required Color colorButton, required Color colorText}) =>
      _buttonData = ButtonData(colorButton: colorButton, colorText: colorText);
  ButtonData get getButtonData => _buttonData;

  // state search
  bool _stateSearch = false;
  set setStateSearch(bool state) => _stateSearch = state;
  get getStateSearch => _stateSearch;

  // state result
  bool _productDoesNotExist = false;
  set setproductDoesNotExist(bool state) {
    if (state) {
      setColorFondo = Colors.red;
      setColorTextField = Colors.white;
      setButtonData(colorButton: Colors.white, colorText: Colors.black);
      _productDoesNotExist = state;
    } else {
      _productDoesNotExist = false;
    }
  }

  // list productos sujeridos
  List<Producto> _listProductsSuggestion = [];
  set setListProductsSuggestions(List<Producto> list) =>
      _listProductsSuggestion = list;
  List<Producto> get getListProductsSuggestions => _listProductsSuggestion;

  get getproductDoesNotExist => _productDoesNotExist;

  // FUCTIONS
  void queryProduct({required String id}) {
    if (id != '') {
      // set
      setStateSearch = true;
      update(['updateAll']);
      // query
      Database.readProductGlobalFuture(id: id).then((value) {
        Producto productoNegocio = Producto.fromMap(value.data() as Map);
        Get.back();
        Get.toNamed(Routes.PRODUCT,
            arguments: {'product': productoNegocio.convertProductCatalogue()});
      }).onError((error, stackTrace) {
        setproductDoesNotExist = true;
        setStateSearch = false;
        update(['updateAll']);
      }).catchError((error) {
        setproductDoesNotExist = true;
        setStateSearch = false;
        update(['updateAll']);
      });
    }
  }

  void updateAll() => update(['updateAll']);
  bool verifyIsNumber({required dynamic value}) {
    //  Verificamos que el dato ingresado por el usuario sea un número válido
    try {
      int.parse(value);
      return true;
    } catch (_) {
      return false;
    }
  }

  void clean() {
    textEditingController.clear();
    _productDoesNotExist = false;
    setButtonData(colorButton: Get.theme.primaryColor, colorText: Colors.white);
    setColorFondo = Get.theme.scaffoldBackgroundColor;
    setColorTextField =
        Get.theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    update(['updateAll']);
  }

  void queryProductSuggestion() {
    Database.readProductsFuture(limit: 4).then((value) {
      List<Producto> newList = [];
      value.docs
          .forEach((element) => newList.add(Producto.fromMap(element.data())));
      setListProductsSuggestions = newList;
      update(['updateAll']);
    });
  }

  void toProductView({required ProductoNegocio porduct}) {
    Get.toNamed(Routes.PRODUCT,arguments: {'product': porduct});
  }
  void toProductNew({required String id}) {
    Get.toNamed(Routes.PRODUCTS_EDIT,arguments: {'product': ProductoNegocio(id: id,codigo: id,timestampActualizacion: Timestamp.now(),timestampCreation: Timestamp.now())});
  }
}
