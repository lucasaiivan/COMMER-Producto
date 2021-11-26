import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControllerProductsSearch extends GetxController {
  @override
  void onInit() {
    // llamado inmediatamente después de que se asigna memoria al widget - ej. fetchApi();
    _textEditingController.text = Get.arguments['idProduct'];
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

  // Color de fondo
  Color _colorFondo = Colors.deepPurple;
  set setColorFondo( Color color) => _colorFondo = color;
  get getColorFondo => _colorFondo;

  // color text button
  Color _colorTextButton = Colors.white;
  set setColorTextButton(Color color) => _colorTextButton = color;
  get getColorTextButton => _colorTextButton;

  // TextEditingController
  TextEditingController _textEditingController = new TextEditingController();
  set setTextEditingController( TextEditingController editingController) => _textEditingController = editingController;
  get getTextEditingController => _textEditingController;

  // state search
  var _buscando = false;
  set setStateSearch(bool state) => _buscando = state;
  get getStateSearch => _buscando;

  // visibility button add
  var _buttonAddVisivility = false;
  set setButtonAddVisivility(bool state) => _buttonAddVisivility = state;
  get getButtonAddVisivility => _buttonAddVisivility;

  // state result
  var _resultState = true;
  set setResultState(bool state) => _resultState = state;
  get getResultState => _resultState;

  // result text
  String _textResult = "";
  set setTextResult(String text) => _textResult = text;
  get getTextResult => _textResult;
}
