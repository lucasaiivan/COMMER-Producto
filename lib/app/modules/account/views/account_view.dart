import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producto/app/modules/account/controller/account_controller.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';

class AccountView extends GetView<AccountController> {
  // VAriables

  final FocusNode focusTextEdiNombre = FocusNode();
  final FocusNode focusTextEditDescripcion = FocusNode();
  final FocusNode focusTextEditCategoriaNombre = FocusNode();
  final FocusNode focusTextEditDireccion = FocusNode();
  final FocusNode focusTextEditCiudad = FocusNode();
  final FocusNode focusTextEditProvincia = FocusNode();
  final FocusNode focusTextEditPais = FocusNode();

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
                ? Center(
                    child: Text('cargando...'),
                  )
                : ListView(
                    padding: EdgeInsets.all(12.0),
                    children: [
                      Column(
                        children: <Widget>[
                          controller.newAccount?widgetNewAccount():Container(),
                          SizedBox(
                            height: 12.0,
                          ),
                          widgetsImagen(),
                          controller.getSavingIndicator
                              ? Container()
                              : TextButton(
                                  onPressed: () {
                                    if (controller.getSavingIndicator==false) {_showModalBottomSheetCambiarImagen(context: buildContext);}
                                  },
                                  child: Text("Cambiar imagen")),
                          SizedBox(
                            height: 24.0,
                          ),
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
              : Icon(Icons.check_sharp),
          onPressed: controller.saveAccount,
        )
      ],
      bottom: controller.getSavingIndicator ? linearProgressBarApp() : null,
    );
  }

