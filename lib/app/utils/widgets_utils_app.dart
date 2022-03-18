import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/utils/functions.dart';
import 'dart:math';
import 'dynamicTheme_lb.dart';

class WidgetsUtilsApp extends StatelessWidget {
  WidgetsUtilsApp({Key? key}) : super(key: key);

  Widget buttonThemeBrightness({required BuildContext context, Color? color}) {
    if (color == null)
      color = Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;
    return IconButton(
        icon: Icon(
            Theme.of(context).brightness == Brightness.light
                ? Icons.brightness_high
                : Icons.brightness_3,
            color: color),
        onPressed: ThemeService.switchTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

const int _DefaultDashes = 20;
const List<Color> _DefaultGradient = [Color.fromRGBO(129, 52, 175, 1.0)];
const double _DefaultGapSize = 3.0;
const double _DefaultStrokeWidth = 2.0;

class DashedCircle extends StatelessWidget {
  final int dashes;
  final List<Color> gradientColor;
  final double gapSize;
  final double strokeWidth;
  final Widget child;

  DashedCircle(
      {required this.child,
      this.dashes = _DefaultDashes,
      this.gradientColor = _DefaultGradient,
      this.gapSize = _DefaultGapSize,
      this.strokeWidth = _DefaultStrokeWidth});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedCirclePainter(
          gradientColor: gradientColor,
          dashes: dashes,
          gapSize: gapSize,
          strokeWidth: strokeWidth),
      child: child,
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  final int dashes;
  final List<Color> gradientColor;
  final double gapSize;
  final double strokeWidth;

  DashedCirclePainter(
      {this.dashes = _DefaultDashes,
      this.gradientColor = _DefaultGradient,
      this.gapSize = _DefaultGapSize,
      this.strokeWidth = _DefaultStrokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final double gap = pi / 180 * gapSize;
    final double singleAngle = (pi * 2) / dashes;

    // create a bounding square, based on the centre and radius of the arc
    Rect rect = new Rect.fromCircle(
      center: new Offset(165.0, 55.0),
      radius: 190.0,
    );

    for (int i = 0; i < dashes; i++) {
      final Paint paint = Paint()
        ..shader = RadialGradient(colors: gradientColor).createShader(rect)
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

      canvas.drawArc(Offset.zero & size, gap + singleAngle * i,
          singleAngle - gap * 1, false, paint);
    }
  }

  @override
  bool shouldRepaint(DashedCirclePainter oldDelegate) {
    return dashes != oldDelegate.dashes;
  }
}

Widget viewCircleImage(
    {required String url, required String texto, double size = 85.0}) {
  if (texto == '') texto = 'Image';

  Widget imageDefault = CircleAvatar(
    backgroundColor: Colors.black26,
    radius: size,
    child: Text(texto.substring(0, 1),
        style: TextStyle(
            fontSize: size / 2,
            color: Colors.white,
            fontWeight: FontWeight.bold)),
  );

  return Container(
    width: size,
    height: size,
    child: url == "" || url == "default"
        ? imageDefault
        : CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => imageDefault,
            imageBuilder: (context, image) => CircleAvatar(
              backgroundImage: image,
              radius: size,
            ),
            errorWidget: (context, url, error) => imageDefault,
          ),
  );
}

class ProductoItem extends StatefulWidget {
  final ProductCatalogue producto;

  ProductoItem({required this.producto});

  @override
  State<ProductoItem> createState() => _ProductoItemState();
}

class _ProductoItemState extends State<ProductoItem> {
  // controllers
  final WelcomeController welcomeController = Get.find<WelcomeController>();

  @override
  Widget build(BuildContext context) {
    // aparición animada
    return ElasticIn(
      // transición animada
      child: Hero(
        tag: widget.producto.id,
        // widget
        child: Card(
          color: Colors.white,
          elevation: welcomeController.getSelectItems
              ? widget.producto.select
                  ? 4
                  : 0
              : 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          clipBehavior: Clip.antiAlias,
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
                    onTap: () => Get.toNamed(Routes.PRODUCT,
                        arguments: {'product': widget.producto}),
                    onLongPress: () {
                      welcomeController.setSelectItems =
                          !welcomeController.getSelectItems;
                      widget.producto.select = true;
                      welcomeController.updateSelectItemsLength();
                    },
                  ),
                ),
              ),
              // state selecct item
              welcomeController.getSelectItems
                  ? Positioned.fill(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          child: Container(
                              color: widget.producto.select
                                  ? Colors.grey.withOpacity(0.0)
                                  : Colors.grey.withOpacity(0.4)),
                          onTap: () {
                            setState(() {
                              widget.producto.select = !widget.producto.select;
                              welcomeController.updateSelectItemsLength();
                            });
                          },
                        ),
                      ),
                    )
                  : Container(),
              // icon notify selecct item
              widget.producto.select
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 14,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget contentImage() {
    return widget.producto.image != ""
        ? Container(
            width: double.infinity,
            child: CachedNetworkImage(
              fadeInDuration: Duration(milliseconds: 200),
              fit: BoxFit.cover,
              imageUrl: widget.producto.image,
              placeholder: (context, url) => Container(
                color: Colors.grey[100],
                child: Center(
                  child: Text(
                    widget.producto.description.substring(0, 4),
                    style: TextStyle(fontSize: 24.0, color: Colors.grey),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[100],
                child: Center(
                  child: Text(
                    widget.producto.description.substring(0, 4),
                    style: TextStyle(fontSize: 24.0, color: Colors.grey),
                  ),
                ),
              ),
            ),
          )
        : Container(
            color: Colors.grey[100],
            child: Center(
              child: Text(
                widget.producto.description.substring(0, 4),
                style: TextStyle(fontSize: 24.0, color: Colors.grey),
              ),
            ),
          );
  }

  Widget contentInfo() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.producto.description,
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14.0,
                  color: Colors.grey),
              overflow: TextOverflow.fade,
              softWrap: false),
          Text(Publicaciones.getFormatoPrecio(monto: widget.producto.salePrice),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black),
              overflow: TextOverflow.fade,
              softWrap: false),
        ],
      ),
    );
  }
}

