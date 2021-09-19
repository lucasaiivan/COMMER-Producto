import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
