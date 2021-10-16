import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/utils/functions.dart';
import 'dart:math';
import 'dynamicTheme_lb.dart';

class WidgetsUtilsApp extends StatelessWidget {
  WidgetsUtilsApp({Key? key}) : super(key: key);

  final appdata = GetStorage(); // instance of GetStorage

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
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(13), topRight: Radius.circular(13)),
      child: Container(
        color: Theme.of(context).primaryColorDark.withOpacity(0.70),//Colors.black54,
        child: ClipRect(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      producto.titulo != "" && producto.titulo != "default"
                          ? Text(producto.titulo,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              overflow: TextOverflow.fade,
                              softWrap: false)
                          : Container(),
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
                              Publicaciones.getFormatoPrecio(monto: producto.precioVenta),
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
    );
  }
}