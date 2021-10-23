import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
        onPressed: ThemeService().switchTheme);
  }

  Function() switchTheme() => ThemeService().switchTheme;

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

  return Container(
    width: size,
    height: size,
    child: url == "" || url == "default"
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

class ProductoItem extends StatelessWidget {
  final ProductoNegocio producto;
  final double width;
  ProductoItem({required this.producto, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: Hero(
        tag: producto.id,
        child: Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              Get.toNamed(Routes.PRODUCT, arguments: {'product': producto});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    WidgetImagenProducto(producto: producto),
                    WidgetContentInfo(producto: producto),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WidgetImagenProducto extends StatelessWidget {
  const WidgetImagenProducto({required this.producto});
  final ProductoNegocio producto;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 100 / 100,
      child: producto.urlimagen != ""
          ? CachedNetworkImage(
              fadeInDuration: Duration(milliseconds: 200),
              fit: BoxFit.cover,
              imageUrl: producto.urlimagen,
              placeholder: (context, url) => FadeInImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/loading.gif"),
                  placeholder: AssetImage("assets/loading.gif")),
              errorWidget: (context, url, error) => Center(
                child: Text(
                  producto.titulo.substring(0, 3),
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            )
          : Container(color: Colors.black26),
    );
  }
}

class WidgetContentInfo extends StatelessWidget {
  const WidgetContentInfo({required this.producto});
  final ProductoNegocio producto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all( Radius.circular(12)),
        child: Container(
          color: Colors.black38,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0,sigmaY: 30.0,tileMode: TileMode.decal),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        producto.descripcion != ""
                            ? Text(producto.descripcion,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0,
                                    color: Colors.white),
                                overflow: TextOverflow.fade,
                                softWrap: false)
                            : Container(),
                        producto.precioVenta != 0.0
                            ? Text(
                                Publicaciones.getFormatoPrecio(
                                    monto: producto.precioVenta),
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
      ),
    );
  }
}

class WidgetButtonListTile extends StatelessWidget {
  final BuildContext buildContext;
  final WelcomeController controller = Get.find<WelcomeController>();

  WidgetButtonListTile({required this.buildContext});

  @override
  Widget build(BuildContext context) {
    return buttonListTileCrearCuenta(context: buildContext);
  }

  Widget buttonListTileCrearCuenta({required BuildContext context}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      leading: CircleAvatar(
        radius: 24.0,
        child: Icon(Icons.add),
      ),
      dense: true,
      title:
          Text("Crear cuenta para empresa", style: TextStyle(fontSize: 16.0)),
      onTap: () {
        /* Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => ProfileCuenta(
              perfilNegocio: null,
              createCuenta: true,
            ),
          ),
        ); */
      },
    );
  }

  Widget buttonListTileCerrarSesion({required BuildContext buildContext}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      leading: controller.getProfileAccountSelected.imagenPerfil == ""
          ? CircleAvatar(
              backgroundColor: Colors.black26,
              radius: 24.0,
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
              placeholder: (context, url) => CircleAvatar(
                backgroundColor: Colors.black26,
                radius: 24.0,
                child: Text(
                    controller.getProfileAccountSelected.nombreNegocio
                        .substring(0, 1),
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
      {required BuildContext buildContext,
      required ProfileBusinessModel perfilNegocio,
      bool adminPropietario = false}) {
    if (perfilNegocio.id == '') {
      return Container();
    }
    return Column(
      children: <Widget>[
        ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(10000.0),
            child: perfilNegocio.imagenPerfil != '' ||
                    perfilNegocio.imagenPerfil.isNotEmpty
                ? CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 200),
                    fit: BoxFit.cover,
                    imageUrl: perfilNegocio.imagenPerfil.contains('https://')
                        ? perfilNegocio.imagenPerfil
                        : "https://" + perfilNegocio.imagenPerfil,
                    placeholder: (context, url) => CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 24.0,
                      child: Text(perfilNegocio.nombreNegocio.substring(0, 1),
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
                      child: Text(perfilNegocio.nombreNegocio.substring(0, 1),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                  )
                : CircleAvatar(
                    backgroundColor: Colors.black26,
                    radius: 24.0,
                    child: Text(perfilNegocio.nombreNegocio.substring(0, 1),
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
          ),
          dense: true,
          title: Text(perfilNegocio.nombreNegocio),
          subtitle: !adminPropietario
              ? Text(perfilNegocio.admin)
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
            value: controller.getSelected(id:perfilNegocio.id ) ? 0 : 1,
            groupValue: 0,
            onChanged: (val) {
              controller.accountChange(idAccount: perfilNegocio.id);
              /* Global.actualizarPerfilNegocio(
                    perfilNegocio: perfilNegocio);
                Navigator.of(buildContext).pushNamedAndRemoveUntil(
                    '/page_principal', (Route<dynamic> route) => false); */
            },
          ),
          onTap: () {
            controller.accountChange(idAccount: perfilNegocio.id);
            /* if (perfilNegocio.id != "") {
                Global.actualizarPerfilNegocio(
                    perfilNegocio: perfilNegocio);
                Navigator.of(buildContext).pushNamedAndRemoveUntil(
                    '/page_principal', (Route<dynamic> route) => false);
              } */
          },
        ),
      ],
    );
  }

  Widget _getAdminUserData({required String idNegocio}) {
    return Text(idNegocio);
    /* return FutureBuilder(
      future: Global.getDataAdminUserNegocio(idNegocio: idNegocio, idUserAdmin: firebaseUser.uid)
          .getDataAdminUsuarioCuenta(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          AdminUsuarioCuenta adminUsuarioCuenta = snapshot.data;
          switch (adminUsuarioCuenta.tipocuenta) {
            case 0:
              return Row(
                children: [
                  Icon(
                    Icons.security,
                    size: 12.0,
                    color: Theme.of(context).hintColor,
                  ),
                  SizedBox(width: 2.0),
                  Text("Administrador")
                ],
              );
            case 1:
              return Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 12.0,
                    color: Theme.of(context).hintColor,
                  ),
                  SizedBox(width: 2.0),
                  Text("Estandar")
                ],
              );
            default:
              return Row(
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 12.0,
                    color: Theme.of(context).hintColor,
                  ),
                  SizedBox(width: 2.0),
                  Text("Estandar")
                ],
              );
          }
        } else {
          return Text("Cargando datos...");
        }
      },
    ); */
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
        onWillPop: () => Future.value( false), 
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