class WidgetButtonListTile extends StatelessWidget {
  final WelcomeController controller = Get.find<WelcomeController>();

  WidgetButtonListTile();

  @override
  Widget build(BuildContext context) {
    return buttonListTileCrearCuenta();
  }

  Widget buttonListTileCrearCuenta() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      leading: CircleAvatar(
        backgroundColor: Colors.black45,
        radius: 24.0,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      dense: true,
      title: Text("Crear cuenta", style: TextStyle(fontSize: 16.0)),
      onTap: () {
        Get.back();
        Get.toNamed(Routes.ACCOUNT);
      },
    );
  }

  Widget buttonListTileCerrarSesion({required BuildContext buildContext}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      leading: controller.getProfileAccountSelected.image == ""
          ? CircleAvatar(
              backgroundColor: Colors.black26,
              radius: 24.0,
              child: Text(
                  controller.getProfileAccountSelected.name.substring(0, 1),
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            )
          : CachedNetworkImage(
              imageUrl: controller.getProfileAccountSelected.image,
              placeholder: (context, url) => CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 24.0,
                child: Text(
                    controller.getProfileAccountSelected.name.substring(0, 1),
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
              imageBuilder: (context, image) => CircleAvatar(
                backgroundImage: image,
                radius: 24.0,
              ),
            ),
      dense: true,
      title: Text("Cerrar sesión", style: TextStyle(fontSize: 16.0)),
      subtitle: null,
      trailing: Icon(Icons.close),
      onTap: () {
        showDialogCerrarSesion(buildContext: buildContext);
      },
    );
  }

  void showDialogCerrarSesion({required BuildContext buildContext}) {
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Cerrar sesión"),
          content: new Text("¿Estás seguro de que quieres cerrar la sesión?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("si"),
              onPressed: () async {
                /* // Default values
                Global.actualizarPerfilNegocio(perfilNegocio: null);
                AuthService auth = AuthService();
                await auth.signOut();
                Future.delayed(const Duration(milliseconds: 800), () {
                  Navigator.of(buildContext).pushNamedAndRemoveUntil(
                      '/', (Route<dynamic> route) => false);
                }); */
              },
            ),
          ],
        );
      },
    );
  }

  Widget buttonListTileItemCuenta(
      {required ProfileAccountModel perfilNegocio,
      bool adminPropietario = false}) {
    if (perfilNegocio.id == '') {
      return Container();
    }
    return Column(
      children: <Widget>[
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10000.0),
            child: perfilNegocio.image != '' || perfilNegocio.image.isNotEmpty
                ? CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 200),
                    fit: BoxFit.cover,
                    imageUrl: perfilNegocio.image.contains('https://')
                        ? perfilNegocio.image
                        : "https://" + perfilNegocio.image,
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 24.0,
                      child: Text(perfilNegocio.name.substring(0, 1),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    imageBuilder: (context, image) => CircleAvatar(
                      backgroundImage: image,
                      radius: 24.0,
                    ),
                    errorWidget: (context, url, error) => CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 24.0,
                      child: Text(perfilNegocio.name.substring(0, 1),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 24.0,
                    child: Text(perfilNegocio.name.substring(0, 1),
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
          ),
          dense: true,
          title: Text(perfilNegocio.name),
          subtitle: !adminPropietario
              ? Text(perfilNegocio.idAuthUserCreation)
              : Row(
                  children: [
                    Icon(
                      Icons.security,
                      size: 12.0,
                      color: Get.theme.hintColor,
                    ),
                    SizedBox(width: 2.0),
                    Text("Mi cuenta")
                  ],
                ),
          trailing: Radio(
            activeColor: Get.theme.primaryColor,
            value: controller.getSelected(id: perfilNegocio.id) ? 0 : 1,
            groupValue: 0,
            onChanged: (val) {
              controller.accountChange(idAccount: perfilNegocio.id);
            },
          ),
          onTap: () {
            controller.accountChange(idAccount: perfilNegocio.id);
          },
        ),
      ],
    );
  }
}

