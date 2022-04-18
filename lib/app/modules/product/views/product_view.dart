import 'dart:async';
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/modules/product/controllers/product_controller.dart';
import 'package:producto/app/utils/functions.dart';
import 'package:producto/app/utils/widgets_utils_app.dart' as utilsWidget;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

import '../../../routes/app_pages.dart';

class Product extends GetView<ProductController> {
  Product({Key? key}) : super(key: key);

  // controllers
  final WelcomeController welcomeController = Get.find<WelcomeController>();
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: body(context: context)),
    );
  }

  // WIDGETS VIEWS
  Widget body({required BuildContext context}) {
    // controllers
    final ScrollController listViewController = new ScrollController();
  
    return SnappingSheet(
      child: background(buildContext: context),
      lockOverflowDrag: true,
      snappingPositions: [
        SnappingPosition.factor(
          positionFactor: 0.0,
          snappingCurve: Curves.easeOutExpo,
          snappingDuration: Duration(seconds: 1),
          grabbingContentOffset: GrabbingContentOffset.top,
        ),
        SnappingPosition.factor(
          snappingCurve: Curves.elasticOut,
          snappingDuration: Duration(milliseconds: 1750),
          positionFactor: 0.5,
        ),
        SnappingPosition.factor(
          grabbingContentOffset: GrabbingContentOffset.bottom,
          snappingCurve: Curves.easeInExpo,
          snappingDuration: Duration(seconds: 1),
          positionFactor: 1,
        ),
      ],
      grabbing: persistentHeader(
          colorBackground: Get.theme.cardColor, colorText: Colors.white),
      grabbingHeight: 170,
      sheetAbove: null,
      sheetBelow: SnappingSheetContent(
        draggable: true,
        childScrollController: listViewController,
        child: expandableContent(
            colorBackground: Get.theme.cardColor, colorText: Colors.white),
      ),
    );
  }

  // WIDGETS VIEWS
  Widget viewProducto({required double height, required double width}) {
    Color colorText = Get.theme.brightness == Brightness.dark
        ? Colors.white.withOpacity(0.90)
        : Colors.black.withOpacity(0.90);

    // vista para la captura de la pantalla
    return SafeArea(
      child: Scaffold(
          body: Container(
        color: Get.theme.scaffoldBackgroundColor,
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
              padding: EdgeInsets.symmetric(horizontal: width * 0.20,vertical: 20),
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
                            fontSize: 20,
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
                  // nombre del negocio
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(welcomeController.getProfileAccountSelected.name,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Get.theme.brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.90)
                                : Colors.black.withOpacity(0.90))),
                  )),
                ],
              ),
            ),
            Image.asset('assets/playstore_app_img.png',height: 100,width: 200,),
          ],
        ),
      )),
    );
  }

  Widget widgetDescripcion() {
    // values
    MaterialColor colorChip0 = Utils.getRandomColor();
    MaterialColor colorChip1 = Utils.getRandomColor();

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
                        ? ElasticIn(
                            child: Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              avatar: CircleAvatar(
                                  backgroundColor: colorChip0.withOpacity(0.2),
                                  child: Text(
                                      controller.getCategory.name
                                          .substring(0, 1),
                                      style: TextStyle(color: colorChip0))),
                              label: Text(controller.getCategory.name,
                                  overflow: TextOverflow.ellipsis),
                            ),
                          )
                        : Container(),
                    controller.getSubcategory.name != ""
                        ? ElasticIn(
                            child: Chip(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              avatar: CircleAvatar(
                                backgroundColor: colorChip1.withOpacity(0.2),
                                child: Text(
                                    controller.getSubcategory.name
                                        .substring(0, 1),
                                    style: TextStyle(color: colorChip1)),
                              ),
                              label: Text(
                                controller.getSubcategory.name,
                                overflow: TextOverflow.ellipsis,
                              ),
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
                          fontSize: 18,
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
                      controller.getProduct.verified == true
                          ? Padding(
                              padding: const EdgeInsets.only(right: 1.0),
                              child: new Image.asset(
                                  'assets/icon_verificado.png',
                                  width: 15.0,
                                  height: 15.0))
                          : new Icon(Icons.qr_code_2_rounded, size: 14),
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

  Widget background({required BuildContext buildContext}) {
    return Obx(() => Column(
          children: [
            // AppBar
            Row(
              children: [
                IconButton(onPressed: Get.back, icon: Icon(Icons.arrow_back)),
                Text(
                    controller.getMark.name == ''
                        ? 'Cargando...'
                        : controller.getMark.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Get.theme.textTheme.bodyText1!.color)),
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        IconButton(
                          onPressed: controller.showDialogReportProduct,
                          icon: Icon(Icons.report_outlined),
                        ),
                        IconButton(
                          padding: EdgeInsets.all(12.0),
                          icon: Icon(Icons.share_outlined),
                          onPressed: () {
                            showGeneralDialog(
                                context: buildContext,
                                barrierDismissible: true,
                                barrierLabel:
                                    MaterialLocalizations.of(buildContext)
                                        .modalBarrierDismissLabel,
                                barrierColor: Colors.black45,
                                transitionDuration:
                                    const Duration(milliseconds: 200),
                                pageBuilder: (BuildContext buildContext,
                                    Animation animation,
                                    Animation secondaryAnimation) {
                                  Timer(Duration(seconds: 1), () async {
                                    // note: La imagen capturada puede verse pixelada. Puede solucionar este problema configurando el valor de pixelRatio
                                    double pixelRatio =
                                        MediaQuery.of(buildContext)
                                            .devicePixelRatio;
                                    // Captura de widgets
                                    await screenshotController
                                        .capture(
                                            delay:
                                                const Duration(milliseconds: 1),
                                            pixelRatio: pixelRatio)
                                        .then((image) async {
                                      if (image != null) {
                                        final directory =
                                            await getApplicationDocumentsDirectory();
                                        final imagePath = await File(
                                                '${directory.path}/image.png')
                                            .create();
                                        await imagePath.writeAsBytes(image);

                                        /// Share Plugin
                                        await Share.shareFiles([imagePath.path]);
                                        Get.back();
                                      }
                                    });
                                  });

                                  // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                  var height =
                                      MediaQuery.of(buildContext).size.height;
                                  var width =
                                      MediaQuery.of(buildContext).size.width;

                                  return Screenshot(
                                    controller: screenshotController,
                                    child: viewProducto(
                                        height: height, width: width),
                                  );
                                });
                          },
                        ),
                        welcomeController.getIdAccountSelecte == ''
                            ? Container()
                            : IconButton(
                                padding: EdgeInsets.all(12.0),
                                icon: Icon(controller.getInCatalogue
                                    ? Icons.edit
                                    : Icons.add),
                                onPressed: () {
                                  controller.toProductEdit();
                                },
                              ),
                      ]),
                ),
              ],
            ),
            // body
            Expanded(
              child: SingleChildScrollView(
                controller: controller.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12),
                    imageViewCard(),
                    widgetDescripcion(),
                    controller.getstateAds?adsWidget(ad: controller.bannerAd.value):Container(),
                    
                    otherProductsCatalogueListHorizontal(),
                    otherBrandProductsListHorizontal(),
                    const SizedBox(height: 150.0, width: 120.0),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget adsWidget({required BannerAd  ad}) {
    return Center(
            child: Container(
              alignment: Alignment.center,
              child: AdWidget(ad:ad),
              width: ad.size.width.toDouble(),
              height: ad.size.height.toDouble(),
            ),
          );

  }

  Widget persistentHeader(
      {required Color colorBackground, required Color colorText}) {
    return Obx(() => ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          child: Container(
            color: colorBackground,
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.only(
                bottom: 12.0, left: 12.0, right: 12.0, top: 12.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  welcomeController.getIdAccountSelecte != ''
                      ? welcomeController.isCatalogue(
                              id: controller.getProduct.id)
                          ? controller.getProduct.salePrice != 0.0
                              ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          Publicaciones.getFormatoPrecio(
                                              monto: controller
                                                  .getProduct.salePrice),
                                          style: TextStyle(
                                              color: colorText,
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.end),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                            child: Text(
                                              Publicaciones.getFechaPublicacion(
                                                      controller.getProduct.upgrade
                                                          .toDate(),
                                                      Timestamp.now().toDate())
                                                  .toLowerCase(),
                                              style: TextStyle(
                                                  fontStyle: FontStyle.normal,
                                                  color: colorText.withOpacity(0.6)),
                                            ),
                                          ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  textDirection: TextDirection.ltr,
                                  mainAxisSize: MainAxisSize.min,
                                    children: [
                                      controller.getProduct
                                                  .purchasePrice !=
                                              0.0
                                          ? Text(
                                              sProcentaje(
                                                  precioCompra: controller
                                                      .getProduct
                                                      .purchasePrice,
                                                  precioVenta: controller
                                                      .getProduct
                                                      .salePrice),
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12.0,
                                                  fontWeight:
                                                      FontWeight.bold))
                                          : Container(),
                                      controller.getProduct
                                                  .purchasePrice !=
                                              0.0
                                          ? Text(" > ",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12.0))
                                          : Container(),
                                      controller.getProduct
                                                  .purchasePrice !=
                                              0.0
                                          ? Text(
                                              Publicaciones.sGanancia(
                                                  precioCompra: controller
                                                      .getProduct
                                                      .purchasePrice,
                                                  precioVenta: controller
                                                      .getProduct
                                                      .salePrice)+' De Ganancia',
                                              style: TextStyle(
                                                  color: controller
                                                              .getProduct
                                                              .purchasePrice <
                                                          controller
                                                              .getProduct
                                                              .salePrice
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 12.0,
                                                  fontWeight:
                                                      FontWeight.bold))
                                          : Container(),
                                    ],
                                  ),
                                ],
                              )
                              : Container()
                          : TextButton(
                              onPressed: controller.toProductEdit,
                              child: Text('Agregar a mi catálogo'))
                      : welcomeController.getManagedAccountData.length == 0
                          ? TextButton(
                              onPressed: () => Get.toNamed(Routes.ACCOUNT),
                              child: Text('Agregar a mi catálogo'))
                          : controller.getStateLoadButtonAddProduct
                              ? CircularProgressIndicator()
                              : TextButton(
                                  onPressed:
                                      controller.getStateCheckProductInCatalogue
                                          ? () {}
                                          : controller.checkProducInCatalogue,
                                  child: Text(
                                      controller.getStateCheckProductInCatalogue
                                          ? 'Ya existe en tu catálogo 👍'
                                          : 'Agregar a mi catálogo')),
                  Icon(Icons.keyboard_arrow_up,
                      color: colorText.withOpacity(0.7)),
                  Text(
                    'Deslice hacia arriba para ver los últimos precios publicados',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: colorText.withOpacity(0.4)),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget expandableContent(
      {required Color colorBackground, required Color colorText}) {
    return Obx(() => Container(
        width: double.infinity,
        margin: EdgeInsets.all(0),
        color: colorBackground,
        padding:
            EdgeInsets.only(bottom: 12.0, left: 12.0, right: 12.0, top: 12.0),
        child: ultimosPreciosView()));
  }
  // WIDGETS COMPONENTS

  Widget ultimosPreciosView() {
    if (controller.getListPricesForProduct.length != 0) {
      // values
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
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(vertical: 0.16),
              shrinkWrap: true,
              itemCount: controller.getListPricesForProduct.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 0.0),
                      leading: controller.getListPricesForProduct[index]
                                      .idAccount ==
                                  "" ||
                              controller.getListPricesForProduct[index]
                                      .imageAccount ==
                                  ""
                          ? CircleAvatar(
                              backgroundColor: Colors.grey,
                              radius: 24.0,
                            )
                          : CachedNetworkImage(
                              imageUrl: controller.getListPricesForProduct[index].imageAccount,
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
                      title: Text(Publicaciones.getFormatoPrecio(monto: controller.getListPricesForProduct[index].price),style: TextStyle(color: colorText,fontSize: 24.0,fontWeight: FontWeight.bold)),
                      subtitle: Text(controller.getListPricesForProduct[index].nameAccount,style: TextStyle(color: colorText.withOpacity(0.7))),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            Publicaciones.getFechaPublicacion(
                                    controller
                                        .getListPricesForProduct[index].time
                                        .toDate(),
                                    new DateTime.now())
                                .toLowerCase(),
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontSize: 12,
                                color: colorText.withOpacity(0.4)),
                          ),
                          SizedBox(height: 4),
                          Text(
                              "En " +
                                  (controller.getListPricesForProduct[index]
                                          .town.isEmpty
                                      ? controller
                                          .getListPricesForProduct[index]
                                          .province
                                          .toString()
                                      : controller
                                          .getListPricesForProduct[index].town
                                          .toString()),
                              style: TextStyle(
                                  color: colorText,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    (index + 1) == 9 &&
                            controller.getListPricesForProduct.length == 9
                        ? TextButton(
                            onPressed: () {
                              controller.readListPricesForProduct(limit: false);
                            },
                            child: Text('Ver todos'))
                        : Container(),
                  ],
                );
              },
            ),
          ),
        ],
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
        child: Text(
          "Aun no se registró ningún precio para este producto",
          style: TextStyle(fontSize: 20.0, color: Colors.grey.withOpacity(0.5)),
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget imageViewCard({double borderRadius = 14}) {
    return controller.getProduct.image == ''
        ? Container()
        : Card(
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
                    imageUrl: controller.getProduct.image == ''
                        ? 'https://www.barcelonabeta.org/sites/default/files/2018-04/default-image_0.png'
                        : controller.getProduct.image,
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
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.25),
                        ),
                      ),
                    ),
                  ),
                  Padding(
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
                  ),
                ],
              ),
            ),
          );
  }

  Widget otherBrandProductsListHorizontal() {
    // mostramos en un lista horizontal otros productos de la misma marca
    return Container(
      width: double.infinity,
      height: 300,
      child: Obx(() => controller.getStateViewProductsMark == false
          ? Center(
              child: TextButton(
              child: Text('Mostrar más de ${controller.getMark.name}'),
              onPressed: controller.readOthersProductsMark,
            ))
          : controller.getListOthersProductsForMark.length == 0
              ? Container()
              : FadeInRight(
                  duration: Duration(seconds: 1),
                  child: Column(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                      ),
                      Container(
                        height: 220,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              controller.getListOthersProductsForMark.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  bottom: 8,
                                  top: 8,
                                  left: index == 0 ? 12 : 0,
                                  right: controller.getListOthersProductsForMark
                                              .length ==
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
                  ),
                )),
    );
  }

  Widget otherProductsCatalogueListHorizontal() {
    // mostramos otros productos del cátalogo de la misma cátegoria
    return Obx(() =>
        controller.getListOthersProductsForCategoryCatalogue.length == 0 ||
                controller.getCategory.id == ''
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

  // controllers
  final ProductController productController = Get.find<ProductController>();

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
                  onTap: () =>
                      productController.readData(productCatalogue: producto),
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
                  producto.description.substring(0, 4),
                  style: TextStyle(fontSize: 24.0, color: Colors.grey),
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
  final ProductController productController = Get.find<ProductController>();

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
                child: InkWell(onTap: () {
                  productController.readData(productCatalogue: producto);
                }),
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            producto.description,
            maxLines: 2,
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 14.0,
                color: Colors.grey),
          ),
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
