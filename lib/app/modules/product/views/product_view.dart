import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/modules/product/controllers/product_controller.dart';
import 'package:producto/app/services/database.dart';
import 'package:producto/app/utils/functions.dart';
import 'package:producto/app/utils/widgets_utils_app.dart' as utilsWidget;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../routes/app_pages.dart';

class Product extends GetView<ProductController> {
  Product({Key? key}) : super(key: key);

  // controllers
  final WelcomeController welcomeController = Get.find<WelcomeController>();
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context: context),
      body: body(),
    );
  }

  // WIDGETS VIEWS
  PreferredSizeWidget appbar({required BuildContext context}) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: Theme.of(context).textTheme.bodyText1!.color),
      title: Obx(() => Row(
            children: <Widget>[
              controller.getProduct.verified == true
                  ? Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: new Image.asset('assets/icon_verificado.png',
                          width: 18.0, height: 18.0))
                  : new Container(),
              Expanded(
                child: Text(controller.getMark.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Theme.of(context).textTheme.bodyText1!.color)),
              ),
            ],
          )),
      actions: welcomeController.getProfileAccountSelected.id == ''
          ? []
          : [
              IconButton(
                padding: EdgeInsets.all(12.0),
                icon: Icon(Icons.share),
                onPressed: () {
                  showGeneralDialog(
                      context: context,
                      barrierDismissible: true,
                      barrierLabel: MaterialLocalizations.of(context)
                          .modalBarrierDismissLabel,
                      barrierColor: Colors.black45,
                      transitionDuration: const Duration(milliseconds: 200),
                      pageBuilder: (BuildContext buildContext,
                          Animation animation, Animation secondaryAnimation) {
                        Timer(Duration(seconds: 1), () async {
                          // note: La imagen capturada puede verse pixelada. Puede solucionar este problema configurando el valor de pixelRatio
                          double pixelRatio =
                              MediaQuery.of(context).devicePixelRatio;
                          // Captura de widgets
                          await screenshotController
                              .capture(
                                  delay: const Duration(milliseconds: 1),
                                  pixelRatio: pixelRatio)
                              .then((image) async {
                            if (image != null) {
                              final directory =
                                  await getApplicationDocumentsDirectory();
                              final imagePath =
                                  await File('${directory.path}/image.png')
                                      .create();
                              await imagePath.writeAsBytes(image);

                              /// Share Plugin
                              await Share.shareFiles([imagePath.path]);
                              Get.back();
                            }
                          });
                        });

                        // Get available height and width of the build area of this widget. Make a choice depending on the size.
                        var height = MediaQuery.of(buildContext).size.height;
                        var width = MediaQuery.of(buildContext).size.width;

                        return Screenshot(
                          controller: screenshotController,
                          child: viewProducto(height: height, width: width),
                        );
                      });
                },
              ),
              IconButton(
                padding: EdgeInsets.all(12.0),
                icon: Icon(
                    welcomeController.isCatalogue(id: controller.getProduct.id)
                        ? Icons.edit
                        : Icons.add_box),
                onPressed: () {
                  controller.toProductEdit();
                },
              ),
            ],
    );
  }

  Widget body() {
    return ExpandableBottomSheet(
      onIsExtendedCallback: () => print('extended'),
      background: background(),
      persistentHeader: persistentHeader(
          colorBackground: Get.theme.cardColor, colorText: Colors.white),
      expandableContent: expandableContent(
          colorBackground: Get.theme.cardColor, colorText: Colors.white),
    );
  }

  // WIDGETS VIEWS
  Widget viewProducto({required double height, required double width}) {
    Color colorText = Get.theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.90)
        : Colors.black.withOpacity(0.90);
    Color colorCard = Get.theme.brightness == Brightness.dark
        ? Get.theme.primaryColorDark
        : Colors.white;

    // vista para la captura de la pantalla
    return SafeArea(
      child: Scaffold(
          body: Container(
        color: Get.theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // nombre del negocio
            Center(
                child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(welcomeController.getProfileAccountSelected.name,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: Get.theme.brightness == Brightness.dark
                          ? Colors.white.withOpacity(0.90)
                          : Colors.black.withOpacity(0.90))),
            )),
            // vista del producto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: width * 0.60,
                      width: width * 0.60,
                      child: WidgetImagen(
                          producto: controller.getProduct,
                          marca: controller.getMark,
                          borderRadius: 30.0)),
                  Padding(
                    padding: EdgeInsets.all(width * 0.20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        controller.getProduct.description != ""
                            ? Text(
                                controller.getProduct.description,
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  color: colorText,
                                  height: 1,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              )
                            : Container(),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              controller.getProduct.salePrice != 0.0
                                  ? Text(
                                      Publicaciones.getFormatoPrecio(
                                          monto:
                                              controller.getProduct.salePrice),
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 40,
                                          fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.end)
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget widgetDescripcion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12, left: 12, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          welcomeController.isCatalogue(id: controller.getProduct.id)
              ? Wrap(
                  spacing: 4.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  direction: Axis.horizontal, // main axis (rows or columns)
                  children: <Widget>[
                    controller.getCategory.name != ""
                        ? Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            avatar: CircleAvatar(
                                backgroundColor: Colors.grey.shade800,
                                child: Text(
                                    controller.getCategory.name.substring(0, 1),
                                    style: TextStyle(color: Colors.grey))),
                            label: Text(controller.getCategory.name,
                                overflow: TextOverflow.ellipsis),
                          )
                        : Container(),
                    controller.getSubcategory.name != ""
                        ? Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Text(
                                  controller.getSubcategory.name
                                      .substring(0, 1),
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            label: Text(
                              controller.getSubcategory.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Container(),
                  ],
                )
              : Container(),
          controller.getProduct.description != ""
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(controller.getProduct.description,
                      style: TextStyle(
                          height: 1,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                )
              : Container(),
          controller.getProduct.code != "" ? SizedBox(height: 5) : Container(),
          controller.getProduct.code != ""
              ? Opacity(
                  opacity: 0.8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.qr_code_2_rounded, size: 14),
                      SizedBox(width: 5),
                      Text(controller.getProduct.code,
                          style: TextStyle(
                              height: 1,
                              fontSize: 12,
                              fontWeight: FontWeight.normal)),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget background() {
    return Builder(builder: (contextBuilder) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            imageViewCard(),
            widgetDescripcion(contextBuilder),
            otherProductsCatalogueListHorizontal(),
            otherBrandProductsListHorizontal(),
            const SizedBox(height: 200.0, width: 120.0),
          ],
        ),
      );
    });
  }

  Widget persistentHeader(
      {required Color colorBackground, required Color colorText}) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: colorBackground,
        margin: EdgeInsets.all(0),
        padding:
            EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0, top: 12.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              welcomeController.isCatalogue(id: controller.getProduct.id)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.getProduct.salePrice != 0.0
                            ? Column(
                                children: [
                                  Text(
                                      Publicaciones.getFormatoPrecio(
                                          monto:
                                              controller.getProduct.salePrice),
                                      style: TextStyle(
                                          color: colorText,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end),
                                  Row(
                                    children: [
                                      controller.getProduct.purchasePrice != 0.0
                                          ? Text(
                                              sProcentaje(
                                                  precioCompra: controller
                                                      .getProduct.purchasePrice,
                                                  precioVenta: controller
                                                      .getProduct.salePrice),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold))
                                          : Container(),
                                      controller.getProduct.purchasePrice != 0.0
                                          ? Text(" > ",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12.0))
                                          : Container(),
                                      controller.getProduct.purchasePrice != 0.0
                                          ? Text(
                                              Publicaciones.sGanancia(
                                                  precioCompra: controller
                                                      .getProduct.purchasePrice,
                                                  precioVenta: controller
                                                      .getProduct.salePrice),
                                              style: TextStyle(
                                                  color: controller.getProduct
                                                              .purchasePrice <
                                                          controller.getProduct
                                                              .salePrice
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold))
                                          : Container(),
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Publicaciones.getFechaPublicacion(
                                    controller.getProduct.upgrade.toDate(),
                                    Timestamp.now().toDate())
                                .toLowerCase(),
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                color: colorText.withOpacity(0.5)),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              Icon(Icons.keyboard_arrow_up, color: colorText.withOpacity(0.5)),
              Text(
                'Deslice hacia arriba para ver los últimos precios publicados',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorText.withOpacity(0.5)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget expandableContent(
      {required Color colorBackground, required Color colorText}) {
    return Obx(() => ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        child: Container(
            margin: EdgeInsets.all(0),
            color: colorBackground,
            padding: EdgeInsets.only(
                bottom: 12.0, left: 12.0, right: 12.0, top: 12.0),
            child: ultimosPreciosView())));
  }
  // WIDGETS COMPONENTS

  Widget ultimosPreciosView() {
    if (controller.getListPricesForProduct.length != 0) {
      Color colorText = Colors.white;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          controller.getListPricesForProduct.length == 0
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0),
                  child: Text(
                    "No se registró ningún precio para este producto",
                    style: TextStyle(fontSize: 20.0, color: colorText),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 0.16),
            shrinkWrap: true,
            itemCount: controller.getListPricesForProduct.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                    leading: controller
                                    .getListPricesForProduct[index].idAccount ==
                                "" ||
                            controller.getListPricesForProduct[index]
                                    .imageAccount ==
                                ""
                        ? CircleAvatar(
                            backgroundColor: Colors.grey,
                            radius: 24.0,
                          )
                        : CachedNetworkImage(
                            imageUrl: controller
                                .getListPricesForProduct[index].imageAccount,
                            placeholder: (context, url) => const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 24.0,
                            ),
                            imageBuilder: (context, image) => CircleAvatar(
                              backgroundImage: image,
                              radius: 24.0,
                            ),
                            errorWidget: (context, url, error) =>
                                const CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 24.0,
                            ),
                          ),
                    title: Text(
                      Publicaciones.getFormatoPrecio(
                          monto:
                              controller.getListPricesForProduct[index].price),
                      style: TextStyle(
                          color: colorText,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          Publicaciones.getFechaPublicacion(
                                  controller.getListPricesForProduct[index].time
                                      .toDate(),
                                  new DateTime.now())
                              .toLowerCase(),
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              fontStyle: FontStyle.normal, color: colorText),
                        ),
                        controller.getListPricesForProduct[index].town != ""
                            ? Text(
                                "En " +
                                    controller
                                        .getListPricesForProduct[index].town
                                        .toString(),
                                style: TextStyle(
                                    color: colorText,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text("Ubicación desconocido",
                                style: TextStyle(
                                    color: colorText,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0)),
                      ],
                    ),
                    onTap: () {},
                  ),
                  SizedBox(
                    height: 5.0,
                  )
                ],
              );
              return FutureBuilder(
                  future: Database.readProfileBusinessModelFuture(
                      controller.getListPricesForProduct[index].idAccount),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ProfileAccountModel perfilNegocio =
                          ProfileAccountModel.fromDocumentSnapshot(
                              documentSnapshot:
                                  snapshot.data as DocumentSnapshot);
                      return Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                            leading: controller.getListPricesForProduct[index]
                                            .idAccount ==
                                        "" ||
                                    perfilNegocio.image == "default"
                                ? CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    radius: 24.0,
                                    child: Text(
                                        perfilNegocio.name.substring(0, 1),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: colorText,
                                            fontWeight: FontWeight.bold)),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: perfilNegocio.image,
                                    placeholder: (context, url) =>
                                        const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 24.0,
                                    ),
                                    imageBuilder: (context, image) =>
                                        CircleAvatar(
                                      backgroundImage: image,
                                      radius: 24.0,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const CircleAvatar(
                                      backgroundColor: Colors.grey,
                                      radius: 24.0,
                                    ),
                                  ),
                            title: Text(
                              Publicaciones.getFormatoPrecio(
                                  monto: controller
                                      .getListPricesForProduct[index].price),
                              style: TextStyle(
                                  color: colorText,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  Publicaciones.getFechaPublicacion(
                                          controller
                                              .getListPricesForProduct[index]
                                              .time
                                              .toDate(),
                                          new DateTime.now())
                                      .toLowerCase(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: colorText),
                                ),
                                controller.getListPricesForProduct[index]
                                            .town !=
                                        ""
                                    ? Text(
                                        "En " +
                                            controller
                                                .getListPricesForProduct[index]
                                                .town
                                                .toString(),
                                        style: TextStyle(
                                            color: colorText,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text("Ubicación desconocido",
                                        style: TextStyle(
                                            color: colorText,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0)),
                              ],
                            ),
                            onTap: () {},
                          ),
                          SizedBox(
                            height: 5.0,
                          )
                        ],
                      );
                    } else {
                      return WidgetsLoad();
                    }
                  });
            },
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Text(
          "Cargando ultimos precios registrados",
          style: TextStyle(fontSize: 20.0),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget imageViewCard({double borderRadius = 14}) {
    return Card(
      margin: EdgeInsets.all(0.0),
      elevation: 0.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Hero(
        tag: controller.getProduct.id,
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            CachedNetworkImage(
              width: Get.width,
              height: Get.width,
              fadeInDuration: Duration(milliseconds: 200),
              fit: BoxFit.cover,
              imageUrl: controller.getProduct.image,
              placeholder: (context, url) => FadeInImage(
                image: AssetImage("assets/loading.gif"),
                placeholder: AssetImage("assets/loading.gif"),
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey,
                width: Get.width,
                height: Get.width,
                child: Center(
                  child: Text(
                    controller.getProduct.description.substring(0, 1),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.25),
                  ),
                ),
              ),
            ),
            Obx(() => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Get.theme.scaffoldBackgroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: utilsWidget.viewCircleImage(
                          size: 60,
                          url: controller.getMark.image,
                          texto: controller.getMark.name),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget otherBrandProductsListHorizontal() {
    // mostramos en un lista horizontal otros productos de la misma marca
    return Obx(() => controller.getListOthersProductsForMark.length == 0
        ? Container()
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                child: Text(
                    controller.getMark.name == ''
                        ? 'Otros'
                        : controller.getMark.name,
                    style: TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.normal)),
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              ),
              Container(
                height: 220,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.getListOthersProductsForMark.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(
                          bottom: 8,
                          top: 8,
                          left: index == 0 ? 12 : 0,
                          right:
                              controller.getListOthersProductsForMark.length ==
                                      (index + 1)
                                  ? 12
                                  : 0),
                      child: ProductoItem(
                          producto: controller
                              .getListOthersProductsForMark[index]
                              .convertProductCatalogue()),
                    );
                  },
                ),
              ),
            ],
          ));
  }

  Widget otherProductsCatalogueListHorizontal() {
    // mostramos otros productos del cátalogo de la misma cátegoria
    return Obx(
        () => controller.getListOthersProductsForCategoryCatalogue.length == 0
            ? Container()
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Divider(
                        height: 6,
                        thickness: 1,
                        color: Colors.grey.withOpacity(0.1)),
                  ),
                  Padding(
                    child: Text(controller.getCategory.name,
                        style: TextStyle(fontSize: 16.0)),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  ),
                  Container(
                    height: 250,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: controller
                          .getListOthersProductsForCategoryCatalogue.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: 8,
                              top: 8,
                              left: index == 0 ? 12 : 0,
                              right: controller
                                          .getListOthersProductsForCategoryCatalogue
                                          .length ==
                                      (index + 1)
                                  ? 12
                                  : 0),
                          child: ProductoCatalogueItem(
                              producto: controller
                                      .getListOthersProductsForCategoryCatalogue[
                                  index]),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }

  // FUNCTIONS
  String sProcentaje(
      {required double precioCompra, required double precioVenta}) {
    double porcentaje = 0.0;
    double ganancia = 0.0;
    if (precioCompra != 0.0) {
      ganancia = precioVenta - precioCompra;
    }
    porcentaje = ganancia / precioCompra * 100;
    return "%${porcentaje.round()}";
  }
}

class WidgetsLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color color = Colors.grey;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, radius: 24.0),
        dense: true,
        title: Text("        ",
            style: TextStyle(fontSize: 30.0, backgroundColor: Colors.grey)),
        trailing: Column(
          children: <Widget>[
            Text("              ", style: TextStyle(backgroundColor: color)),
            SizedBox(
              height: 5.0,
            ),
            Text("              ", style: TextStyle(backgroundColor: color)),
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

class ProductoCatalogueItem extends StatelessWidget {
  final ProductCatalogue producto;
  ProductoCatalogueItem({required this.producto});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 160,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: contentImage()),
                contentInfo(),
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.offNamed(Routes.PRODUCT,
                      arguments: {'product': producto},
                      preventDuplicates: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentImage() {
    return producto.image != ""
        ? CachedNetworkImage(
            fadeInDuration: Duration(milliseconds: 200),
            fit: BoxFit.cover,
            imageUrl: producto.image,
            placeholder: (context, url) => FadeInImage(
                fit: BoxFit.cover,
                image: AssetImage("assets/loading.gif"),
                placeholder: AssetImage("assets/loading.gif")),
            errorWidget: (context, url, error) => Container(
                color: Colors.grey[100],
                child: Center(
                  child: Text(
                    producto.description.substring(0,4),
                    style: TextStyle(fontSize: 24.0,color: Colors.grey),
                  ),
                ),
              ),
          )
        : Container(color: Color.fromARGB(255, 43, 45, 57));
  }

  Widget contentInfo() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(producto.description,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: Colors.grey),
              overflow: TextOverflow.fade,
              softWrap: false),
          Text(Publicaciones.getFormatoPrecio(monto: producto.salePrice),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.black),
              overflow: TextOverflow.fade,
              softWrap: false),
        ],
      ),
    );
  }
}

