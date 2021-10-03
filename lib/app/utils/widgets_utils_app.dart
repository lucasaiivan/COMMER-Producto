import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
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
