
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/modules/mainScreen/views/scanScreen_view.dart';
import 'catalogueScreen_view.dart';

/*  DESCRIPCIÓN */
/*  Pantalla principal de la aplicación */
class PagePrincipal extends StatelessWidget {

  @override
  Widget build(BuildContext buildContext) {
    return GetBuilder<HomeController>(
      id: 'accountUpdate',
      builder: (controller) {
        return controller.getIdAccountSelected==""?ScanScreenView():CatalogueScreenView();
      },
    );
  }
}
