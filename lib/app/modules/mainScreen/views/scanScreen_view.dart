import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
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
        child: body(),
      ),
    );
  }

  // WIDGETS VIEW
  PreferredSizeWidget appbar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      iconTheme: Get.theme.iconTheme
          .copyWith(color: Get.theme.textTheme.bodyText1!.color),
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
                  style: TextStyle(color: Get.theme.textTheme.bodyText1!.color),
                  overflow: TextOverflow.fade,
                  softWrap: false),
              Icon(Icons.keyboard_arrow_down)
            ],
          ),
        ),
      ),
      actions: <Widget>[
        Container(
          padding: EdgeInsets.all(12.0),
          child: InkWell(
            customBorder: new CircleBorder(),
            splashColor: Colors.red,
            onTap: () {
              showModalBottomSheetSetting();
            },
            child: Hero(
              tag: "fotoperfiltoolbar",
              child: CircleAvatar(
                radius: 17,
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10000.0),
                    child: CachedNetworkImage(
                      width: 35.0,
                      height: 35.0,
                      fadeInDuration: Duration(milliseconds: 200),
                      fit: BoxFit.cover,
                      imageUrl:
                          controller.getUserAccountAuth.photoURL ?? 'https',
                      placeholder: (context, url) => FadeInImage(
                          image: AssetImage("assets/loading.gif"),
                          placeholder: AssetImage("assets/loading.gif")),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            controller.getUserAccountAuth.displayName
                                .toString()
                                .substring(0, 1),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget body() {

    // var 
    Color color = Get.theme.brightness == Brightness.dark
        ? Colors.white54
        : Colors.black38;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        InkWell(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
          splashColor: Get.theme.primaryColor,
          onTap: () => scanBarcodeNormal(),
          child: Container(
            width: 200,height: 200,
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.all(30.0),
            decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(width: 0.5, color: color),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Image(
                color: color,
                height: 200.0,
                width: 200.0,
                image: AssetImage('assets/barcode.png'),
                fit: BoxFit.contain),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40.0),
          child: Text("Escanea un producto para conocer su precio",
              style: TextStyle(
                  fontFamily: "POPPINS_FONT",
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 24.0),
              textAlign: TextAlign.center),
        ),
        Obx(() => widgetSuggestions(list: controller.getListSuggestedProducts)),
      ],
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () =>
                  Get.toNamed(Routes.PRODUCTS_SEARCH, arguments: {'id': ''}),
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FadeInLeft(
                  child: CircleAvatar(
                      child: CircleAvatar(
                          child:
                              Icon(Icons.search, color: Get.theme.primaryColor),
                          radius: 24,
                          backgroundColor: Colors.white),
                      radius: 26,
                      backgroundColor: Get.theme.primaryColor),
                ),
              ),
            ),
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: InkWell(
                    onTap: () => controller.toProductView(porduct: list[0]),
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FadeInRight(
                        child: CircleAvatar(
                            child: CircleAvatar(
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                      imageUrl: list[0].image,
                                      fit: BoxFit.cover),
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
                    onTap: () => controller.toProductView(porduct: list[1]),
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FadeInRight(
                        child: CircleAvatar(
                            child: CircleAvatar(
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                      imageUrl: list[1].image,
                                      fit: BoxFit.cover),
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
                    onTap: () => controller.toProductView(porduct: list[2]),
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: FadeInRight(
                        child: CircleAvatar(
                            child: CircleAvatar(
                                child: ClipRRect(
                                  child: CachedNetworkImage(
                                      imageUrl: list[2].image,
                                      fit: BoxFit.cover),
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
        ),
      ],
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
          leading: Icon(Icons.logout),
          title: Text('Cerrar sesión'),
          onTap: controller.showDialogCerrarSesion,
        ),
        Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Icon(Get.theme.brightness != Brightness.light
              ? Icons.brightness_high
              : Icons.brightness_3),
          title: Text(Get.theme.brightness == Brightness.light
              ? 'Aplicar de tema oscuro'
              : 'Aplicar de tema claro'),
          onTap: WidgetsUtilsApp().switchTheme(),
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
              child: FaIcon(FontAwesomeIcons.instagram)),
          title: Text('Instagram'),
          subtitle: Text('Contacta con el desarrollador 👨‍💻'),
          onTap: () async {
            String url = "https://www.instagram.com/logica.booleana/";
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
              child: FaIcon(FontAwesomeIcons.googlePlay)),
          title: Text(
            'Déjanos un comentario o sugerencia',
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
              child: FaIcon(FontAwesomeIcons.blogger)),
          title: Text(
            'Más información',
          ),
          onTap: () async {
            String url = "https://logicabooleanaapps.blogspot.com/";
            /* if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            } */
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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
