import 'package:animate_do/animate_do.dart';
import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:loadany/loadany.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import 'package:url_launcher/url_launcher.dart';

class CatalogueScreenView extends StatelessWidget {
  CatalogueScreenView({Key? key}) : super(key: key);

  final WelcomeController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return scaffondCatalogo(buildContext: context);
  }

  Widget scaffondCatalogo({required BuildContext buildContext}) {
    return Scaffold(
      /* AppBar persistente que nunca se desplaza */
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(buildContext).scaffoldBackgroundColor,
        iconTheme: Theme.of(buildContext)
            .iconTheme
            .copyWith(color: Theme.of(buildContext).textTheme.bodyText1!.color),
        title: InkWell(
          onTap: () => showModalBottomSheetSelectAccount(buildContext),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: <Widget>[
                Obx(() => Text(
                    controller.getProfileAccountSelected.id == ''
                        ? "Seleccionar cuenta"
                        : controller.getProfileAccountSelected.nombreNegocio !=
                                ""
                            ? controller.getProfileAccountSelected.nombreNegocio
                            : "Mi catalogo",
                    style: TextStyle(
                        color:
                            Theme.of(buildContext).textTheme.bodyText1!.color),
                    overflow: TextOverflow.fade,
                    softWrap: false)),
                Icon(Icons.keyboard_arrow_down)
              ],
            ),
          ),
        ),
        actions: <Widget>[
          Obx(() => controller.getProfileAccountSelected.id == ''
              ? Container()
              : Container(
                  padding: EdgeInsets.all(12.0),
                  child: InkWell(
                    customBorder: new CircleBorder(),
                    splashColor: Colors.red,
                    onTap: () {
                      showModalBottomSheetSetting(buildContext);
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
                              imageUrl: controller
                                  .getProfileAccountSelected.imagenPerfil,
                              placeholder: (context, url) => FadeInImage(
                                  image: AssetImage("assets/loading.gif"),
                                  placeholder:
                                      AssetImage("assets/loading.gif")),
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
                )),
        ],
      ),
      body: body(buildContext: buildContext),
      /* new StreamBuilder(
        stream: Global.getCatalogoNegocio(
                idNegocio: Global.oPerfilNegocio.id ?? "")
            .streamDataProductoAll(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Global.listProudctosNegocio = snapshot.data;
            buildContext.read<ProviderCatalogo>().setCatalogo =
                snapshot.data;
            return body(buildContext: buildContext);
          } else {
            return WidgetLoadingInit(appbar: false);
          }
        },
      ), */
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: Theme(
          data: ThemeData.light(),
          child: AnimatedFloatingActionButton(
            colorEndAnimation: Colors.grey,
            animatedIconData: AnimatedIcons.menu_close,
            colorStartAnimation: Get.theme.primaryColor,
            fabButtons: <Widget>[
              FloatingActionButton(
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
                    scanBarcodeNormal(context: buildContext);
                  }),
              FloatingActionButton(
                  backgroundColor: Get.theme.primaryColor,
                  heroTag: "Escribir codigo",
                  child: Icon(Icons.edit, color: Colors.white),
                  tooltip: 'Escribe el codigo del producto',
                  onPressed: () {
                    Navigator.of(buildContext).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Text('FloatingActionButton') //WidgetSeachProduct(),
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }

  // Widgets
  Widget body({required BuildContext buildContext}) {
    return Obx(() => DefaultTabController(
          length: 1,
          child: NestedScrollView(
            /* le permite crear una lista de elementos que se desplazarían hasta que el cuerpo alcanzara la parte superior */
            floatHeaderSlivers: true,
            physics: BouncingScrollPhysics(),
            headerSliverBuilder: (context, _) {
              return [
                SliverList(
                  delegate: SliverChildListDelegate([
                    controller.getCatalogueBusiness.length != 0
                        ? SizedBox(height: 12.0)
                        : Container(),
                    controller.getCatalogueBusiness.length != 0
                        ? WidgetsListaHorizontalMarks()
                        : Container(),
                    controller.getCatalogueBusiness.length != 0
                        ? widgetBuscadorView()
                        : Container(),
                    controller.getCatalogueBusiness.length != 0
                        ? SizedBox(height: 12.0)
                        : Container(),
                  ]),
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                Divider(height: 0.0),
                TabBar(
                  indicatorColor: Theme.of(buildContext).primaryColor,
                  indicatorWeight: 5.0,
                  labelColor:
                      Theme.of(buildContext).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                  onTap: (value) {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        backgroundColor: Theme.of(buildContext).canvasColor,
                        context: buildContext,
                        builder: (ctx) {
                          return Text('showModalBottomSheet');
                          /* return ClipRRect(
                                    child: ViewCategoria(
                                      buildContext: buildContext,
                                    ),
                                  ); */
                        });
                  },
                  tabs: [
                    Tab(
                        text: controller.getSelectCategoryId +
                            " (${controller.getSelectCategoryId != '' ? controller.getCatalogueFilter.length.toString() : controller.getCatalogueBusiness.length.toString()})")
                  ],
                ),
                Divider(height: 0.0),
                Expanded(
                  child: TabBarView(
                    children: [
                      gridViewLoadAny(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget gridViewLoadAny() {
    return LoadAny(
      onLoadMore: controller.getCatalogueMoreLoad,
      status: controller.getLoadGridCatalogueStatus,
      loadingMsg: 'Cargando...',
      errorMsg: 'errorMsg',
      child: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ProductoItem(
                    producto: controller.getCatalogueLoad[index]);
              },
              childCount: controller.getCatalogueLoad.length,
            ),
          )
        ],
      ),
    );
  }

  Widget widgetBuscadorView() {
    // variables
    Color colorCard = Get.isDarkMode
        ? Colors.white.withOpacity(0.08)
        : Colors.black.withOpacity(0.08);
    Color colorTextIcon = Get.isDarkMode ? Colors.white54 : Colors.black54;

    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Card(
        color: colorCard,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        elevation: 0,
        margin: EdgeInsets.all(0.0),
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.search, color: colorTextIcon),
                SizedBox(width: 12.0),
                Text('Buscar',
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: colorTextIcon)),
              ],
            ),
          ),
          onTap: () {
            /* showSearch(
                context: buildContext,
                delegate: DataSearch(listOBJ: Global.listProudctosNegocio)); */
          },
        ),
      ),
    );
  }

  // BottomSheet - Getx
  void showModalBottomSheetSelectAccount(BuildContext buildContext) {
    Widget widget = controller.getManagedAccountData.length == 0?
    WidgetButtonListTile(buildContext: buildContext).buttonListTileCrearCuenta(context: buildContext):ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      shrinkWrap: true,
      itemCount: controller.getManagedAccountData.length,
      itemBuilder: (BuildContext context, int index) {
        return WidgetButtonListTile(buildContext: buildContext).buttonListTileItemCuenta(buildContext: buildContext,perfilNegocio:controller.getManagedAccountData[index],adminPropietario:controller.getManagedAccountData[index].id ==controller.getUserAccountAuth.uid);
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

  // BottomSheet
  void showModalBottomSheetSetting(BuildContext buildContext) {
    Widget widget = ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(vertical: 15.0),
      children: <Widget>[
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: controller.getProfileAccountSelected.imagenPerfil == ""
              ? CircleAvatar(
                  backgroundColor: Colors.black26,
                  radius: 18.0,
                  child: Text(
                      controller.getProfileAccountSelected.nombreNegocio
                          .substring(0, 1),
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                )
              : CachedNetworkImage(
                  imageUrl: controller.getProfileAccountSelected.imagenPerfil,
                  placeholder: (context, url) => const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 18.0,
                  ),
                  imageBuilder: (context, image) => CircleAvatar(
                    backgroundImage: image,
                    radius: 18.0,
                  ),
                ),
          title: Text('Editar perfil'),
          onTap: () {
            Get.toNamed(Routes.ACCOUNT);
          },
        ),
        Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
        ListTile(
          contentPadding: EdgeInsets.all(12.0),
          leading: Icon(Icons.logout),
          title: Text('Cerrar sesión'),
          onTap:controller.showDialogCerrarSesion,
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
  Future<void> scanBarcodeNormal({required BuildContext context}) async {
    /*Platform messages are asynchronous, so we initialize in an async method */

    String barcodeScanRes = "";
    // Platform messages may fail, so we use a try/catch PlatformException.
    /* try {
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
    ProductoNegocio productoSelected;

    if (Global.listProudctosNegocio.length != 0) {
      for (ProductoNegocio producto in Global.listProudctosNegocio) {
        if (producto.codigo == barcodeScanRes) {
          productoSelected = producto;
          coincidencia = true;
          break;
        }
      }
    }

    if (coincidencia) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              ProductScreen(producto: productoSelected)));
    } else {
      if (barcodeScanRes.toString() != "") {
        if (barcodeScanRes.toString() != "-1") {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  WidgetSeachProduct(codigo: barcodeScanRes)));
        }
      }
    } */
  }
}

// WIDGET - Sujerencias de productos
class WidgetProductsSuggestions extends StatelessWidget {
  WidgetProductsSuggestions({required this.list});

  // var
  final WelcomeController controller = Get.find();
  final List<Producto> list;

  @override
  Widget build(BuildContext context) {
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
              onTap: () {},
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
                                      imageUrl: list[0].urlImagen,
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
                                      imageUrl: list[1].urlImagen,
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
                                      imageUrl: list[2].urlImagen,
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
}

//  WIDGET - Marks list
//  readme
//  creamos un lista horizontal con las marcas de los productos que se muestran al usaurio
class WidgetsListaHorizontalMarks extends StatelessWidget {
  WidgetsListaHorizontalMarks({Key? key}) : super(key: key);

  // var
  final WelcomeController controller = Get.find();
  final List<Color> colorGradientInstagram = [
    /* Color.fromRGBO(129, 52, 175, 1.0),
    Color.fromRGBO(129, 52, 175, 1.0),
    Color.fromRGBO(221, 42, 123, 1.0),
    Color.fromRGBO(68, 0, 71, 1.0), */
    Get.theme.primaryColor,
    Get.theme.primaryColor,
    Get.theme.primaryColor,
    Get.theme.primaryColor,
  ];

  @override
  Widget build(BuildContext context) {
    if (controller.getCatalogueMarks.length == 0) return Container();
    return SizedBox(
      height: 110.0,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: controller.getCatalogueMarks.length,
          itemBuilder: (BuildContext c, int index) {
            // get
            Marca marca = controller.getCatalogueMarks[index];
            if (marca.titulo == '') return Container();

            return Container(
              width: 81.0,
              height: 100.0,
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  /* buildContext.read<ProviderCatalogo>()
                              .setIdMarca = marca.id;
                          buildContext
                              .read<ProviderCatalogo>()
                              .setNombreFiltro = marca.titulo; */
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
                            url: marca.urlImagen,
                            texto: marca.titulo,
                            size: 50),
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(marca.titulo,
                        style: TextStyle(
                            fontSize: controller.getSelectMarkId == marca.id
                                ? 14
                                : 12,
                            fontWeight: controller.getSelectMarkId == marca.id
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
