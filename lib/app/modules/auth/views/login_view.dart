import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/modules/auth/controller/login_controller.dart';

// RELEASE
// En esta pantalla de inicio de sesión, agregaremos un logotipo, dos campos de texto y firmaremos con el botón de Google

class AuthView extends GetView<LoginController> {
  AuthView({Key? key}) : super(key: key);

  // var
  Color colorFondo = Colors.deepPurple, colorAccent = Colors.deepPurple;
  PageController _controller = PageController(initialPage: 0);
  late Size
      screenSize; // Obtenemos las vavriables de la dimension de la pantalla

  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores
    screenSize = MediaQuery.of(context).size;
    colorFondo = Theme.of(context).brightness == Brightness.dark
        ? Colors.deepPurple
        : Colors.white;
    colorAccent = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : colorAccent;

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: body(context: context),
    );
  }

  /// WIDGETS VIEWS
  Widget body({required BuildContext context}) {
    // Definimos los estilos de colores de los botones
    Color colorText = Theme.of(context).brightness == Brightness.dark
        ? Colors.deepPurple
        : Colors.white;
    Color colorButton = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.deepPurple;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
            child: onboarding(
                context: context,
                colorContent: colorButton,
                colorFondo: colorFondo,
                height: double.infinity,
                width: double.infinity)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20.0),
              onPrimary: Colors.white,
              primary: colorButton,
              shadowColor: colorButton,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: colorButton)),
              side: BorderSide(color: colorButton),
            ),
            child: Text('iniciar sesión con google',
                style: TextStyle(
                    color: colorText,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold)),
            onPressed: controller.login,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  /// WIDGETS COMPONENT
  Widget dotsIndicator(
      {required BuildContext context,
      required PageController pageController,
      required List pages}) {
    return DotsIndicator(
      controller: pageController,
      itemCount: pages.length,
      color: colorAccent,
      onPageSelected: (int page) {
        _controller.animateToPage(page,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      },
    );
  }

  Widget onboarding(
      {required BuildContext context,
      Color? colorContent,
      Color colorFondo = Colors.transparent,
      double width = double.infinity,
      double height = 200}) {
    // Pantallas integradas para la introducción a la aplicación

    List<Widget> _pages = [
      componente(
          iconData: Icons.search,
          texto: "ESCANEAR",
          descripcion:
              "Solo tenes que enfocar el producto para obtenes la información en el acto",
          brightness: Get.theme.brightness),
      componente(
          iconData: Icons.monetization_on,
          texto: "¿QUERES SABER EL PRECIO?",
          descripcion:
              "Compara el precios de diferentes comerciantes o compartir el tuyo",
          brightness: Get.theme.brightness),
      componente(
          iconData: Icons.category,
          texto: "Crea tu catálogo",
          descripcion: "Arma tu catalogo con tus productos",
          brightness:Get.theme.brightness),
    ];

    return Container(
      width: width,
      height: height,
      child: Scaffold(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        body: PageView(
          // Una lista desplazable que funciona página por página. */
          controller:
              _controller, //  El initialPageparámetro establecido en 0 significa que el primer elemento secundario del widget PageViewse mostrará primero (ya que es un índice basado en cero) */
          pageSnapping: true, // Deslizaiento automatico */
          scrollDirection: Axis.horizontal, // Dirección de deslizamiento */
          children: _pages,
        ),
        floatingActionButton: dotsIndicator(
            context: context, pageController: _controller, pages: _pages),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  Widget componente(
      {required IconData iconData,
      required String texto,
      required String descripcion,
      Brightness brightness = Brightness.light}) {

    // var
    Color colorPrimary = Get.theme.brightness == Brightness.dark
        ? Colors.white
        : Colors.deepPurple;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 100.0, color: colorPrimary),
            SizedBox(height: 12.0),
            Text(texto,
                style: TextStyle(fontSize: 24.0, color: colorPrimary),
                textAlign: TextAlign.center),
            descripcion != ""
                ? Text(
                    descripcion,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: colorPrimary,
                    ),
                    textAlign: TextAlign.center,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget buttonRoundAppBar(
          {required void Function() onPressed,
          required BuildContext context,
          Widget? child,
          required IconData icon,
          required EdgeInsets edgeInsets}) =>
      Material(
          color: Colors.transparent,
          child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Ink(
                      decoration: ShapeDecoration(
                          color: Brightness.dark == Theme.of(context).brightness
                              ? Colors.black
                              : Colors.white,
                          shape: CircleBorder()),
                      child: child == null
                          ? IconButton(
                              icon: Icon(icon),
                              color: Brightness.dark ==
                                      Theme.of(context).brightness
                                  ? Colors.white
                                  : Colors.black,
                              onPressed: onPressed)
                          : child))));
}

/// Un indicador que muestra la página actualmente seleccionada de un PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator(
      {required this.controller,
      required this.itemCount,
      required this.onPageSelected,
      this.color: Colors.white})
      : super(listenable: controller);
  // El PageController que representa este DotsIndicator.
  final PageController controller;
  // La cantidad de elementos administrados por PageController
  final int itemCount;
  // Llamado cuando se toca un punto
  final ValueChanged<int> onPageSelected;

  // El color de los puntos.
  // Defaults to `Colors.white`.
  final Color color;
  // El tamaño base de los puntos
  static const double _kDotSize = 8.0;
  // El aumento en el tamaño del punto seleccionado.
  static const double _kMaxZoom = 2.0;
  // La distancia entre el centro de cada punto
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(max(0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs()));
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      height: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(onTap: () => onPageSelected(index)),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
