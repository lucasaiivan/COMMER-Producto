
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:get/get.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/modules/mainScreen/views/scanScreen_view.dart';
import 'catalogueScreen_view.dart';

/*  DESCRIPCIÓN */
/*  Pantalla principal de la aplicación */

class PagePrincipal extends GetView<WelcomeController> {
  /* Declarar variables */
  double get randHeight => math.Random().nextInt(100).toDouble();

  @override
  Widget build(BuildContext buildContext) {
    return Obx(() => controller.getIdAccountSelecte==""?ScanScreenView():CatalogueScreenView());
  }
}
