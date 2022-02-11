import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loadany/loadany.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import 'package:search_page/search_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/dynamicTheme_lb.dart';
import 'widgets/showDialog.dart';

class CatalogueScreenView extends StatelessWidget {
  CatalogueScreenView({Key? key}) : super(key: key);

  // controllers
  final WelcomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context: context),
      body: body(buildContext: context),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Get.theme.primaryColor,
          heroTag: "Escanear codigo",
          child: Image(
              color: Colors.white,
              height: 30.0,
              width: 30.0,
              image: AssetImage('assets/barcode.png'),
              fit: BoxFit.contain),
          tooltip: 'Escanea el codigo del producto',
          onPressed: () {
            scanBarcodeNormal(context: context);
          }),
    );
  }

  // WIDGET VIEWS
  PreferredSizeWidget appbar({required BuildContext context}) {
    /* AppBar persistente que nunca se desplaza */

    return AppBar(
      elevation: 0.0,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      iconTheme: Get.theme.iconTheme
          .copyWith(color: Get.theme.textTheme.bodyText1!.color),
      title: InkWell(
        onTap: () => showModalBottomSheetSelectAccount(),
        child: Obx(() => RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            text: TextSpan(
              style: TextStyle(
                color: Get.theme.textTheme.bodyText1!.color,
                fontSize: 18,
              ),
              children: [
                TextSpan(
                  text: controller.getProfileAccountSelected.id == ''
                      ? "Seleccionar cuenta"
                      : controller.getProfileAccountSelected.name != ""
                          ? controller.getProfileAccountSelected.name
                          : "Mi catalogo",
                ),
                WidgetSpan(child: Icon(Icons.keyboard_arrow_down, size: 24)),
              ],
            ))),
      ),
      actions: <Widget>[
        IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchPage<ProductCatalogue>(
                  items: controller.getCataloProducts,
                  searchLabel: 'Buscar producto',
                  suggestion: Center(child: Text('ej. alfajor')),
                  failure: Center(child: Text('No se encontro :(')),
                  filter: (product) => [product.description, product.nameMark],
                  builder: (product) => ListTile(
                    leading: FadeInImage(
                      image: NetworkImage(product.image),
                      placeholder: AssetImage("assets/loading.gif"),
                      fadeInDuration: Duration(milliseconds: 200),
                      fit: BoxFit.cover,
                      width: 50.0,
                    ),
                    title: Text(product.nameMark),
                    subtitle: Text(product.description),
                    onTap: () {
                      Get.toNamed(Routes.PRODUCT,
                          arguments: {'product': product});
                    },
                  ),
                ),
              );
            },
            icon: Icon(Icons.search)),
        Obx(() => controller.getProfileAccountSelected.id == ''
            ? Container()
            : Container(
                padding: EdgeInsets.all(12.0),
                child: InkWell(
                  customBorder: new CircleBorder(),
                  splashColor: Colors.grey,
                  onTap: () {
                    showMSetting();
                  },
                  child: Hero(
                    tag: "fotoperfiltoolbar",
                    child: CachedNetworkImage(
                      imageUrl: controller.getProfileAccountSelected.image,
                      placeholder: (context, url) =>
                          Icon(Icons.account_circle_rounded),
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.account_circle_rounded),
                    ),
                  ),
                ),
              )),
      ],
    );
  }

  Widget body({required BuildContext buildContext}) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        /* le permite crear una lista de elementos que se desplazarían hasta que el cuerpo alcanzara la parte superior */
        floatHeaderSlivers: true,
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) {
          return [
            // atentos a cualquier cambio que surja en los datos de la lista de marcas
            GetBuilder<WelcomeController>(
              id: 'marks',
              init: WelcomeController(),
              initState: (_) {},
              builder: (_) {
                return SliverList(
                  delegate: SliverChildListDelegate([
                    controller.getLoadDataCatalogueMarks
                        ? Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 12, horizontal: 0),
                            child:
                                controller.getCatalogueMarksFilter.length == 0
                                    ? Container()
                                    : WidgetsListaHorizontalMarks())
                        : WidgetsListaHorizontalMarksLoadAnim(),
                  ]),
                );
              },
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Divider(height: 0.0),
            TabBar(
              indicatorColor: Theme.of(buildContext).primaryColor,
              indicatorWeight: 5.0,
              labelColor: Get.theme.brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              onTap: (_) {
                if (!controller.getSelectItems) {
                  ViewCategoria.show(buildContext: buildContext);
                }
              },
              tabs: [
                GetBuilder<WelcomeController>(
                  init: WelcomeController(),
                  id: 'tab',
                  builder: (_) => Stack(
                    children: [
                      Align(
                        alignment: controller.getSelectItems
                            ? Alignment.centerLeft
                            : Alignment.center,
                        child: controller.getSelectItems
                            ? Tab(
                                text: controller.getItemsSelectLength == 0
                                    ? 'Seleccionar'
                                    : controller.getItemsSelectLength == 1
                                        ? '${controller.getItemsSelectLength} elemento seleccionado'
                                        : '${controller.getItemsSelectLength} elementos seleccionados')
                            : Tab(text: controller.getCatalogueCategoryList.length==0?'Agregar categoría': controller.getTextTab),
                      ),
                        Align(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // button - delete
                              !controller.getSelectItems?Container():controller.getItemsSelectLength == 0
                                  ? Container()
                                  : IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: controller.showDialogDeleteSelectedItems),
                              // button - select all items
                              !controller.getSelectItems?Container():IconButton(
                                icon: Icon(Icons.done_all,color: controller.getStateSelectAll?null:Colors.green),
                                onPressed: ()=>controller.setStateSelectAll=!controller.getStateSelectAll,
                              ),
                              // button - exit of selections
                              controller.getCatalogueLoad.length==0?Container():IconButton(
                                  icon: Icon(controller.getSelectItems
                                      ? Icons.close
                                      : Icons.add_circle_outline),
                                  onPressed: () => controller.setSelectItems =!controller.getSelectItems),
                            ],
                          ),
                          alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                )
              ],
            ),
            Divider(height: 0.0),
            Expanded(
              child: GetBuilder<WelcomeController>(
                id: 'catalogue',
                initState: (_) {},
                builder: (_) {
                  if (_.getLoadDataCatalogue == false) {
                    return loadGridView();
                  }

                  return controller.getCatalogueLoad.length == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Todavía no hay producto'),
                              TextButton.icon(
                                  onPressed: () => Get.toNamed(
                                      Routes.PRODUCTS_SEARCH,
                                      arguments: {'idProduct': ''}),
                                  label: Text('Agregar nuevo'),
                                  icon: Icon(Icons.add))
                            ],
                          ),
                        )
                      : TabBarView(
                          children: [
                            gridViewLoadAny(),
                          ],
                        );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loadGridView() {
    final Color color1 = Colors.black26;
    final Color color2 = Colors.grey;

    return Shimmer.fromColors(
      baseColor: color1,
      highlightColor: color2,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 150,
            childAspectRatio: 1 / 1.4,
          ),
          itemCount: 12,
          itemBuilder: (BuildContext ctx, index) {
            return Card(elevation: 0, color: Colors.grey.withOpacity(0.1));
          }),
    );
  }

  Widget gridViewLoadAny() {
    //var
    int itemsDefault = 0;
    if (controller.getCatalogueLoad.length < 15) itemsDefault = 12;
    if (controller.getCatalogueLoad.length > 15) itemsDefault = 3;

    return LoadAny(
      onLoadMore: controller.getCatalogueMoreLoad,
      status: controller.getLoadGridCatalogueStatus,
      loadingMsg: 'Cargando...',
      errorMsg: 'error!',
      finishMsg: controller.getCatalogueLoad.length.toString() + ' productos',
      child: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              childAspectRatio: 1 / 1.4,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                // en la primera posición muestra el botón para agregar un nuevo objeto
                if (index == 0) {
                  // item defaul add
                  return Card(
                    elevation: 0,
                    color: Colors.grey.withOpacity(0.1),
                    child: Stack(
                      children: [
                        Center(
                            child: Icon(Icons.add,
                                color: Colors.grey.withOpacity(0.8), size: 30)),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Get.toNamed(Routes.PRODUCTS_SEARCH,
                                  arguments: {'idProduct': ''}),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // mostramos 15 elementos vacíos de los cuales el primero tendrá un icono 'add'
                if ((index) <= controller.getCatalogueLoad.length) {
                  return ProductoItem(
                      producto: controller.getCatalogueLoad[index - 1]);
                } else {
                  return Card(
                      elevation: 0, color: Colors.grey.withOpacity(0.1));
                }
              },
              childCount: controller.getCatalogueLoad.length + itemsDefault,
            ),
          ),
        ],
      ),
    );
  }

  // BottomSheet - Getx
  void showModalBottomSheetSelectAccount() {
    // muestra las cuentas en el que este usuario tiene acceso
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
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          widget,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(onPressed: controller.catalogueExit, child: Text('Salir de mi cátalogo')),
          )
        ],
      ),
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }

  // BottomSheet
  void showMSetting() {
    Widget widget = ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 15.0),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Icon(Get.theme.brightness != Brightness.light
              ? Icons.brightness_high
              : Icons.brightness_3),
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
          leading: controller.getProfileAccountSelected.image == ""
              ? Icon(Icons.account_circle)
              : CachedNetworkImage(
                  imageUrl: controller.getProfileAccountSelected.image,
                  placeholder: (context, url) =>
                      const Icon(Icons.account_circle),
                  imageBuilder: (context, image) =>
                      CircleAvatar(backgroundImage: image, radius: 18.0),
                  errorWidget: (context, url, error) =>
                      Icon(Icons.account_circle),
                ),
          title: Text('Editar perfil'),
          onTap: () {
            Get.back();
            Get.toNamed(Routes.ACCOUNT);
          },
        ),
        Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Icon(Icons.logout),
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
            'Acerca de',
          ),
          onTap: () async {
            String url = "https://logicabooleanaapps.blogspot.com/";
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              throw 'Could not launch $url';
            }
          },
        ),
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
  Future<void> scanBarcodeNormal({required BuildContext context}) async {
    /*Platform messages are asynchronous, so we initialize in an async method */

    String barcodeScanRes = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
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

//  WIDGET - Marks list
//  readme
//  creamos un lista horizontal con las marcas de los productos que se muestran al usaurio
class WidgetsListaHorizontalMarks extends StatelessWidget {
  WidgetsListaHorizontalMarks({Key? key}) : super(key: key);

  // var
  final WelcomeController controller = Get.find();
  final List<Color> colorGradientInstagram = [
    Get.theme.primaryColor,
    Get.theme.primaryColor,
    Get.theme.primaryColor,
    Get.theme.primaryColor,
  ];

  @override
  Widget build(BuildContext context) {
    if (controller.getCatalogueMarksFilter.length == 0) return Container();
    return SizedBox(
      height: 110.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.getCatalogueMarksFilter.length,
          itemBuilder: (BuildContext c, int index) {
            // get
            Mark marca = controller.getCatalogueMarksFilter[index];
            if (marca.name == '') return Container();

            return Container(
              width: 81.0,
              height: 100.0,
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  controller.setMarkSelect = marca;
                },
                child: Column(
                  children: <Widget>[
                    DashedCircle(
                      dashes:
                          controller.getNumeroDeProductosDeMarca(id: marca.id),
                      gradientColor: colorGradientInstagram,
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
                        child: viewCircleImage(
                            url: marca.image, texto: marca.name, size: 50),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(marca.name,
                        style: TextStyle(
                            fontSize: controller.getMarkSelect.id == marca.id
                                ? 14
                                : 12,
                            fontWeight: controller.getMarkSelect.id == marca.id
                                ? FontWeight.bold
                                : FontWeight.normal),
                        overflow: TextOverflow.fade,
                        softWrap: false)
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class WidgetsListaHorizontalMarksLoadAnim extends StatelessWidget {
  WidgetsListaHorizontalMarksLoadAnim({Key? key}) : super(key: key);

  final Color color1 = Colors.black12;
  final Color color2 = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.0,
      child: Shimmer.fromColors(
        baseColor: color1,
        highlightColor: color2,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (BuildContext c, int index) {
              return Container(
                width: 81.0,
                height: 100.0,
                padding: EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 30,
                      ),
                      SizedBox(height: 8.0),
                      Container(
                        width: 30,
                        height: 10,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
