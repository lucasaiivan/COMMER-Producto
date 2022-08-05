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
import 'package:producto/app/utils/functions.dart';

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
  late HomeController homeController;

  @override
  void onInit() {

    // obtenemos los datos del controlador principal
    homeController = Get.find();
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
  ProductCatalogue productSelect = ProductCatalogue(upgrade: Timestamp.now(), creation: Timestamp.now(),documentCreation: Timestamp.now(),documentUpgrade: Timestamp.now());

  // list excel to json
   List<ProductCatalogue> productsToExelList = [];
  static List<Map<String, dynamic>> listExcelToJson = [];
  void filterListExcelToJson({required List<Map<String, dynamic>> value}) async{

    for (var element in value) {
      // set values
      ProductCatalogue productCatalogue = ProductCatalogue(creation: Timestamp.now(),upgrade: Timestamp.now(),documentCreation: Timestamp.now(),documentUpgrade: Timestamp.now());
        productCatalogue.id = element['Código'];
        productCatalogue.code = element['Código'];
        productCatalogue.description = element['Producto'];
        productCatalogue.purchasePrice = double.tryParse(element['P. Costo'].toString().replaceAll('\$', '').replaceAll(',', '.')) ??0.0;
        productCatalogue.salePrice = double.tryParse(element['P. Venta'].toString().replaceAll('\$', '').replaceAll(',', '.')) ??0.0;
      if(productCatalogue.id==''){break;}
      Database.readProductPublicFuture(id: productCatalogue.id).then((value) {
        if(value.exists){
          // no se hace nada
        }else{
          productsToExelList.add(productCatalogue);
          update(['updateAll']);
        }
      });
    }
    //listExcelToJson = value;
  }
  List<Map<String, dynamic>> get getListExcelToJson => listExcelToJson;

  // result text
  String _codeBarParameter = "";

  // Color de fondo
  Color _colorFondo = Get.theme.scaffoldBackgroundColor;
  set setColorFondo(Color color) => _colorFondo = color;
  Color get getColorFondo => _colorFondo;

  // Color de icono y texto de appbar y textfield
  Color? _colorTextField = Get.theme.textTheme.bodyText1!.color;
  set setColorTextField(Color color) => _colorTextField = color;
  get getColorTextField => _colorTextField;

  // TextEditingController
  TextEditingController textEditingController =  TextEditingController(text: '');
  set setTextEditingController(TextEditingController editingController) => textEditingController = editingController;
  TextEditingController get getTextEditingController => textEditingController;

  // color component textfield
  ButtonData _buttonData = ButtonData(colorButton: Get.theme.primaryColor, colorText: Colors.white);
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
  static List<Product> _listProductsSuggestion = [];
  set setListProductsSuggestions(List<Product> list) => _listProductsSuggestion = list;
  List<Product> get getListProductsSuggestions => _listProductsSuggestion;

  get getproductDoesNotExist => _productDoesNotExist;

  // FUCTIONS
  void queryProduct({required String id}) {
    if (id != '') {
      // set
      setStateSearch = true;
      update(['updateAll']);
      // query
      Database.readProductPublicFuture(id: id).then((value) {
        Product product = Product.fromMap(value.data() as Map);
        toProductView(porduct: product.convertProductCatalogue());
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
    if (getListProductsSuggestions.isEmpty) {
      Database.readProductsFuture(limit: 6).then((value) {

        // values 
        List<Product> newList = [];
        for (var element in value.docs) {newList.add(Product.fromMap(element.data()));}
        // set
        setListProductsSuggestions = newList;
        // actualizamos la vista
        update(['updateAll']);
      });
    }
  }

  void toProductView({required ProductCatalogue porduct}) {
    Get.back();
     // TODO :  comrpobar si el producto esta en el cátalogo
     // ...
    Get.toNamed(Routes.PRODUCTS_EDIT, arguments: {'product': porduct});
  }

  void toProductNew({required String id}) {
    //values default
    clean();
    //set
    productSelect.id = id;
    productSelect.code = id;
    // navega hacia una nueva vista para crear un nuevo producto
    Get.toNamed(Routes.PRODUCTS_EDIT,arguments: {'new': true, 'product': productSelect});
  }

  // TODO : eliminar para release
  selectedExcel() async {
    
    FilePickerResult? file = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'csv', 'xls']);
    
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
              Map<String, dynamic> temp = <String, dynamic>{};
              int j = 0;
              String tk = '';
              // definimos cuantas columnas queremos recorrer
              for (var key in keys) {
                tk = key.value;
                if ((row[j].runtimeType == String)) {
                  temp[tk] = "\u201C${row[j].value}\u201D";
                } else {
                  temp[tk] = row[j].value;
                }
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

      filterListExcelToJson(value: json);
    } else {
      productsToExelList = [];
      update();
    }
  }

  openDialogListExcel() {
    // muestra una ventana emergente con la lista de productos para verificar
    Widget widget = Scaffold(
      appBar: AppBar(title: Text('Productos de excel (${productsToExelList.length})')),
      body: ListView.builder(
      itemCount: productsToExelList.length,
      itemBuilder: (context, index) {
        
        // values
        ProductCatalogue productValue = ProductCatalogue(documentCreation: Timestamp.now(),documentUpgrade: Timestamp.now(),creation: Timestamp.now(), upgrade: Timestamp.now());
        // set values
        productValue = productsToExelList[index];

        return homeController.isCatalogue(id: productValue.code)
            ? Container()
            :  Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
          contentPadding: const EdgeInsets.all(12),
          title: Text(productValue.description,maxLines: 1,overflow:TextOverflow.clip),
          subtitle: Row(
                children: [
                  // text : code
                  productValue.code!=''?Padding(padding: const EdgeInsets.symmetric(horizontal: 5),child: Icon(Icons.circle,size: 8, color: Get.theme.dividerColor)):Container(),
                  productValue.code!=''? Text(productValue.code):Container(),
                  // text : precio
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 5),child: Icon(Icons.circle,size: 8, color: Get.theme.dividerColor)),
                  Text(Publications.getFormatoPrecio(monto: productValue.salePrice)),
                ],
          ),
          onTap: () {
                //  set
                productSelect = productValue;
                Get.back();
                textEditingController.text = productSelect.id;
                queryProduct(id: productSelect.id);
          },
        ),
        const Divider(height: 0),
              ],
            );
      },
    ),
    );
    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }


  // var
  final RxList<Product> _lisProductsVerified = <Product>[].obs;
  List<Product> get getListProductsVerified {

    for (var i = 0; i < _lisProductsVerified.length; i++) {

      for (var j = 0; j < homeController.getCataloProducts.length; j++) {
        if( _lisProductsVerified[i].id == homeController.getCataloProducts[j].id ){
          if(homeController.getCataloProducts[j].verified){
            _lisProductsVerified.removeAt(i);
          }
        }
      }
    }
    return _lisProductsVerified;
  }
  set setListProductsVerified(List<Product> value) => _lisProductsVerified.value = value;

  void readProduct() {
    Database.readProductsVerifiedFuture().then((value) {
      List<Product> list = [];
      for (var element in value.docs) {
        list.add(Product.fromMap(element.data()));
      }
      setListProductsVerified = list.cast<Product>();
      update(['updateAll']);
    });
  }
  openDialogListProductVerified({required List<Product> list}) {
    // muestra una ventana emergente con la lista de productos para verificar
    Widget widget = Scaffold(
      appBar: AppBar(title: const Text('Productos sin verificar')),
      body: ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        // values
        final Product productValue = list[index];


        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: const EdgeInsets.all(12),
              title: Text(productValue.nameMark,maxLines: 1,overflow:TextOverflow.clip),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(productValue.description,maxLines:1,overflow:TextOverflow.clip,textAlign: TextAlign.start,),
                  Row(
                    children: [
                      // text : code
                      productValue.code!=''?Padding(padding: const EdgeInsets.symmetric(horizontal: 5),child: Icon(Icons.circle,size: 8, color: Get.theme.dividerColor)):Container(),
                      productValue.code!=''? Text(productValue.code):Container(),
                      // text : marca de tiempo
                      Padding(padding: const EdgeInsets.symmetric(horizontal: 5),child: Icon(Icons.circle,size: 8, color: Get.theme.dividerColor)),
                      Text(Publications.getFechaPublicacion(productValue.creation.toDate(), Timestamp.now().toDate())),
                    ],
                  ),
                ],
              ),
              onTap: () {
                Get.back();
                Get.toNamed(Routes.PRODUCTS_EDIT,arguments: {'product': productValue.convertProductCatalogue()});
              },
            ),
            const Divider(height: 0),
          ],
        );
      },
    ),
    );
    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }
}
