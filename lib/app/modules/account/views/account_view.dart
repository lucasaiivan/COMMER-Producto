import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utils/functions.dart';
import '../../../utils/widgets_utils_app.dart';
import '../controller/account_controller.dart'; 

class AccountView extends GetView<AccountController> {
  // VAriables

  final FocusNode focusTextEdiNombre = FocusNode();

  AccountView( );

  @override
  Widget build(BuildContext buildContext) {
    return scaffold(buildContext: buildContext);
  }

  Widget scaffold({required BuildContext buildContext}) {
    return GetBuilder<AccountController>(
        id: 'load',
        builder: (_) {
          return Scaffold(
            appBar: appBar(context: buildContext),
            body: controller.stateLoding
                ? const Center(
                    child: Text('cargando...'),
                  )
                : ListView(
                    padding: const EdgeInsets.all(12.0),
                    children: [
                      Column(
                        children: <Widget>[
                          // text : informativo
                          controller.newAccount?widgetText(text: 'Dinos un poco de tu negocio\n\n 👇'): Container(),
                          const SizedBox(height: 12.0),
                          // imagen : avatar del negocio
                          widgetsImagen(),
                          // button  : actualizart imagen
                          controller.getSavingIndicator
                              ? Container()
                              : Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TextButton(
                                    onPressed: () {
                                      if (controller.getSavingIndicator == false) {_showModalBottomSheetCambiarImagen(context: buildContext);}
                                    },
                                    child: const Text("actualizar imagen")
                                  ),
                              ),
                          // TextFuield views
                          widgetFormEditText(context: buildContext),
                        ],
                      ),
                    ],
                  ),
          );
        });
  }

  // WIDGET
  PreferredSizeWidget appBar({required BuildContext context}) {
    return AppBar(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      elevation: 0,
      iconTheme: Theme.of(context)
          .iconTheme
          .copyWith(color: Theme.of(context).textTheme.bodyText1!.color),
      title: Text(controller.newAccount ? 'Perfil de mi negocio' : 'Perfil',
          style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).textTheme.bodyText1!.color)),
      actions: <Widget>[
        IconButton(
          icon: controller.getSavingIndicator
              ? Container()
              : const Icon(Icons.check_sharp),
          onPressed: controller.saveAccount,
        )
      ],
      bottom: controller.getSavingIndicator ? ComponentApp.linearProgressBarApp() : null,
    );
  }

  void _showModalBottomSheetCambiarImagen({required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Capturar una imagen'),
                  onTap: () {
                    Navigator.pop(bc);
                    controller.setImageSource(imageSource: ImageSource.camera);
                  }),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Seleccionar desde la galería de fotos'),
                onTap: () {
                  Navigator.pop(bc);
                  controller.setImageSource(imageSource: ImageSource.gallery);
                },
              ),
            ],
          );
        });
  }

  Widget widgetText({required String text}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: ElasticIn(
        child: Text(text,
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
      )),
    );
  }

  Widget widgetsImagen() {
    // values
    Color colorDefault = Colors.grey.withOpacity(0.2);
    return GetBuilder<AccountController>(
      id: 'image',
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              controller.getImageUpdate == false
                  ? controller.profileAccount.image == ''
                      ? CircleAvatar(
                          backgroundColor: colorDefault,
                          radius: 75.0,
                        )
                      : CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: controller.profileAccount.image == ''
                              ? 'default'
                              : controller.profileAccount.image,
                          placeholder: (context, url) => CircleAvatar(
                            backgroundColor: colorDefault,
                            radius: 75.0,
                          ),
                          imageBuilder: (context, image) => CircleAvatar(
                            backgroundImage: image,
                            radius: 75.0,
                          ),
                          errorWidget: (context, url, error) => CircleAvatar(
                            backgroundColor: colorDefault,
                            radius: 75.0,
                          ),
                        )
                  : CircleAvatar(
                      radius: 75.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          FileImage(File(controller.getxFile.path)),
                    )
            ],
          ),
        );
      },
    );
  }


  Widget widgetFormEditText({required BuildContext context}) {


    // values 
    final Color fillColor = Theme.of(context).brightness==Brightness.dark?Colors.white10:Colors.grey.shade100;

    // creamos la vista del formulario 
    return Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            // textfiel: nombre del negocio
            TextField(
              enabled: !controller.getSavingIndicator,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              onChanged: (value) => controller.profileAccount.name = value,
              decoration: InputDecoration(fillColor:fillColor,filled: true,labelText: "Nombre del Negocio",prefixIcon: Icon(Icons.other_houses_outlined)),
              controller:TextEditingController(text: controller.profileAccount.name),
              textInputAction: TextInputAction.next,
              focusNode: focusTextEdiNombre,
            ),
            const Divider(color: Colors.transparent, thickness: 1),
            // textfiel: descripción
            TextField(
              enabled: !controller.getSavingIndicator,
              minLines: 1,
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              onChanged: (value) => controller.profileAccount.description = value,
              decoration: InputDecoration(fillColor: fillColor,filled: true,labelText: "Descripción (opcional)"),
              controller: TextEditingController(text: controller.profileAccount.description),
              textInputAction: TextInputAction.next,
            ),
            const Divider(color: Colors.transparent, thickness: 1),
            // textfiel: signo de moneda
            InkWell(
              onTap: () => _bottomPickerSelectCurrency(list: controller.coinsList, context: context),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                enabled: false,
                decoration: InputDecoration(
                  fillColor: fillColor,
                  labelText: "Signo de moneda",
                  filled: true,
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                ),
                controller: controller.getControllerTextEditSignoMoneda,
                onChanged: (value) => controller.profileAccount.currencySign = value,
              ),
            ),
            const SizedBox(height: 24.0),
            // text : texto informativo
            controller.newAccount?widgetText(text: '¿Donde se encuentra?\n\n 🌍'): const Text("Ubicación", style: TextStyle(fontSize: 24.0)),
            const SizedBox(height: 24.0),
            // textfiel: seleccionar un pais
            InkWell(
              onTap: () => bottomPickerSelectCountries(list: controller.getCountries, context: context),
              child: TextField(
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                enabled: false,
                decoration: InputDecoration(fillColor:fillColor,labelText: "Pais",filled: true,prefixIcon: Icon(Icons.location_on_outlined)),
                controller: controller.getControllerTextEditPais,
                onChanged: (value) => controller.profileAccount.country = value,
              ),
            ),
            const SizedBox(width: 12.0, height: 12.0),
            // textfiel: seleccionar una provincia
            InkWell(
              onTap: () => controller.profileAccount.country == ''
                  ? bottomPickerSelectCountries(list: controller.getCountries, context: context)
                  : bottomPickerSelectCities(list: controller.getCities, context: context),
              child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  enabled: false,
                  decoration: InputDecoration(
                    fillColor: fillColor,
                    labelText: "Provincia",
                    filled: true,
                    prefixIcon: Icon(Icons.business),
                  ),
                  controller: controller.getControllerTextEditProvincia,
                  onChanged: (value) {
                    controller.profileAccount.province = value;
                  }),
            ),
            const Divider(color: Colors.transparent, thickness: 1),
            // textfiel: ciudad
            TextField(
              enabled: !controller.getSavingIndicator,
              onChanged: (value) => controller.profileAccount.town = value,
              decoration: InputDecoration(
                fillColor: fillColor,
                labelText: "Ciudad (ocional)",
                filled: true,
              ),
              controller:
                  TextEditingController(text: controller.profileAccount.town),
            ),
            const Divider(color: Colors.transparent, thickness: 1),
            // textfiel: dirección/calle
            TextField(
              enabled: !controller.getSavingIndicator,
              onChanged: (value) => controller.profileAccount.address = value,
              decoration: InputDecoration(
                fillColor: fillColor,
                labelText: "Dirección (ocional)",
                filled: true,
              ),
              controller: TextEditingController(
                  text: controller.profileAccount.address),
              textInputAction: TextInputAction.next,
            ),
            // text : marca de tiempo de la ultima actualización del documento
            controller.newAccount?Container():Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Opacity(opacity: 0.5,child: Center(child: Text('Te uniste ${Publications.getFechaPublicacion(controller.profileAccount.creation.toDate(), Timestamp.now().toDate()).toLowerCase()}'))),
            ),
            const SizedBox(height: 50),
            // text : informativo 
            controller.newAccount?controller.getSavingIndicator?Container():Column(
              children: [
                widgetText(text: 'listo! eso es todo! 💪'),
                TextButton(onPressed:controller.saveAccount, child: const Text('Guardar')),
                const SizedBox(height: 50),
              ],
            ): Container(),
            
            
          ],
        ));
  }

  void bottomPickerSelectCities(
      {required List list, required BuildContext context}) async {
    //  Muestra una hoja inferior de diseño de material modal
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Seleccione una provincia')),
            body: ListView(
                shrinkWrap: true,
                children: List<Widget>.generate(
                    list.length,
                    (int index) => ListTile(
                          minVerticalPadding: 12,
                          title: Text(list[index]),
                          onTap: () {
                            controller.getControllerTextEditProvincia.text = list[index];
                            controller.profileAccount.province = list[index];
                            Get.back();
                          },
                        )),
              ),
          );
        });
  }

  void bottomPickerSelectCountries(
      {required List list, required BuildContext context}) async {
    //  Muestra una hoja inferior de diseño de material modal
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Seleccione un pais')),
            body: ListView(
                shrinkWrap: true,
                children: List<Widget>.generate(
                    list.length,
                    (int index) => ListTile(
                          minVerticalPadding: 12,
                          title: Text(list[index]),
                          onTap: () {
                            controller.profileAccount.country = list[index];
                            controller.getControllerTextEditPais.text =list[index];
                            Get.back();
                            bottomPickerSelectCities(list: controller.getCities, context: context);
                          },
                        )),
              ),
          );
        });
  }

  void _bottomPickerSelectCurrency(
      {required List list, required BuildContext context}) async {
    //  Muestra una hoja inferior de diseño de material modal
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Seleccione el signo de la moneda')),
            body: ListView(
                shrinkWrap: true,
                children: List<Widget>.generate(
                    list.length,
                    (int index) => ListTile(
                          minVerticalPadding: 12,
                          title: Text(list[index]),
                          onTap: () {
                            controller.profileAccount.currencySign = list[index];
                            controller.getControllerTextEditSignoMoneda.text =list[index];
                            Get.back();
                          },
                        )),
              ),
          );
        });
  }
}
