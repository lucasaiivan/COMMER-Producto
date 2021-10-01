import 'package:animated_floating_buttons/animated_floating_buttons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math' as math;
import 'package:get/get.dart';

import 'package:producto/app/modules/home/controllers/welcome_controller.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import 'package:url_launcher/url_launcher.dart';

/*  DESCRIPCIÓN */
/*  Pantalla principal de la aplicación "Producto"  */

class PagePrincipal extends GetView<WelcomeController> {
  /* Declarar variables */
  double get randHeight => math.Random().nextInt(100).toDouble();

  @override
  Widget build(BuildContext buildContext) {
    return controller.getSelectBusinessId == ""
        ? scaffoldScan(buildContext: buildContext)
        : scaffondCatalogo(buildContext: buildContext);
  }

  Scaffold scaffoldScan({required BuildContext buildContext}) {
    Color color = Theme.of(buildContext).brightness == Brightness.dark
        ? Colors.white54
        : Colors.black38;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(buildContext).canvasColor,
        iconTheme: Theme.of(buildContext)
            .iconTheme
            .copyWith(color: Theme.of(buildContext).textTheme.bodyText1!.color),
        title: TextButton(
          onPressed: () => showModalBottomSheetSetting(buildContext),
          child: Text(
            "Crear mi catálogo",
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(buildContext).textTheme.bodyText1!.color),
          ),
        ),
        actions: <Widget>[
          WidgetsUtilsApp().buttonThemeBrightness(context: buildContext),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              borderRadius: BorderRadius.all(Radius.circular(30.0)),
              splashColor: Theme.of(buildContext).primaryColor,
              onTap: () => scanBarcodeNormal(context: buildContext),
              child: Container(
                margin: const EdgeInsets.all(0.0),
                padding: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(width: 0.2, color: color),
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
            widgetSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget widgetSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('sugerencias para ti'),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(child: CircleAvatar(child: CircleAvatar(child: Icon(Icons.search),radius: 24),radius: 26,backgroundColor: Colors.purple)),
                ),
              ),
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(child: CircleAvatar(child:ClipRRect(child: CachedNetworkImage(imageUrl: 'https://picsum.photos/300/300',fit: BoxFit.cover,),borderRadius: BorderRadius.circular(10000.0),),radius: 24),radius: 26,backgroundColor: Colors.purple),
                ),
              ),
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(child: CircleAvatar(child:ClipRRect(child: CachedNetworkImage(imageUrl: 'https://picsum.photos/300/300',fit: BoxFit.cover,),borderRadius: BorderRadius.circular(10000.0),),radius: 24),radius: 26,backgroundColor: Colors.purple),
                ),
              ),
              InkWell(
                onTap: (){},
                borderRadius: BorderRadius.circular(50),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CircleAvatar(child: CircleAvatar(child:ClipRRect(child: CachedNetworkImage(imageUrl: 'https://picsum.photos/300/300',fit: BoxFit.cover,),borderRadius: BorderRadius.circular(10000.0),),radius: 24),radius: 26,backgroundColor: Colors.purple),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

  Widget scaffondCatalogo({required BuildContext buildContext}) {
    return Scaffold(
      /* AppBar persistente que nunca se desplaza */
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Theme.of(buildContext).canvasColor,
        iconTheme: Theme.of(buildContext)
            .iconTheme
            .copyWith(color: Theme.of(buildContext).textTheme.bodyText1!.color),
        title: InkWell(
          onTap: () => showModalBottomSheetSetting(buildContext),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: <Widget>[
                Text(
                    controller.profileBusiness.id == ''
                        ? "Seleccionar cuenta"
                        : controller.profileBusiness.nombreNegocio != ""
                            ? controller.profileBusiness.nombreNegocio
                            : "Mi catalogo",
                    style: TextStyle(
                        color:
                            Theme.of(buildContext).textTheme.bodyText1!.color),
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
                //showModalBottomSheetConfig(buildContext: buildContext);
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
                        imageUrl: controller.profileBusiness.imagenPerfil,
                        placeholder: (context, url) => FadeInImage(
                            image: AssetImage("assets/loading.gif"),
                            placeholder: AssetImage("assets/loading.gif")),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              controller.getUserAuth.displayName
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
          ),
        ],
      ),
      body: ListView(),
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
        child: AnimatedFloatingActionButton(
            //Fab list
            fabButtons: <Widget>[
              FloatingActionButton(
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
                  heroTag: "Escribir codigo",
                  child: Icon(Icons.edit),
                  tooltip: 'Escribe el codigo del producto',
                  onPressed: () {
                    Navigator.of(buildContext).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            Text('FloatingActionButton') //WidgetSeachProduct(),
                        ));
                  })
            ],
            colorEndAnimation: Colors.grey,
            animatedIconData: AnimatedIcons.menu_close //To principal button
            ),
      ),
    );
  }

  // Widgets
  Widget body({required BuildContext buildContext}) {
    return DefaultTabController(
      length: 1,
      child: NestedScrollView(
        /* le permite crear una lista de elementos que se desplazarían hasta que el cuerpo alcanzara la parte superior */
        floatHeaderSlivers: true,
        physics: BouncingScrollPhysics(),
        headerSliverBuilder: (context, _) {
          return [
            SliverList(
              delegate: SliverChildListDelegate([
                /* Global.listProudctosNegocio.length != 0
                    ? SizedBox(height: 12.0)
                    : Container(),
                Global.listProudctosNegocio.length != 0
                    ? widgetsListaHorizontalMarcas(buildContext: buildContext)
                    : Container(),
                Global.listProudctosNegocio.length != 0
                    ? widgetBuscadorView(buildContext: buildContext)
                    : Container(),
                Global.listProudctosNegocio.length != 0
                    ? SizedBox(height: 12.0)
                    : Container(), */
              ]),
            ),
          ];
        },
        body: Column(
          children: <Widget>[
            Divider(height: 0.0),
            TabBar(
              indicatorColor: Theme.of(buildContext).accentColor,
              indicatorWeight: 5.0,
              labelColor: Theme.of(buildContext).brightness == Brightness.dark
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
                /* Consumer<ProviderCatalogo>(
                  child: Tab(
                      text:
                          "Todos (${Global.listProudctosNegocio.length.toString()})"),
                  builder: (context, catalogo, child) {
                    return Tab(
                        text: catalogo.sNombreFiltro +
                            " (${catalogo.categoria != null ? catalogo.cataloLoadMore.length.toString() : Global.listProudctosNegocio.length.toString()})");
                  },
                ), */
              ],
            ),
            Divider(height: 0.0),
            Expanded(
              child: TabBarView(
                children: [
                  /* Global.listProudctosNegocio.length != 0
                      ? WidgetCatalogoGridList()
                      : Center(
                          child: Text("Todavía no has añadido ningún producto"),
                        ), */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget widgetBuscadorView({required BuildContext buildContext}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Card(
        color: Theme.of(buildContext).brightness == Brightness.dark
            ? Colors.black12
            : Colors.white,
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: InkWell(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Icon(Icons.search,
                    color: Theme.of(buildContext).brightness == Brightness.dark
                        ? Colors.white38
                        : Colors.black54),
                SizedBox(
                  width: 12.0,
                ),
                Text(
                  'Buscar',
                  style: TextStyle(
                      color:
                          Theme.of(buildContext).brightness == Brightness.dark
                              ? Colors.white38
                              : Colors.black54),
                ),
              ],
            ),
          ),
          onTap: () {
            /* showSearch(
                context: buildContext,
                delegate: DataSearch(listOBJ: Global.listProudctosNegocio)); */
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 1,
        margin: EdgeInsets.all(0.0),
      ),
    );
  }

  Widget getAdminUserData({required String idNegocio}) {
    return Text("Tipo de permiso no definido");
    /* return FutureBuilder(
      future: Global.getDataAdminUserNegocio(
              idNegocio: idNegocio, idUserAdmin: controller.userAuth.uid)
          .getDataAdminUsuarioCuenta(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AdminUsuarioCuenta adminUsuarioCuenta = snapshot.data;
          switch (adminUsuarioCuenta.tipocuenta) {
            case 0:
              return Text("Tipo de permiso no definido");
            case 1:
              return Text("Administrador");
            case 2:
              return Text("Estandar");
            default:
              return Text("Se produj un error al obtener los datos!");
          }
        } else {
          return Text("Cargando datos...");
        }
      },
    ); */
  }

  Widget widgetsListaHorizontalMarcas({required BuildContext buildContext}) {
    /* Declarar variables */
    List<Color> colorGradientInstagram = [
      Color.fromRGBO(129, 52, 175, 1.0),
      Color.fromRGBO(129, 52, 175, 1.0),
      Color.fromRGBO(221, 42, 123, 1.0),
      Color.fromRGBO(68, 0, 71, 1.0)
    ];
    return Container();

    /* return Consumer<ProviderCatalogo>(builder: (context, catalogo, child) {
      if (catalogo.getMarcas.length == 0) {
        return Container();
      }
      return SizedBox(
        height: 110.0,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: catalogo.getMarcas.length,
            itemBuilder: (BuildContext c, int index) {
              return catalogo.getMarcas[index]!=null&& catalogo.getMarcas[index]!=""?Container(
                width: 81.0,
                height: 100.0,
                padding: EdgeInsets.all(5.0),
                child: FutureBuilder(
                  future: Global.getMarca(idMarca: catalogo.getMarcas[index]??"default").getDataMarca(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      Marca marca = snapshot.data;
                      return GestureDetector(
                        onTap: () {
                          buildContext
                              .read<ProviderCatalogo>()
                              .setIdMarca = marca.id;
                          buildContext
                              .read<ProviderCatalogo>()
                              .setNombreFiltro = marca.titulo;
                        },
                        child: Column(
                          children: <Widget>[
                            image.DashedCircle(
                              dashes:
                                  catalogo.getNumeroDeProductosDeMarca(id: marca.id),
                              gradientColor: colorGradientInstagram,
                              child: Padding(
                                padding: EdgeInsets.all(5.0),
                                child: image.viewCircleImage(
                                    url: marca.url_imagen,
                                    texto: marca.titulo,
                                    size: 50),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(marca.titulo,
                                style: TextStyle(
                                    fontSize:
                                        catalogo.getIdMarca == marca.id
                                            ? 14
                                            : 12,
                                    fontWeight:
                                        catalogo.getIdMarca == marca.id
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                overflow: TextOverflow.fade,
                                softWrap: false)
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        children: <Widget>[
                          image.DashedCircle(
                            dashes: 1,
                            gradientColor: colorGradientInstagram,
                            child: CircleAvatar(
                              backgroundColor: Colors.black26,
                              radius: 30,
                            ),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text("null",
                              style: TextStyle(
                                  fontSize:12,
                                  fontWeight: FontWeight.normal),
                              overflow: TextOverflow.fade,
                              softWrap: false)
                        ],
                      );
                    }
                  },
                ),
              ):Container();
            }),
      );
    }); */
  }

  // ShowModalBottomSheet
  void showModalBottomSheetSetting(BuildContext buildContext) {
    showModalBottomSheet(
        context: buildContext,
        clipBehavior: Clip.antiAlias,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        builder: (context) {
          return ListView(
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.all(12.0),
                leading: controller.profileBusiness.imagenPerfil == ""
                    ? CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 18.0,
                        child: Text(
                            controller.profileBusiness.nombreNegocio
                                .substring(0, 1),
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      )
                    : CachedNetworkImage(
                        imageUrl: controller.profileBusiness.imagenPerfil,
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
                  //Get.to(ProfileCuenta(perfilNegocio: Global.oPerfilNegocio));
                },
              ),
              Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
              ListTile(
                contentPadding: EdgeInsets.all(12.0),
                leading: Icon(Theme.of(context).brightness != Brightness.light
                    ? Icons.brightness_high
                    : Icons.brightness_3),
                title: Text(Theme.of(context).brightness == Brightness.light
                    ? 'Aplicar de tema oscuro'
                    : 'Aplicar de tema claro'),
                onTap: WidgetsUtilsApp().switchTheme(),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Contacto",
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
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
        });
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
