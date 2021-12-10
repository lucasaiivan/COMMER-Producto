import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/modules/product/controllers/product_controller.dart';
import 'package:producto/app/services/database.dart';
import 'package:producto/app/utils/functions.dart';
import 'package:producto/app/utils/widgets_utils_app.dart' as utilsWidget;

class Product extends GetView<ProductController> {
  const Product({Key? key}) : super(key: key);

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
      title: InkWell(
        onTap: () {
          /* if (contextScaffold != null) {
              Clipboard.setData(new ClipboardData(text: widget.producto.codigo))
                  .then((_) {
                ScaffoldMessenger.of(contextScaffold).showSnackBar(SnackBar(
                    content: Text("Código copiado en portapapeles: " +
                        widget.producto.id)));
              });
            } */
        },
        child: Obx(() => Row(
              children: <Widget>[
                controller.getProduct.verificado == true
                    ? Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: new Image.asset('assets/icon_verificado.png',
                            width: 14.0, height: 14.0))
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
      ),
      actions: [
        IconButton(
          padding: EdgeInsets.all(12.0),
          icon: Icon(Icons.center_focus_strong),
          onPressed: () {
            showGeneralDialog(
                context: context,
                barrierDismissible: true,
                barrierLabel:
                    MaterialLocalizations.of(context).modalBarrierDismissLabel,
                barrierColor: Colors.black45,
                transitionDuration: const Duration(milliseconds: 200),
                pageBuilder: (BuildContext buildContext, Animation animation,
                    Animation secondaryAnimation) {
                  return Container();
                  /* Timer(Duration(seconds: 1), () {
                      // Captura de widgets
                      screenshotController.capture().then((File image) {
                        Navigator.pop(buildContext);
                        //share
                        Share.shareFiles(['${image.path}']);
                      }).catchError((onError) {
                        print(onError);
                      });
                    });

                    // Get available height and width of the build area of this widget. Make a choice depending on the size.
                    var height = MediaQuery.of(buildContext).size.height;
                    var width = MediaQuery.of(buildContext).size.width;
                    
                    return Screenshot(
                      controller: screenshotController,
                      child: viewProducto(height: height, width: width),
                    ); */
                });
          },
        ),
        IconButton(
          padding: EdgeInsets.all(12.0),
          icon: Icon(true ? Icons.edit : Icons.add_box),
          onPressed: () {
            controller.toProductEdit();
          },
        ),
        IconButton(
          padding: EdgeInsets.all(12.0),
          icon: Icon(Icons.new_releases),
          onPressed: () {
            // show the dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                TextStyle textStyleTitle = TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: "Poppins");
                // set up the AlertDialog
                return AlertDialog(
                  titleTextStyle: TextStyle(color: Colors.white),
                  backgroundColor: Colors.red[400],
                  title: Row(
                    children: [
                      Icon(Icons.new_releases, color: Colors.white),
                      SizedBox(
                        height: 5.0,
                        width: 5.0,
                      ),
                      Text("Algo no esta bien!", style: textStyleTitle)
                    ],
                  ),
                  content: Text(
                    "Envíe una solicitud de revisión para este producto si:\n\n# La imagen no tiene relación con el codigo del producto\n\n# El nombre o descripción esta mal",
                    style: TextStyle(color: Colors.white60),
                  ),
                  actions: [
                    // set up the button
                    FlatButton(
                      child: Text("Cancelar",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    FlatButton(
                      child: Text("Enviar solicitud",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        // Firebase set
                        /* widget.producto.verificado = false;
                        await Global.getProductosPrecargado(
                                idProducto: widget.producto.id, isoPAis: "ARG")
                            .upSetPrecioProducto(widget.producto
                                .convertProductoDefault()
                                .toJson()); 
                        Navigator.of(context).pop(); */
                      },
                    ),
                  ],
                );
              },
            );
          },
        )
      ],
    );
  }

  Widget body() {
    return ExpandableBottomSheet(
      background: background(),
      persistentHeader: persistentHeader(
          colorBackground: Get.theme.cardColor, colorText: Colors.white),
      expandableContent: expandableContent(
          colorBackground: Get.theme.cardColor, colorText: Colors.white),
    );
  }

