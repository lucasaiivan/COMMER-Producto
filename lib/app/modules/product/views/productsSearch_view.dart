import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:producto/app/modules/product/controllers/productsSearch_controller.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import '../../../utils/dynamicTheme_lb.dart';

class ProductsSearch extends GetView<ControllerProductsSearch> {
  // ignore: prefer_const_constructors_in_immutables
  ProductsSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerProductsSearch>(
      id: 'updateAll',
      init: ControllerProductsSearch(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: controller.getColorFondo,
          appBar: appbar(),
          body: _body(),
        );
      },
    );
  }

  /* WIDGETS */
  PreferredSizeWidget appbar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: controller.getColorFondo,
      title: Text(controller.getproductDoesNotExist ? "Sin resultados" : "Buscar",style: TextStyle(color: controller.getColorTextField),),
      leading: IconButton(icon: Icon(Icons.arrow_back, color: controller.getColorTextField),onPressed: () => Get.back()),
      bottom: controller.getStateSearch?ComponentApp.linearProgressBarApp(color: Get.theme.primaryColor): null,
    );
  }

  Widget _body() {
    return OfflineBuilder(
        child: Container(),
        connectivityBuilder: (BuildContext context,ConnectivityResult connectivity,Widget child,) {
          final connected = connectivity != ConnectivityResult.none;

          if (!connected) {
            // sin conexion a internet
            return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Padding(padding: EdgeInsets.all(12.0),child: Icon(Icons.wifi_off_rounded)),
                    Text('No hay internet'),
                  ],
              ));
          }
          return Center(
            child: ListView(
                padding:const EdgeInsets.all(0.0),
                shrinkWrap: true,
                children: [
                  controller.getproductDoesNotExist? Container(): WidgetSuggestionProduct(list: controller.getListProductsSuggestions),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        textField(),
                        const SizedBox(height: 50.0),
                        !controller.getStateSearch
                            ? FadeInRight(
                                child: button(
                                  icon: Icon(Icons.copy,color: controller.getButtonData.colorText),
                                  onPressed: () {
                                    // obtenemos los datos de porta papeles del dispositivo
                                    FlutterClipboard.paste().then((value) {
                                      // verificamos que sea numero valido
                                      if (controller.verifyIsNumber(value: value)) {
                                        controller.textEditingController.text = value;
                                        controller.queryProduct(id: value);
                                      } else {
                                        Get.snackbar('no se pudo copiar 👎','solo puedes ingresar un código valido que contengan números',margin: const EdgeInsets.all(12));
                                      }
                                    });
                                  },
                                  text: "Pegar de porta papeles",
                                  colorAccent:
                                      controller.getButtonData.colorText,
                                  colorButton:
                                      controller.getButtonData.colorButton,
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 12.0),
                        !controller.getStateSearch
                            ? FadeInRight(
                                child: button(
                                  icon: Icon(Icons.search,color: controller.getButtonData.colorText),
                                  onPressed: () => controller.textEditingController.text == ''? null: controller.queryProduct(id: controller.textEditingController.value.text),
                                  text: "Buscar",
                                  colorAccent:  controller.getButtonData.colorText,
                                  colorButton: controller.getButtonData.colorButton,
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 12.0),
                        !controller.getStateSearch
                            ? FadeInRight(
                                child: button(
                                  icon: Icon(Icons.qr_code_scanner_sharp,color: controller.getButtonData.colorText,),
                                  onPressed: scanBarcodeNormal,
                                  text: "Escanear código",
                                  colorAccent:controller.getButtonData.colorText,
                                  colorButton:controller.getButtonData.colorButton,
                                ),
                              )
                            : Container(),
                        const SizedBox(height: 12.0),
                        controller.getproductDoesNotExist
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 30),
                                child: Text(
                                  "El producto aún no existe 🙁, ayúdenos a registrar nuevos productos para que esta aplicación sea aún más útil para la comunidad",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: controller.getColorTextField),
                                ),
                              )
                            : Container(),
                        controller.getproductDoesNotExist
                            ? FadeInRight(
                                child: button(
                                  fontSize: 16,
                                  padding: 16,
                                  icon: const Text('💪'),
                                  onPressed: () {
                                    controller.toProductNew(
                                        id: controller
                                            .textEditingController.text);
                                  },
                                  text: "Agregar nuevo producto",
                                  colorAccent:
                                      controller.getButtonData.colorText,
                                  colorButton:
                                      controller.getButtonData.colorButton,
                                ),
                              )
                            : Container(),
                        // TODO: delete release
                        widgetForModerator,
                      ],
                    ),
                  ),
                ] //your list view content here
                ),
          );
        });
  }

  /* WIDGETS COMPONENT */
  Widget get widgetForModerator{
    return Column(
      children: [
        const SizedBox(height: 12.0),
                        FadeInRight(
                          child: button(
                            icon: Icon(controller.getListExcelToJson.isEmpty? Icons.file_present_sharp: Icons.view_list_sharp,
                                color: controller.getButtonData.colorText),
                            onPressed: () {
                              if (controller.productsToExelList.isEmpty) {
                                controller.selectedExcel();
                              } else {
                                controller.openDialogListExcel();
                              }
                            },
                            text: controller.productsToExelList.isEmpty
                                ? "Cargar Archivo Excel de productos"
                                : '${controller.productsToExelList.length} productos para agregar',
                            colorAccent: controller.getButtonData.colorText,
                            colorButton: controller.getButtonData.colorButton,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        FadeInRight(
                          child: button(
                            icon: Icon(controller.getListProductsVerified.isEmpty? Icons.change_circle_outlined: Icons.verified,color: controller.getButtonData.colorText),
                            onPressed: () {
                              if (controller.getListProductsVerified.isEmpty) {
                                controller.readProduct();
                              } else {
                                controller.openDialogListProductVerified(list: controller.getListProductsVerified);
                              }
                            },
                            text: controller.getListProductsVerified.isEmpty? "Cargar productos para verificar": '${controller.getListProductsVerified.length} productos para verificar',
                            colorAccent: controller.getButtonData.colorText,
                            colorButton: controller.getButtonData.colorButton,
                          ),
                        ),
                        const SizedBox(width: 50.0, height: 50.0), 
      ],
    );
  }
  Widget button(
      {required Widget icon,
      required String text,
      required dynamic onPressed,
      double fontSize = 0.0,
      double padding = 12,
      Color colorButton = Colors.purple,
      Color colorAccent = Colors.white,
      bool disable=false,
      }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            padding: EdgeInsets.all(padding),
            primary: colorButton,
            textStyle: TextStyle(
                color: colorAccent,
                fontSize: fontSize == 0.0 ? null : fontSize)),
        icon: icon,
        label: Text(text,style: TextStyle(color:disable?colorAccent.withOpacity(0.1):colorAccent, fontSize: fontSize == 0 ? null : fontSize)),
      ),
    );
  }

  Widget textField() {

    

    return TextField(
              controller: controller.textEditingController,
              keyboardType: const TextInputType.numberWithOptions(decimal: false),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[1234567890]'))],
              decoration: InputDecoration(
                fillColor: Colors.transparent,
                  suffixIcon: controller.textEditingController.value.text == ""?null:IconButton(onPressed: ()=>controller.clean(),icon: Icon(Icons.clear, color: controller.getColorTextField)),
                  filled: true,
                  hintText: 'ej. 77565440001743',
                  hintStyle: TextStyle(color: Get.theme.hintColor.withOpacity(0.3)),
                  enabledBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(16.0)),borderSide: BorderSide(color: controller.getColorTextField)),
                  border: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(16.0)),borderSide: BorderSide(color: controller.getColorTextField)),
                  focusedBorder: OutlineInputBorder(borderRadius: const BorderRadius.all(Radius.circular(16.0)),borderSide: BorderSide(color: controller.getColorTextField)),
                  labelStyle: TextStyle(color: controller.getColorTextField),
                  labelText: "Escribe el código de barra",
                  suffixStyle: TextStyle(color: controller.getColorTextField),
                ),
              style: TextStyle(fontSize: 20.0, color: controller.getColorTextField),
              textInputAction: TextInputAction.search,
              onSubmitted: (value) {
                //  Se llama cuando el usuario indica que ha terminado de editar el texto en el campo
                controller.queryProduct( id: controller.textEditingController.value.text);
              },
            );
  }
  


  /* FUNCTIONS */
  Future<void> scanBarcodeNormal() async {
    // Escanner Code - Abre en pantalla completa la camara para escanear
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      late String barcodeScanRes;
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      controller.textEditingController.text = barcodeScanRes;
      controller.queryProduct(id: barcodeScanRes);
    } on PlatformException {
      Get.snackbar('scanBarcode', 'Failed to get platform version');
    }
  }
}
