import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producto/app/modules/account/controller/account_controller.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';

class AccountView extends GetView<AccountController> {
  // Image
  final String urlIamgen = "";
  late final PickedFile imageFile;
  final String titleAppBar = "Crear cuenta";

  // VAriables
  late final BuildContext context;


  final FocusNode focusTextEdiNombre = FocusNode();
  final FocusNode focusTextEditDescripcion = FocusNode();
  final FocusNode focusTextEditCategoriaNombre = FocusNode();
  final FocusNode focusTextEditDireccion = FocusNode();
  final FocusNode focusTextEditCiudad = FocusNode();
  final FocusNode focusTextEditProvincia = FocusNode();
  final FocusNode focusTextEditPais = FocusNode();

  @override
  Widget build(BuildContext buildContext) {
    context = buildContext;

    return scaffold(buildContext: context);
  }

  Widget scaffold({required BuildContext buildContext}) {
    

    return GetBuilder<AccountController>(
        id: 'load',
        builder: (_) {
          return Scaffold(
            appBar: appBar(),
            body: ListView(
              padding: EdgeInsets.all(12.0),
              children: [
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 12.0,
                    ),
                    widgetsImagen(),
                    controller.getSavingIndicator
                        ? Container()
                        : TextButton(
                            onPressed: () {
                              if (controller.getSavingIndicator == false) {
                                _showModalBottomSheetCambiarImagen(
                                    context: buildContext);
                              }
                            },
                            child: Text("Cambiar imagen")),
                    SizedBox(
                      height: 24.0,
                    ),
                    widgetFormEditText(),
                  ],
                ),
              ],
            ),
          );
        });
  }

  // WIDGET
  PreferredSizeWidget appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(controller.getSavingIndicator ? 'Actualizando' : "Mi Perfil"),
      actions: <Widget>[
        GetBuilder<AccountController>(
          id: 'load',
          initState: (_) {},
          builder: (_) {
            return IconButton(
              icon: controller.getSavingIndicator
                  ? Container()
                  : Icon(Icons.check),
              onPressed: controller.saveAccount,
            );
          },
        ),
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

  Widget widgetsImagen() {
    return GetBuilder<AccountController>(
      id: 'image',
      builder: (_) {
        return Container(
          padding: EdgeInsets.all(12.0),
          child: Column(
            children: [
              controller.getImageUpdate == false
                  ? CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: controller.getProfileAccount.imagenPerfil != ""
                          ? controller.getProfileAccount.imagenPerfil
                          : "default",
                      placeholder: (context, url) => CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 75.0,
                      ),
                      imageBuilder: (context, image) => CircleAvatar(
                        backgroundImage: image,
                        radius: 75.0,
                      ),
                      errorWidget: (context, url, error) => CircleAvatar(
                        backgroundColor: Colors.grey,
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

  Widget widgetFormEditText() {
    return Obx(() => Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                enabled: !controller.getSavingIndicator,
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                onChanged: (value) =>
                    controller.getProfileAccount.nombreNegocio = value,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Nombre",
                ),
                controller: TextEditingController(
                    text: controller.getProfileAccount.nombreNegocio),
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
                    controller.getProfileAccount.descripcion = value,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Descripción",
                ),
                controller: TextEditingController(
                    text: controller.getProfileAccount.descripcion),
                textInputAction: TextInputAction.next,
                focusNode: focusTextEditDescripcion,
                onSubmitted: (term) {
                  _fieldFocusChange(context, focusTextEditDescripcion,
                      focusTextEditDescripcion);
                },
              ),
              Divider(color: Colors.transparent, thickness: 1),
              InkWell(
                onTap: () => _buildBottomPicker(
                    listItems: [
                      "\$",
                    ],
                    textEditingController: TextEditingController(
                        text: controller.getProfileAccount.signoMoneda)),
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Signo de moneda",
                    filled: true,
                  ),
                  controller: TextEditingController(
                      text: controller.getProfileAccount.signoMoneda),
                  onChanged: (value) =>
                      controller.getProfileAccount.signoMoneda = value,
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
                onChanged: (value) =>
                    controller.getProfileAccount.direccion = value,
                decoration: InputDecoration(
                  labelText: "Dirección (ocional)",
                  filled: true,
                ),
                controller: TextEditingController(
                    text: controller.getProfileAccount.direccion),
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
                onChanged: (value) =>
                    controller.getProfileAccount.ciudad = value,
                decoration: InputDecoration(
                  labelText: "Ciudad (ocional)",
                  filled: true,
                ),
                controller: TextEditingController(
                    text: controller.getProfileAccount.ciudad),
              ),
              Divider(color: Colors.transparent, thickness: 1),
              InkWell(
                onTap: () => _buildBottomPickerCities(),
                child: TextField(
                    minLines: 1,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: "Provincia",
                      filled: true,
                    ),
                    controller: controller.getControllerTextEditProvincia,
                    onChanged: (value) {
                      controller.getProfileAccount.provincia = value;
                    }),
              ),
              Divider(color: Colors.transparent, thickness: 1),
              InkWell(
                onTap: () => _buildBottomPicker(
                    listItems:controller.getCountries,
                    textEditingController: TextEditingController(
                        text: controller.getProfileAccount.pais)),
                child: TextField(
                  minLines: 1,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: "Pais",
                    filled: true,
                  ),
                  controller: TextEditingController(
                      text: controller.getProfileAccount.pais),
                  onChanged: (value) =>
                      controller.getProfileAccount.pais = value,
                ),
              ),
              SizedBox(width: 50.0, height: 50.0),
            ],
          ),
        ));
  }

  void _buildBottomPickerCities() {

    int _index = 0;

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
              },
            ),
            Expanded(
              child: CupertinoPicker(
                  scrollController: new FixedExtentScrollController(
                    initialItem: 0,
                  ),
                  itemExtent: 32.0,
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (int index) {
                    _index = index;
                  },
                  children: new List<Widget>.generate(controller.getCities.length,
                      (int index) {
                    return new Center(
                      child: new Text(controller.getCities[index]),
                    );
                  })),
            ),
            CupertinoButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
    ).whenComplete(() {
      controller.getControllerTextEditProvincia.text = controller.getCities[_index];
    });
  }
  void _buildBottomPickerContruis() {

    int _index = 0;

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
              },
            ),
            Expanded(
              child: CupertinoPicker(
                  scrollController: new FixedExtentScrollController(
                    initialItem: 0,
                  ),
                  itemExtent: 32.0,
                  backgroundColor: Colors.white,
                  onSelectedItemChanged: (int index) {
                    _index = index;
                  },
                  children: new List<Widget>.generate(controller.getCities.length,
                      (int index) {
                    return new Center(
                      child: new Text(controller.getCities[index]),
                    );
                  })),
            ),
            CupertinoButton(
              child: Text("Ok"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
    ).whenComplete(() {
      controller.getControllerTextEditProvincia.text = controller.getCities[_index];
    });
  }
}