// RELEASE
// Mostrar un diálogo con Get.dialog()
// Pero en esto, no tenemos parámetros como título y contenido, tenemos que construirlos manualmente desde cero.

class CustomFullScreenDialog {
  static void showDialog() {
    Get.dialog(
      WillPopScope(
        //  WillPopScope - sirve para vetar los intentos del usuario de descartar la ModalRoute adjunta
        child: Container(
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.yellowAccent),
            ),
          ),
        ),
        // onWillPop - Se llama cada ves que el usuario intenta descartar el ModalRoute adjunta
        onWillPop: () => Future.value(false),
      ),
      barrierDismissible: false,
      barrierColor: Color(0xff141A31).withOpacity(.3),
      useSafeArea: true,
    );
  }

  static void cancelDialog() {
    Get.back();
  }
}

PreferredSize linearProgressBarApp({Color color = Colors.purple}) {
  return PreferredSize(
      preferredSize: Size.fromHeight(0.0),
      child: LinearProgressIndicator(
          minHeight: 6.0,
          backgroundColor: Colors.white.withOpacity(0.3),
          valueColor: new AlwaysStoppedAnimation<Color>(color)));
}

class WidgetSuggestionProduct extends StatelessWidget {
   bool searchButton = false;
   List<Product> list = <Product>[];
  WidgetSuggestionProduct({required this.list,this.searchButton=false});

  @override
  Widget build(BuildContext context) {
    // controllers
    WelcomeController welcomeController = Get.find<WelcomeController>();
    if (list.length == 0) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "sugerencias para ti",
            style: Get.theme.textTheme.subtitle1,
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            !searchButton?Container():InkWell(
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
            Container(
                width: 200,
                height: 100,
                child: Center(
                  child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Align(
                          widthFactor: 0.5,
                          child: InkWell(
                            onTap: () => welcomeController.toProductView(
                                porduct: list[index]),
                            borderRadius: BorderRadius.circular(50),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: FadeInRight(
                                child: CircleAvatar(
                                    foregroundColor: Colors.grey,
                                    child: CircleAvatar(
                                      foregroundColor: Colors.grey,
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                              imageUrl: list[index].image,
                                              fadeInDuration: Duration(milliseconds: 200),fit: BoxFit.cover,),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                        ),
                                        radius: 24),
                                    radius: 26,
                                    backgroundColor: Get.theme.primaryColor),
                              ),
                            ),
                          ),
                        );
                      }),
                )),
          ],
        ),
      ],
    );
  }
}
