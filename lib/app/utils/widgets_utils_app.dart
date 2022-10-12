import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/models/user_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/routes/app_pages.dart';
import 'package:producto/app/utils/functions.dart';
import 'package:rotated_corner_decoration/rotated_corner_decoration.dart'; 
import 'dynamicTheme_lb.dart';
import 'dart:math' as math;

class ComponentApp extends StatelessWidget {
  ComponentApp({Key? key}) : super(key: key);

  // animations 
  static PreferredSize linearProgressBarApp({Color color = Colors.purple}) {
  // animación para la carga de información
  return PreferredSize(preferredSize: Size.fromHeight(0.0),child: LinearProgressIndicator(minHeight: 6.0,backgroundColor: Colors.white.withOpacity(0.3),valueColor: new AlwaysStoppedAnimation<Color>(color)));
}

  // buttons
  Widget buttonThemeBrightness({required BuildContext context, Color? color}) {
    if (color == null) color = Theme.of(context).brightness == Brightness.dark? Colors.white: Colors.black;
    return IconButton(icon: Icon(Theme.of(context).brightness == Brightness.light? Icons.brightness_high: Icons.brightness_3,color: color),onPressed: ThemeService.switchTheme);
  }

  // image
  static Widget viewCircleImage({required String url, required String texto, double size = 85.0}) {
  //values
  MaterialColor color = Utils.getRandomColor();
  if (texto == '') texto = 'Image';

  Widget imageDefault = CircleAvatar(
    backgroundColor: color.withOpacity(0.1),
    radius: size,
    child: Text(texto.substring(0, 1),
        style: TextStyle(
          fontSize: size / 2,
          color: color,
          fontWeight: FontWeight.bold,
        )),
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
    final double gap = math.pi / 180 * gapSize;
    final double singleAngle = (math.pi * 2) / dashes;

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


class ProductoItem extends StatefulWidget {
  final ProductCatalogue producto;

  ProductoItem({required this.producto});

  @override
  State<ProductoItem> createState() => _ProductoItemState();
}

class _ProductoItemState extends State<ProductoItem> {
  // controllers
  final HomeController welcomeController = Get.find<HomeController>();

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
          elevation: welcomeController.getSelectItems? widget.producto.select? 4: 0: 3,
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
          clipBehavior: Clip.antiAlias,
          child: Container(
            // status : favorito
            foregroundDecoration: widget.producto.favorite? RotatedCornerDecoration(
              color: Colors.yellow.shade600,
              geometry: const BadgeGeometry(width: 48, height: 48),
              textSpan: TextSpan(
                text: 'Favorito',
                style: TextStyle(
                  fontSize: 10,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [BoxShadow(color: Colors.yellow, blurRadius: 4)],
                ),
              ),
            ):null,
            child: Container(
              // status : favorito
              foregroundDecoration: widget.producto.quantityStock <= widget.producto.alertStock == widget.producto.stock? RotatedCornerDecoration(
                color: Colors.red.shade600,
                geometry: const BadgeGeometry(width: 48, height: 48, alignment: BadgeAlignment.topLeft),
                textSpan: TextSpan(
                  text: widget.producto.quantityStock==0?'Sin\nstock':'Bajo\nStock',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [BoxShadow(color: Colors.red, blurRadius: 4)],
                  ),
                ),
              ):null,
              child: Stack(
                children: [
                  // imagen y información del producto
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: contentImage()),
                      contentInfo(),
                    ],
                    
                  ),
                  // zona Cliqueable
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Get.toNamed(Routes.PRODUCT, arguments: {'product': widget.producto}),
                        onLongPress: () {
                          welcomeController.setSelectItems = !welcomeController.getSelectItems;
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
                              child: Container(color: widget.producto.select? Colors.grey.withOpacity(0.0): Colors.grey.withOpacity(0.4)),
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
                              size: 14),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget contentImage() {
    return widget.producto.image != ""
        ? CachedNetworkImage(
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

    // values 
    late Color? colorContent=null;
    if(widget.producto.favorite){colorContent =Colors.amber.withOpacity(0.2);}
    if(widget.producto.quantityStock<=widget.producto.alertStock && widget.producto.stock){colorContent =Colors.red.withOpacity(0.2);}

    return Container(
      width: double.infinity,
      color: colorContent,
      child: Padding(
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
            Text(Publications.getFormatoPrecio(monto: widget.producto.salePrice),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.black),
                overflow: TextOverflow.fade,
                softWrap: false),
          ],
        ),
      ),
    );
  }
}

class WidgetButtonListTile extends StatelessWidget {
  
  final HomeController controller = Get.find<HomeController>();

  WidgetButtonListTile();

  @override
  Widget build(BuildContext context) {
    return buttonListTileCrearCuenta();
  }

  Widget buttonListTileCrearCuenta() {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      leading: Icon(Icons.add),
      dense: true,
      title: Text("Crear catálogo", style: TextStyle(fontSize: 16.0)),
      onTap: () {
        Get.back();
        Get.toNamed(Routes.ACCOUNT);
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
              ? Text(perfilNegocio.id)
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


// ignore: must_be_immutable
class WidgetSuggestionProduct extends StatelessWidget {
  
  //values
  late bool searchButton;
  late List<Product> list;
  
  WidgetSuggestionProduct({ required this.list, this.searchButton = false});

  @override
  Widget build(BuildContext context) {

    if (list.isEmpty) return Container();

    // values
    Color? colorAccent = Get.theme.textTheme.bodyMedium?.color;
    double radius = 32.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        // text
        Padding(padding: const EdgeInsets.all(12.0),child: Text("sugerencias para vos",style: Get.theme.textTheme.bodyMedium)),
        // circle images
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // button : seach
            !searchButton
                ? Container()
                : Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                      onTap: () => Get.toNamed(Routes.PRODUCTS_SEARCH,arguments: {'id': ''}),
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: FadeInLeft(
                          child: CircleAvatar(
                              radius: radius,
                              backgroundColor: colorAccent,
                              child: CircleAvatar(radius: radius-2,backgroundColor:Get.theme.scaffoldBackgroundColor,child: Icon(Icons.search, color: colorAccent))),
                        ),
                      ),
                    ),
                ),
            // CirlceAvartar : imagenes de productos
            SizedBox(
              height: 75,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return Align(
                      widthFactor: 0.5,
                      child: InkWell(
                        onTap: () => Utils().toProductView(productCatalogue: list[index].convertProductCatalogue()),
                        borderRadius: BorderRadius.circular(50),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: FadeInRight(
                            child: CircleAvatar(
                                backgroundColor: colorAccent,
                                foregroundColor: colorAccent,
                                radius: radius,
                                child: CircleAvatar(
                                    backgroundColor: Colors.grey[100],
                                    foregroundColor: Colors.grey[100],
                                    radius: radius-2,
                                    child: ClipRRect(
                                      borderRadius:BorderRadius.circular(50),
                                      child: CachedNetworkImage(
                                        fadeInDuration: const Duration( milliseconds: 200),
                                        fit: BoxFit.cover,
                                        imageUrl: list[index].image,
                                        placeholder: (context, url) =>CircleAvatar(backgroundColor:Colors.grey[100],foregroundColor:Colors.grey[100]),
                                        errorWidget:(context, url, error) =>CircleAvatar(backgroundColor:Colors.grey[100],foregroundColor:Colors.grey[100]),
                                      ),
                                    ))),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ],
    );
  }
}


