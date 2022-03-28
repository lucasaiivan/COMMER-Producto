import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/utils/dynamicTheme_lb.dart';
import 'package:producto/app/utils/functions.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../routes/app_pages.dart';

class ScanScreenView extends StatelessWidget {
  ScanScreenView({Key? key});

  final WelcomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return scaffoldScan(buildContext: context);
  }

  Scaffold scaffoldScan({required BuildContext buildContext}) {
    return Scaffold(
      appBar: appbar(),
      body: Center(
        child: body(context: buildContext),
      ),
    );
  }

  // WIDGETS VIEW
  PreferredSizeWidget appbar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      title: InkWell(
        onTap: () => showModalBottomSheetSelectAccount(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: <Widget>[
              Text(
                controller.getProfileAccountSelected.id == ''
                    ? "Seleccionar cuenta"
                    : controller.getProfileAccountSelected.name != ""
                        ? controller.getProfileAccountSelected.name
                        : "Mi catalogo",
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(color: Get.theme.textTheme.bodyText1!.color),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Get.theme.textTheme.bodyText1!.color,
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        IconButton(
            onPressed: showModalBottomSheetSetting,
            icon: Icon(Icons.view_headline,
                color: Get.theme.textTheme.bodyText1!.color)),
      ],
    );
  }

  Widget body({required BuildContext context}) {
    // var
    Color color = Theme.of(context).textTheme.bodyText1!.color ?? Colors.purple;
    Size size = Get.size;

    return GetBuilder<WelcomeController>(
      id: 'scanScreen',
      builder: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              splashColor: Get.theme.primaryColor,
              onTap: scanBarcodeNormal,
              child: ElasticIn(
                child: Container(
                  width: size.width*0.5,
                  height: size.width*0.5,
                  margin: const EdgeInsets.all(0.0),
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(width: 3, color: color),
                      borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: Image(
                      color: color,
                      image: AssetImage('assets/barcode.png'),
                      fit: BoxFit.contain),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 75),
              child: Text('Enfoque al código de barras del producto',
                  style: Get.theme.textTheme.subtitle1,
                  textAlign: TextAlign.center),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 40.0),
              child: TextButton(
                child: Text("Escanear",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20)),
                onPressed: scanBarcodeNormal,
              ),
            ),
            WidgetSuggestionProduct(
                list: controller.getListSuggestedProducts, searchButton: true),
          ],
        );
      },
    );
  }

  // BottomSheet - Getx
  void showModalBottomSheetSelectAccount() {
    Widget widget = controller.getManagedAccountData.length == 0
        ? WidgetButtonListTile().buttonListTileCrearCuenta()
        : ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            shrinkWrap: true,
            itemCount: controller.getManagedAccountData.length,
            itemBuilder: (BuildContext context, int index) {
              return WidgetButtonListTile().buttonListTileItemCuenta(
                  perfilNegocio: controller.getManagedAccountData[index],
                  adminPropietario:
                      controller.getManagedAccountData[index].id ==
                          controller.getUserAccountAuth.uid);
            },
          );

    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }

  // ShowModalBottomSheet
  void showModalBottomSheetSetting() {
    Widget widget = ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 15.0),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Icon(Get.theme.brightness != Brightness.light
              ? Icons.brightness_high
              : Icons.brightness_3,color: Utils.getRandomColor()[300]),
          title: Text(Get.theme.brightness == Brightness.light
              ? 'Aplicar de tema oscuro'
              : 'Aplicar de tema claro'),
          onTap: () {
            ThemeService.switchTheme();
            Get.back();
          },
        ),
        Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Icon(Icons.logout,color:  Utils.getRandomColor()[300],),
          title: Text('Cerrar sesión'),
          onTap: controller.showDialogCerrarSesion,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Contacto",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Divider(
                endIndent: 12.0,
                indent: 12.0,
                height: 2.0,
                thickness: 2.0,
              ),
            ),
          ],
        ),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: FaIcon(FontAwesomeIcons.instagram,color:  Utils.getRandomColor()[300],)),
          title: Text('Instagram'),
          subtitle: Text('Déjanos una sugerencia'),
          onTap: () async {
            String url = "https://www.instagram.com/logica.booleana.producto/";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: FaIcon(FontAwesomeIcons.googlePlay,color:  Utils.getRandomColor()[300],)),
          title: Text(
            'Califícanos ⭐',
          ),
          onTap: () async {
            String url =
                "https://play.google.com/store/apps/details?id=com.logicabooleana.commer.producto";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.share_outlined,color:  Utils.getRandomColor()[300],)),
          title: Text(
            'Cuentale a un amigo',
          ),
          onTap: () async {
            String url =
                "https://play.google.com/store/apps/details?id=com.logicabooleana.commer.producto";
            Share.share(
                'Hey uso esta gran aplicación que te permite comparar los precios 🧐 $url');
          },
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Información legal",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: Divider(
                endIndent: 12.0,
                indent: 12.0,
                height: 2.0,
                thickness: 2.0,
              ),
            ),
          ],
        ),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.assignment_outlined,color:  Utils.getRandomColor()[300],)),
          title: Text('Términos y condiciones de uso'),
          onTap: () async {
            String url = "https://sites.google.com/view/producto-app/t%C3%A9rminos-y-condiciones-de-uso/";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0),
              child: Icon(Icons.privacy_tip_outlined,color:  Utils.getRandomColor()[300],)),
          title: Text('Política de privacidad'),
          onTap: () async {
            String url = "https://sites.google.com/view/producto-app/pol%C3%ADticas-de-privacidad";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
        SizedBox(width: 50.0, height: 50.0),
      ],
    );

    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      ignoreSafeArea: true,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Function
  Future<void> scanBarcodeNormal() async {
    /* inicializamos en un método asincrónico */

    String barcodeScanRes = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // Si el widget se eliminó del árbol mientras la plataforma asincrónica
    // el mensaje estaba en vuelo, queremos descartar la respuesta en lugar de llamar
    // setState para actualizar nuestra apariencia inexistente.
    //if (!mounted) return;
    bool coincidencia = false;
    late ProductCatalogue productoSelected;

    if (controller.getCataloProducts.length != 0) {
      for (ProductCatalogue producto in controller.getCataloProducts) {
        if (producto.code == barcodeScanRes) {
          productoSelected = producto;
          coincidencia = true;
          break;
        }
      }
    }

    if (coincidencia) {
      Get.toNamed(Routes.PRODUCT, arguments: {'product': productoSelected});
    } else {
      if (barcodeScanRes.toString() != "") {
        if (barcodeScanRes.toString() != "-1") {
          Get.toNamed(Routes.PRODUCTS_SEARCH,
              arguments: {'id': barcodeScanRes});
        }
      }
    }
  }
}