class ProductoItem extends StatelessWidget {
  final ProductCatalogue producto;
  ProductoItem({required this.producto});

  // controllers
  final WelcomeController welcomeController = Get.find<WelcomeController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 160.0,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: contentImage()),
                contentInfo(),
              ],
            ),
            welcomeController.isCatalogue(id: producto.id)
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Icon(Icons.check, color: Colors.white),
                          radius: 14,
                        )),
                  )
                : Container(),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Get.offNamed(Routes.PRODUCT,
                      arguments: {'product': producto},
                      preventDuplicates: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget contentImage() {
    return producto.image != ""
        ? CachedNetworkImage(
            fadeInDuration: Duration(milliseconds: 200),
            fit: BoxFit.cover,
            imageUrl: producto.image,
            placeholder: (context, url) => FadeInImage(
                placeholderErrorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[100],
                    child: Center(
                      child: Text(
                        producto.description.substring(0, 3),
                        style: TextStyle(fontSize: 24.0, color: Colors.grey),
                      ),
                    ),
                  );
                },
                fit: BoxFit.cover,
                image: AssetImage("assets/loading.gif"),
                placeholder: AssetImage("assets/loading.gif")),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[100],
              child: Center(
                child: Text(
                  producto.description.substring(0, 3),
                  style: TextStyle(fontSize: 24.0, color: Colors.grey),
                ),
              ),
            ),
          )
        : Container(color: Colors.grey[100]);
  }

  Widget contentInfo() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(producto.description,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: Colors.grey),
              overflow: TextOverflow.fade,
              softWrap: false),
        ],
      ),
    );
  }
}