  // WIDGETS VIEWS
  Widget widgetDescripcion(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, right: 12, left: 12, top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          true
              ? Wrap(
                  spacing: 8.0, // gap between adjacent chips
                  runSpacing: 4.0, // gap between lines
                  direction: Axis.horizontal, // main axis (rows or columns)
                  children: <Widget>[
                    /* this.categoria != null && this.categoria.nombre != ""
                        ? Chip(
                            materialTapTargetSize:MaterialTapTargetSize.shrinkWrap,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Text(
                                  this.categoria.nombre.substring(0, 1) ?? "C",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            label: Text(
                              this.categoria.nombre,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Container(),
                    this.subcategoria != null && this.subcategoria.nombre != ""
                        ? Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            avatar: CircleAvatar(
                              backgroundColor: Colors.grey.shade800,
                              child: Text(
                                  this.subcategoria.nombre.substring(0, 1) ??
                                      "C",
                                  style: TextStyle(color: Colors.grey)),
                            ),
                            label: Text(
                              this.subcategoria.nombre,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Container(), */
                  ],
                )
              : Container(),
          /* controller.getProduct.titulo != ""
              ? Container(
                  child: Text(controller.getProduct.titulo,
                      style: TextStyle(
                          height: 2, fontSize: 30, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.fade,
                      softWrap: false),
                )
              : Container(),
          SizedBox(
            height: 8.0,
            width: 8.0,
          ), */
          controller.getProduct.descripcion != ""
              ? Text(controller.getProduct.descripcion,
                  style: TextStyle(
                      height: 1, fontSize: 16, fontWeight: FontWeight.normal))
              : Container(),
          controller.getProduct.codigo != ""
              ? SizedBox(height: 5)
              : Container(),
          controller.getProduct.codigo != ""
              ? Opacity(
                  opacity: 0.8,
                  child: Text(controller.getProduct.codigo,
                      style: TextStyle(
                          height: 1,
                          fontSize: 12,
                          fontWeight: FontWeight.normal)),
                )
              : Container(),
        ],
      ),
    );
  }

  // WIDGETS COMPONENTS
  Widget background() {
    return Builder(builder: (contextBuilder) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 12),
            imageViewCard(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widgetDescripcion(contextBuilder),
                /*productoEnCatalogo
                    ? WidgetOtrosProductos(
                        producto: widget.producto,
                        subcategoria: this.subcategoria)
                    : Container(),*/
                otrosProductosEnCatalogo(),
                otrosProductosViewList(),
                const SizedBox(height: 120.0, width: 120.0),
              ],
            ),
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
        padding:
            EdgeInsets.only(bottom: 50.0, left: 12.0, right: 12.0, top: 12.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: [
                        controller.getProduct.precioVenta != 0.0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                        Publicaciones.getFormatoPrecio(
                                            monto: controller
                                                .getProduct.precioVenta),
                                        style: TextStyle(
                                            color: colorText,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.end),
                                    Row(
                                      children: [
                                        controller.getProduct.precioCompra !=
                                                0.0
                                            ? Text(
                                                ' ${Publicaciones.getFormatoPrecio(monto: controller.getProduct.precioCompra)} ',
                                                style:
                                                    TextStyle(fontSize: 12.0))
                                            : Container(),
                                        controller.getProduct.precioCompra !=
                                                0.0
                                            ? Text(
                                                sProcentaje(
                                                    precioCompra: controller
                                                        .getProduct
                                                        .precioCompra,
                                                    precioVenta: controller
                                                        .getProduct
                                                        .precioVenta),
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : Container(),
                                        controller.getProduct.precioCompra !=
                                                0.0
                                            ? Text(" > ",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 12.0))
                                            : Container(),
                                        controller.getProduct.precioCompra !=
                                                0.0
                                            ? Text(
                                                Publicaciones.sGanancia(
                                                    precioCompra: controller
                                                        .getProduct
                                                        .precioCompra,
                                                    precioVenta: controller
                                                        .getProduct
                                                        .precioVenta),
                                                style: TextStyle(
                                                    color: controller.getProduct
                                                                .precioCompra <
                                                            controller
                                                                .getProduct
                                                                .precioVenta
                                                        ? Colors.green
                                                        : Colors.red,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold))
                                            : Container(),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        /* controller.getProduct.precioComparacion != null &&
                                controller.getProduct.precioComparacion != 0.0
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Publicaciones.getFormatoPrecio(
                                      monto:
                                          widget.producto.precio_comparacion),
                                  style: TextStyle(
                                      color: colorText,
                                      decoration: TextDecoration.lineThrough,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            : Container(), */
                        /* controller.getProduct.timestampActualizacion != null
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Publicaciones.getFechaPublicacion(
                                          widget
                                              .producto.timestamp_actualizacion
                                              .toDate(),
                                          new DateTime.now())
                                      .toLowerCase(),
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: colorText),
                                ),
                              )
                            : Container(), */
                      ],
                    )
                  : Container(),
              Icon(Icons.keyboard_arrow_up, color: colorText),
              Text(
                'Deslice hacia arriba para ver los últimos precios publicados',
                textAlign: TextAlign.center,
                style: TextStyle(color: colorText),
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
            color: colorBackground,
            padding: EdgeInsets.only(
                bottom: 50.0, left: 12.0, right: 12.0, top: 12.0),
            child: ultimosPreciosView())));
  }

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
            //physics: const AlwaysScrollableScrollPhysics(),
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 0.16),
            shrinkWrap: true,
            itemCount: controller.getListPricesForProduct.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                  future: Database.readProfileBusinessModelFuture(
                      controller.getListPricesForProduct[index].idNegocio),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      ProfileBusinessModel perfilNegocio =
                          ProfileBusinessModel.fromDocumentSnapshot(
                              documentSnapshot:
                                  snapshot.data as DocumentSnapshot);
                      return Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 0.0),
                            leading: controller.getListPricesForProduct[index]
                                            .idNegocio ==
                                        "" ||
                                    perfilNegocio.imagenPerfil == "default"
                                ? CircleAvatar(
                                    backgroundColor: Colors.black26,
                                    radius: 24.0,
                                    child: Text(
                                        perfilNegocio.nombreNegocio
                                            .substring(0, 1),
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: colorText,
                                            fontWeight: FontWeight.bold)),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: perfilNegocio.imagenPerfil,
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
                                  ),
                            title: Text(
                              Publicaciones.getFormatoPrecio(
                                  monto: controller
                                      .getListPricesForProduct[index].precio),
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
                                              .timestamp
                                              .toDate(),
                                          new DateTime.now())
                                      .toLowerCase(),
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                      fontStyle: FontStyle.normal,
                                      color: colorText),
                                ),
                                controller.getListPricesForProduct[index]
                                            .ciudad !=
                                        ""
                                    ? Text(
                                        "En " +
                                            controller
                                                .getListPricesForProduct[index]
                                                .ciudad
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
              imageUrl: controller.getProduct.urlimagen,
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
                    'Text',
                    //controller.getProduct.titulo.substring(0, 3),
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
                          url: controller.getMark.urlImage,
                          texto: controller.getMark.name),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget otrosProductosViewList() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(endIndent: 12.0, indent: 12.0),
            Padding(
              child: Row(
                children: [
                  Text("Otros productos", style: TextStyle(fontSize: 16.0)),
                  controller.getMark.id != ''
                      ? Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          child: Chip(
                            elevation: 5,
                            backgroundColor: Get.theme.backgroundColor,
                            avatar: utilsWidget.viewCircleImage(
                                url: controller.getMark.urlImage,
                                texto: controller.getMark.name,
                                size: 20),
                            label: Text(controller.getMark.name),
                          ),
                        )
                      : Container(),
                ],
              ),
              padding:
                  const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12),
            ),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.getListOthersProductsForMark.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: 150.0,
                      height: 150.0,
                      child: itemProduct(
                        product: controller.getListOthersProductsForMark[index],
                      ));
                },
              ),
            ),
          ],
        ));
  }

  Widget otrosProductosEnCatalogo() {
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(endIndent: 12.0, indent: 12.0),
            Padding(
              child: Text("En mi catálogo", style: TextStyle(fontSize: 16.0)),
              padding: const EdgeInsets.all(12),
            ),
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.getListOthersProductsForMark.length,
                itemBuilder: (context, index) {
                  return Container(
                      width: 150.0,
                      height: 150.0,
                      child: itemProduct(
                        product: controller.getListOthersProductsForMark[index],
                      ));
                },
              ),
            ),
          ],
        ));
  }

  Widget itemProduct({required Producto product}) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 200.0,
      height: 200.0,
      child: Card(
        elevation: 5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            /* Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => producto != null
                    ? ProductScreen(producto: producto)
                    : Scaffold(
                        body: Center(child: Text("Se produjo un Error!"))),
              ),
            ); */
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 100 / 100,
                    child: product.urlImagen != ""
                        ? CachedNetworkImage(
                            fadeInDuration: Duration(milliseconds: 200),
                            fit: BoxFit.cover,
                            imageUrl: product.urlImagen,
                            placeholder: (context, url) => FadeInImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/loading.gif"),
                                placeholder: AssetImage("assets/loading.gif")),
                            errorWidget: (context, url, error) =>
                                Container(color: Colors.black12),
                          )
                        : Container(color: Colors.black26),
                  ),
                  Container(
                    color: Colors.black54,
                    child: ClipRect(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: <Widget>[
                                  product.titulo != "" &&
                                          product.titulo != "default"
                                      ? Text(product.titulo,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                          overflow: TextOverflow.fade,
                                          softWrap: false)
                                      : Container(),
                                  product.descripcion != ""
                                      ? Text(product.descripcion,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                              color: Colors.white),
                                          overflow: TextOverflow.fade,
                                          softWrap: false)
                                      : Container(),
                                  product.precioVenta != 0.0
                                      ? Text(
                                          "${Publicaciones.getFormatoPrecio(monto: product.precioVenta)}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.white),
                                          overflow: TextOverflow.fade,
                                          softWrap: false)
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          // Text(topic.description)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
