
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:producto/app/modules/auth/controller/login_controller.dart';

// RELEASE 
// En esta pantalla de inicio de sesión, agregaremos un logotipo, dos campos de texto y firmaremos con el botón de Google


class LoginView extends GetView<LoginController> {
  
  /* Declarar variables */
  final int page = 0; /* Posición de la página */
  final bool enableSideReveal = true; /* Controla el estado de la visibilidad de iconButton para deslizar la pantalla del lado izquierdo */
  final bool isDarkGlobal = false; /* Controla el brillo de la barra de estado */
  late final Size screenSize;
  final bool authState = false;
  final bool loadAuth = false;

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;

    return scaffold();
  }

  Widget scaffold() {
    return Scaffold(
      body: LiquidSwipe(
        initialPage: 0,
        fullTransitionValue: 500,
        /* Establece la distancia de desplazamiento o la sensibilidad para un deslizamiento completo. */
        enableSideReveal: true,/* Se usa para habilitar el ícono de diapositiva a la derecha de dónde se originaría la onda */
        enableLoop: true,
        /* Habilitar o deshabilitar la recurrencia de páginas. */
        positionSlideIcon: 0.5,
        /* Coloque su icono en el eje y en el lado derecho de la pantalla */
        slideIconWidget: Icon(Icons.arrow_back_ios,
            color: isDarkGlobal ? Colors.black : Colors.white),
        pages: [
          componentePersonado(
              color: Colors.purple,
              iconData: Icons.search,
              texto: "ESCANEAR",
              descripcion:
                  "Solo tenes que enfocar el producto para obtenes la información en el acto",
              brightness: Brightness.light),
          componente(
              color: Colors.orange,
              iconData: Icons.monetization_on,
              texto: "¿QUERES SABER EL PRECIO?",
              descripcion: "Compara el precios de diferentes comerciantes o compartir el tuyo",
              brightness: Brightness.light),
          componente(
              color: Colors.lightBlue,
              iconData: Icons.category,
              texto: "Crea tu catálogo",
              descripcion: "Arma tu catalogo con tus productos",
              brightness: Brightness.light),
        ],
        /* Pase su método como devolución de llamada, devolverá un número de página. */
        waveType: WaveType
            .liquidReveal, /* Seleccione el tipo de revelación que desea. */
      ),
    );
  }

  Widget componente(
      {required IconData iconData,
      required String texto,
      required String descripcion,
      required Color color,
      Brightness brightness = Brightness.light}) {
    Color colorPrimary =
        brightness != Brightness.light ? Colors.black : Colors.white;
    return Container(
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(iconData, size: 100.0, color: colorPrimary),
                        SizedBox(height: 12.0),
                        Text(texto,
                            style:
                                TextStyle(fontSize: 24.0, color: colorPrimary),
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
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: loadAuth == false
                ? loginButton(
                  size: 30,
                  text: 'INICIAR SESIÓN CON GOOGLE',
                  icon: FontAwesomeIcons.google,
                  color: colorPrimary,
                  colorbutton: Colors.transparent,
                  onPressed: controller.login,
                )
              : Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.white)),
          ),
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Lógica Booleana",
                  style: TextStyle(fontSize: 18.0, color: colorPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget componentePersonado(
      {required IconData iconData,
      required String texto,
      required String descripcion,
      required Color color,
      Brightness brightness = Brightness.light}) {
    Color colorPrimary =
        brightness != Brightness.light ? Colors.black : Colors.white;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      color: color,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Flexible(
            flex: 3,
            child: Container(
              color: Colors.transparent,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                            color: colorPrimary,
                            height: 100.0,
                            width: 100.0,
                            image: AssetImage('assets/barcode.png'),
                            fit: BoxFit.contain),
                        SizedBox(height: 12.0),
                        Text(texto,
                            style:
                                TextStyle(fontSize: 24.0, color: colorPrimary),
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
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: loadAuth == false
              ? loginButton(
                size: 30,
                  text: '  INICIAR SESIÓN CON GOOGLE  ',
                  icon: FontAwesomeIcons.google,
                  color: colorPrimary,
                  colorbutton: Colors.transparent,
                  onPressed: controller.login,
                )
              : Center(
                  child: CircularProgressIndicator(
                      backgroundColor: Colors.white)),
          ),
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Lógica Booleana",
                  style: TextStyle(fontSize: 14.0, color: colorPrimary.withOpacity(0.5)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget loginButton(
      {required String text,
      required IconData icon,
      required Color color,
      required Color colorbutton,
      double size = 14.0,
      required Function onPressed}) {
        
    return Container(
      margin: EdgeInsets.only(left: 16, right: 16),
      child:TextButton.icon(
        onPressed: controller.login, 
        icon: Icon(icon,size:size), label: Text(
              text,
              style: TextStyle(color: color),
            )),
    );
  }
}

