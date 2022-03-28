import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/services/database.dart';
import 'package:producto/app/utils/dynamicTheme_lb.dart';

class ButtonData {
  Color colorButton = Colors.purple;
  Color colorText = Colors.white;
  ButtonData({required Color colorButton, required Color colorText}) {
    this.colorButton = colorButton;
    this.colorText = colorText;
  }
}

class ControllerProductsSearch extends GetxController {
  // controllers
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
    ThemeService.switchThemeDefault();
    super.onClose();
  }

  // product
  ProductCatalogue productSelect =
      ProductCatalogue(upgrade: Timestamp.now(), creation: Timestamp.now());

  // list excel to json
  static List<Map<String, dynamic>> listExcelToJson = [];
  set setListExcelToJson(List<Map<String, dynamic>> value) =>
      listExcelToJson = value;
  List<Map<String, dynamic>> get getListExcelToJson => listExcelToJson;

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
  set setTextEditingController(TextEditingController editingController) =>
      textEditingController = editingController;
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
      ThemeService.switchThemeColor(color: Colors.red);
      setColorFondo = Colors.red;
      setColorTextField = Colors.white;
      setButtonData(colorButton: Colors.white, colorText: Colors.black);
      _productDoesNotExist = state;
    } else {
      ThemeService.switchThemeDefault();
      _productDoesNotExist = false;
    }
  }

  // list productos sujeridos
  List<Product> _listProductsSuggestion = [];
  set setListProductsSuggestions(List<Product> list) =>
      _listProductsSuggestion = list;
  List<Product> get getListProductsSuggestions => _listProductsSuggestion;

  get getproductDoesNotExist => _productDoesNotExist;

  // FUCTIONS
  void queryProduct({required String id}) {
    if (id != '') {
      // set
      setStateSearch = true;
      update(['updateAll']);
      // query
      Database.readProductGlobalFuture(id: id).then((value) {
        Product productoNegocio = Product.fromMap(value.data() as Map);
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
    setStateSearch = false;
    textEditingController.clear();
    setproductDoesNotExist = false;
    setButtonData(colorButton: Get.theme.primaryColor, colorText: Colors.white);
    setColorFondo = Get.theme.scaffoldBackgroundColor;
    setColorTextField =
        Get.theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    update(['updateAll']);
  }

  void queryProductSuggestion() {
    Database.readProductsFuture(limit: 5).then((value) {
      List<Product> newList = [];
      value.docs
          .forEach((element) => newList.add(Product.fromMap(element.data())));
      setListProductsSuggestions = newList;
      update(['updateAll']);
    });
  }

  void toProductView({required ProductCatalogue porduct}) {
    Get.back();
    Get.toNamed(Routes.PRODUCT, arguments: {'product': porduct});
  }

  void toProductNew({required String id}) {
    clean();
    Get.toNamed(Routes.PRODUCTS_EDIT,
        arguments: {'new': true, 'product': productSelect});
  }

  // TODO : eliminar para release
  convert() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
        type: FileType.custom, allowedExtensions: ['xlsx', 'csv', 'xls']);
    if (file != null && file.files.isNotEmpty) {
      var bytes = File(file.files.first.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      int i = 0;
      List<dynamic> keys = <dynamic>[];
      List<Map<String, dynamic>> json = <Map<String, dynamic>>[];
      for (var table in excel.tables.keys) {
        // leer las filas
        for (var row in excel.tables[table]?.rows ?? []) {
          try {
            if (i == 0) {
              keys = row; // columnas
              i++;
            } else {
              Map<String, dynamic> temp = Map<String, dynamic>();
              int j = 0;
              String tk = '';
              // definimos cuantas columnas queremos recorrer
              for (var key in keys) {
                tk = key.value;
                temp[tk] = (row[j].runtimeType == String)
                    ? "\u201C" + row[j].value + "\u201D"
                    : row[j].value;
                // las columnas que quiero obtener
                if (j == 3) break;
                j++;
              }
              json.add(temp);
            }
          } catch (ex) {
            printError(info: ex.toString());
          }
        }
      }

      setListExcelToJson = json;
    } else {
      setListExcelToJson = [];
    }
    update(['updateAll']);
  }

  void openDialogListExcel() {
    Widget widget = ListView.builder(
      itemCount: getListExcelToJson.length,
      itemBuilder: (context, index) {
        return welcomeController.isCatalogue(id: getListExcelToJson[index]['Código'])?Container():ListTile(
          trailing: Icon(Icons.check_circle,
              color: welcomeController.isCatalogue(id: getListExcelToJson[index]['Código'])
                  ? Colors.green
                  : null),
          title: Text(
            getListExcelToJson[index]['Producto'],
            maxLines: 2,
          ),
          subtitle: Text(getListExcelToJson[index]['Código']),
          onTap: () {
            //  set
            productSelect.id = getListExcelToJson[index]['Código'];
            productSelect.code = getListExcelToJson[index]['Código'];
            productSelect.description = getListExcelToJson[index]['Producto'];
            productSelect.purchasePrice = double.tryParse(
                    getListExcelToJson[index]['P. Costo']
                        .toString()
                        .replaceAll('\$', '')
                        .replaceAll(',', '.')) ??
                0.0;
            productSelect.salePrice = double.tryParse(getListExcelToJson[index]
                        ['P. Venta']
                    .toString()
                    .replaceAll('\$', '')
                    .replaceAll(',', '.')) ??
                0.0;
            Get.back();
            textEditingController.text = productSelect.id;
            queryProduct(id: productSelect.id);
          },
        );
      },
    );
    Get.dialog(
      AlertDialog(
        content: Container(width: 500, height: double.infinity, child: widget),
        actions: [
          TextButton(
            child: const Text("Close"),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