class WidgetImagen extends StatelessWidget {
  const WidgetImagen({
    required this.producto,
    required this.marca,
    this.borderRadius = 20.0,
  });

  final ProductCatalogue producto;
  final Mark marca;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(0.0),
      elevation: 0.0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      child: Hero(
        tag: producto.id,
        child: Stack(
          children: [
            CachedNetworkImage(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              fadeInDuration: Duration(milliseconds: 200),
              fit: BoxFit.cover,
              imageUrl: producto.image,
              placeholder: (context, url) => FadeInImage(
                image: AssetImage("assets/loading.gif"),
                placeholder: AssetImage("assets/loading.gif"),
                fit: BoxFit.cover,
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(
                    producto.description.substring(0, 3),
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.25),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Chip(
                avatar: viewCircleImage(
                    url: marca.image, texto: marca.name, size: 20),
                label: Text(marca.name),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget viewCircleImage(
      {required String url, required String texto, double size = 85.0}) {
    if (texto == '') {
      texto = 'default';
    }
    return Container(
      width: size,
      height: size,
      child: url == ""
          ? CircleAvatar(
              backgroundColor: Colors.black26,
              radius: size,
              child: Text(texto.substring(0, 1),
                  style: TextStyle(
                      fontSize: size / 2,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            )
          : CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => CircleAvatar(
                backgroundColor: Colors.black26,
                radius: size,
                child: Text(texto.substring(0, 1),
                    style: TextStyle(
                        fontSize: size / 2,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: size,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
    );
  }
}