  void _showModalBottomSheetCambiarImagen({required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.camera),
                    title: new Text('Capturar una imagen'),
                    onTap: () {
                      Navigator.pop(bc);
                      controller.setImageSource(
                          imageSource: ImageSource.camera);
                    }),
                new ListTile(
                  leading: new Icon(Icons.image),
                  title: new Text('Seleccionar desde la galería de fotos'),
                  onTap: () {
                    Navigator.pop(bc);
                    controller.setImageSource(imageSource: ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget widgetNewAccount() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
          child: ElasticIn(
            child: Text(
                'Hola 😃, primero dinos el nombre de tu negocio para poder crear tu catálogo \n\n 👇',
                style: TextStyle(fontSize: 18),
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
          padding: EdgeInsets.all(12.0),
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

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Widget widgetFormEditText({required BuildContext context}) {
    return Obx(() => Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                enabled: !controller.getSavingIndicator,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                onChanged: (value) => controller.profileAccount.name = value,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Nombre del Negocio",
                  prefixIcon: Icon(Icons.other_houses_outlined),
                ),
                controller:
                    TextEditingController(text: controller.profileAccount.name),
                textInputAction: TextInputAction.next,
                focusNode: focusTextEdiNombre,
                onSubmitted: (term) {
                  _fieldFocusChange(
                      context, focusTextEdiNombre, focusTextEditDescripcion);
                },
              ),
              Divider(color: Colors.transparent, thickness: 1),
              TextField(
                enabled: !controller.getSavingIndicator,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                onChanged: (value) =>
                    controller.profileAccount.description = value,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Descripción (opcional)",
                ),
                controller: TextEditingController(
                    text: controller.profileAccount.description),
                textInputAction: TextInputAction.next,
                focusNode: focusTextEditDescripcion,
                onSubmitted: (term) {
                  _fieldFocusChange(context, focusTextEditDescripcion,
                      focusTextEditDescripcion);
                },
              ),
              Divider(color: Colors.transparent, thickness: 1),
              InkWell(
                onTap: () =>
                    _bottomPickerSelectCurreny(list: ["\$"], context: context),
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Signo de moneda",
                    filled: true,
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                  ),
                  controller: controller.getControllerTextEditSignoMoneda,
                  onChanged: (value) =>
                      controller.profileAccount.currencySign = value,
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Text("Ubicación", style: TextStyle(fontSize: 24.0)),
              SizedBox(
                height: 24.0,
              ),
              TextField(
                enabled: !controller.getSavingIndicator,
                onChanged: (value) => controller.profileAccount.address = value,
                decoration: InputDecoration(
                  labelText: "Dirección (ocional)",
                  filled: true,
                ),
                controller: TextEditingController(
                    text: controller.profileAccount.address),
                textInputAction: TextInputAction.next,
                focusNode: focusTextEditDireccion,
                onSubmitted: (term) {
                  _fieldFocusChange(
                      context, focusTextEditDireccion, focusTextEditCiudad);
                },
              ),
              Divider(color: Colors.transparent, thickness: 1),
              TextField(
                enabled: !controller.getSavingIndicator,
                onChanged: (value) => controller.profileAccount.town = value,
                decoration: InputDecoration(
                  labelText: "Ciudad (ocional)",
                  filled: true,
                ),
                controller:
                    TextEditingController(text: controller.profileAccount.town),
              ),
              Divider(color: Colors.transparent, thickness: 1),
              InkWell(
                onTap: () => controller.profileAccount.country == ''
                    ? _bottomPickerSelectCountries(
                        list: controller.getCountries, context: context)
                    : _bottomPickerSelectCities(
                        list: controller.getCities, context: context),
                child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Provincia",
                      filled: true,
                      prefixIcon: Icon(Icons.business),
                    ),
                    controller: controller.getControllerTextEditProvincia,
                    onChanged: (value) {
                      controller.profileAccount.province = value;
                    }),
              ),
              Divider(color: Colors.transparent, thickness: 1),
              InkWell(
                onTap: () => _bottomPickerSelectCountries(
                    list: controller.getCountries, context: context),
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Pais",
                    filled: true,
                    prefixIcon: Icon(Icons.location_on_outlined),
                  ),
                  controller: controller.getControllerTextEditPais,
                  onChanged: (value) =>
                      controller.profileAccount.country = value,
                ),
              ),
              SizedBox(width: 50.0, height: 50.0),
            ],
          ),
        ));
  }

  void _bottomPickerSelectCities(
      {required List list, required BuildContext context}) async {
    //  el usuario va a seleccionar una opción
    int _index = 0;
    //  Muestra una hoja inferior de diseño de material modal
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CupertinoButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Expanded(
                child: CupertinoPicker(
                    scrollController:
                        new FixedExtentScrollController(initialItem: 0),
                    itemExtent: 32.0,
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (int index) => _index = index,
                    children: List<Widget>.generate(list.length,
                        (int index) => Center(child: Text(list[index])))),
              ),
              CupertinoButton(
                child: Text("Ok"),
                onPressed: () {
                  controller.getControllerTextEditProvincia.text = list[_index];
                  controller.profileAccount.province = list[_index];
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _bottomPickerSelectCountries(
      {required List list, required BuildContext context}) async {
    //  el usuario va a seleccionar una opción
    int _index = 0;
    //  Muestra una hoja inferior de diseño de material modal
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CupertinoButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Expanded(
                child: CupertinoPicker(
                    scrollController:
                        new FixedExtentScrollController(initialItem: 0),
                    itemExtent: 32.0,
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (int index) => _index = index,
                    children: List<Widget>.generate(list.length,
                        (int index) => Center(child: Text(list[index])))),
              ),
              CupertinoButton(
                child: Text("Ok"),
                onPressed: () {
                  controller.profileAccount.country = list[_index];
                  controller.getControllerTextEditPais.text = list[_index];
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _bottomPickerSelectCurreny(
      {required List list, required BuildContext context}) async {
    //  el usuario va a seleccionar una opción
    int _index = 0;
    //  Muestra una hoja inferior de diseño de material modal
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200.0,
          color: Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CupertinoButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Expanded(
                child: CupertinoPicker(
                    scrollController:
                        new FixedExtentScrollController(initialItem: 0),
                    itemExtent: 32.0,
                    backgroundColor: Colors.white,
                    onSelectedItemChanged: (int index) => _index = index,
                    children: List<Widget>.generate(list.length,
                        (int index) => Center(child: Text(list[index])))),
              ),
              CupertinoButton(
                child: Text("Ok"),
                onPressed: () {
                  controller.profileAccount.currencySign = list[_index];
                  controller.getControllerTextEditSignoMoneda.text =
                      list[_index];
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
