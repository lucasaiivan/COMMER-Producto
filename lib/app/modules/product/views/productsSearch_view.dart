import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/product/controllers/productsSearch_controller.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import 'package:flutter_offline/flutter_offline.dart';

class ProductsSearch extends GetView<ControllerProductsSearch> {
  const ProductsSearch({Key? key}) : super(key: key);

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
      title: Text(
        controller.getproductDoesNotExist ? "Sin resultados" : "Buscar",
        style: TextStyle(color: controller.getColorTextField),
      ),
      leading: IconButton(
          icon: Icon(Icons.arrow_back, color: controller.getColorTextField),
          onPressed: () => Get.back()),
      bottom: controller.getStateSearch
          ? linearProgressBarApp(color: Get.theme.primaryColor)
          : null,
    );
  }

  Widget _body() {
    return OfflineBuilder(
        child: Container(),
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final connected = connectivity != ConnectivityResult.none;

          if (!connected) {
            return Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Icon(Icons.wifi_off_rounded),
                ),
                Text('No hay internet'),
              ],
            ));
          }
          return Center(
            child: ListView(
                padding: EdgeInsets.all(0.0),
                shrinkWrap: true,
                children: [
                  controller.getproductDoesNotExist
                      ? Container()
                      : WidgetSuggestionProduct(
                          list: controller.getListProductsSuggestions),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        textField(),
                        SizedBox(height: 50.0),
                        !controller.getStateSearch
                            ? FadeInRight(
                              child: button(
                                  icon: Icon(Icons.copy,
                                      color: controller.getButtonData.colorText),
                                  onPressed: () {
                                    // obtenemos los datos de porta papeles del dispositivo
                                    FlutterClipboard.paste().then((value) {
                                      // verificamos que sea numero valido
                                      if (controller.verifyIsNumber(
                                          value: value)) {
                                        controller.textEditingController.text =
                                            value;
                                        controller.queryProduct(id: value);
                                      } else {
                                        Get.snackbar('no se pudo copiar 👎',
                                            'solo puedes ingresar un código valido que contengan números',
                                            margin: EdgeInsets.all(12));
                                      }
                                    });
                                  },
                                  text: "Pegar",
                                  colorAccent: controller.getButtonData.colorText,
                                  colorButton:
                                      controller.getButtonData.colorButton,
                                ),
                            )
                            : Container(),
                        SizedBox(height: 12.0),
                        !controller.getStateSearch
                            ? FadeInRight(
                              child: button(
                                  icon: Icon(Icons.search,
                                      color: controller.getButtonData.colorText),
                                  onPressed: () =>
                                      controller.textEditingController.text == ''
                                          ? null
                                          : controller.queryProduct(
                                              id: controller.textEditingController
                                                  .value.text),
                                  text: "Buscar",
                                  colorAccent: controller.getButtonData.colorText,
                                  colorButton: controller
                                              .textEditingController.value.text ==
                                          ''
                                      ? Colors.grey
                                      : controller.getButtonData.colorButton,
                                ),
                            )
                            : Container(),
                        SizedBox(height: 12.0),
                        !controller.getStateSearch
                            ? FadeInRight(
                              child: button(
                                  icon: Image(
                                      color: controller.getButtonData.colorText,
                                      height: 20.0,
                                      width: 20.0,
                                      image: AssetImage('assets/barcode.png'),
                                      fit: BoxFit.contain),
                                  onPressed: scanBarcodeNormal,
                                  text: "Escanear código",
                                  colorAccent: controller.getButtonData.colorText,
                                  colorButton:
                                      controller.getButtonData.colorButton,
                                ),
                            )
                            : Container(),
                        SizedBox(height: 12.0),
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
                                  icon: Text('💪'),
                                  onPressed: () {
                                    controller.toProductNew(
                                        id: controller
                                            .textEditingController.text);
                                  },
                                  text: "Agregar nuevo producto",
                                  colorAccent: controller.getButtonData.colorText,
                                  colorButton:
                                      controller.getButtonData.colorButton,
                                ),
                            )
                            : Container(),
                        // TODO: delete release
                        SizedBox(height: 12.0),
                        FadeInRight(
                          child: button(
                            icon: Icon(
                                controller.getListExcelToJson.length == 0
                                    ? Icons.file_present_sharp
                                    : Icons.view_list_sharp,
                                color: controller.getButtonData.colorText),
                            onPressed: () {
                              if (controller.getListExcelToJson.length == 0) {
                                controller.convert();
                              } else {
                                controller.openDialogListExcel();
                              }
                            },
                            text: controller.getListExcelToJson.length == 0
                                ? "Cargar Archivo Excel de productos"
                                : 'ver lista de excel',
                            colorAccent: controller.getButtonData.colorText,
                            colorButton: controller.getButtonData.colorButton,
                          ),
                        ),
                        SizedBox(width: 50.0, height: 50.0),
                      ],
                    ),
                  ),
                ] //your list view content here
                ),
          );
        });
  }

  /* WIDGETS COMPONENT */

  Widget button(
      {required Widget icon,
      required String text,
      required dynamic onPressed,
      double fontSize = 0.0,
      double padding = 12,
      Color colorButton = Colors.purple,
      Color colorAccent = Colors.white}) {
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
    label: Text(text,
        style: TextStyle(
            color: colorAccent, fontSize: fontSize == 0 ? null : fontSize)),
      ),
    );
  }

  Widget textField() {
    return TextField(
      controller: controller.textEditingController,
      keyboardType: TextInputType.numberWithOptions(decimal: false),
      inputFormatters: [
        FilteringTextInputFormatter.allow(new RegExp('[1234567890]'))
      ],
      onChanged: (value) {
        //controller.setCodeBar = value;
        controller.updateAll();
      },
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            controller.clean();
          },
          icon: controller.textEditingController.value.text != ""
              ? Icon(Icons.clear, color: controller.getColorTextField)
              : Container(),
        ),
        hintText: 'ej. 77565440001743',
        hintStyle: TextStyle(color: Get.theme.hintColor.withOpacity(0.3)),
        enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: controller.getColorTextField)),
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: controller.getColorTextField)),
        focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(color: controller.getColorTextField)),
        labelStyle: TextStyle(color: controller.getColorTextField),
        labelText: "Escribe el código de barra",
        suffixStyle: TextStyle(color: controller.getColorTextField),
      ),
      style: TextStyle(fontSize: 20.0, color: controller.getColorTextField),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        //  Se llama cuando el usuario indica que ha terminado de editar el texto en el campo
        controller.queryProduct(
            id: controller.textEditingController.value.text);
      },
    );
  }

  Widget widgetSuggestions({required List<Product> list}) {
    if (list.length == 0) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("sugerencias para ti"),
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: InkWell(
                onTap: () => controller.toProductView(
                    porduct: list[0].convertProductCatalogue()),
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FadeInRight(
                    child: CircleAvatar(
                        child: CircleAvatar(
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                  imageUrl: list[0].image, fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            radius: 24),
                        radius: 26,
                        backgroundColor: Get.theme.primaryColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: InkWell(
                onTap: () => controller.toProductView(
                    porduct: list[1].convertProductCatalogue()),
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FadeInRight(
                    child: CircleAvatar(
                        child: CircleAvatar(
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                  imageUrl: list[1].image, fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            radius: 24),
                        radius: 26,
                        backgroundColor: Get.theme.primaryColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 80),
              child: InkWell(
                onTap: () => controller.toProductView(
                    porduct: list[2].convertProductCatalogue()),
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FadeInRight(
                    child: CircleAvatar(
                        child: CircleAvatar(
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                  imageUrl: list[2].image, fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            radius: 24),
                        radius: 26,
                        backgroundColor: Get.theme.primaryColor),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 120),
              child: InkWell(
                onTap: () => controller.toProductView(
                    porduct: list[3].convertProductCatalogue()),
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FadeInRight(
                    child: CircleAvatar(
                        child: CircleAvatar(
                            child: ClipRRect(
                              child: CachedNetworkImage(
                                  imageUrl: list[3].image, fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            radius: 24),
                        radius: 26,
                        backgroundColor: Get.theme.primaryColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
