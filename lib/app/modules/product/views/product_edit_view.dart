import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/modules/product/controllers/product_edit_controller.dart';
import 'package:producto/app/services/database.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import 'package:producto/app/utils/widgets_utils_app.dart' as utilsWidget;
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/functions.dart';

class ProductEdit extends StatelessWidget {
  ProductEdit({Key? key}) : super(key: key);

  final ControllerProductsEdit controller = Get.find();
  final Widget space = SizedBox(
    height: 16.0,
    width: 16.0,
  );

  @override
  Widget build(BuildContext context) {
    // GetBuilder - refresh all the views
    return GetBuilder<ControllerProductsEdit>(
      id: 'updateAll',
      init: ControllerProductsEdit(),
      initState: (_) {},
      builder: (_) {
        return Scaffold(
          appBar: appBar(contextPrincipal: context),
          body: ListView(
            children: [
              widgetsImagen(),
              widgetFormEditText(),
            ],
          ),
        );
      },
    );
  }

  // WIDGETS VIEWS
  PreferredSizeWidget appBar({required BuildContext contextPrincipal}) {
    Color? colorAccent = Get.theme.textTheme.bodyText1!.color;

    return AppBar(
      elevation: 0.0,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      iconTheme:
          Theme.of(contextPrincipal).iconTheme.copyWith(color: colorAccent),
      title: controller.getSaveIndicator
          ? Text(controller.getTextAppBar,
              style: TextStyle(fontSize: 18.0, color: colorAccent))
          : Text(controller.getIsCatalogue ? 'Editar' : 'Nuevo',
              style: TextStyle(fontSize: 18.0, color: colorAccent)),
      actions: <Widget>[
        controller.getSaveIndicator
            ? Container()
            : IconButton(icon: Icon(Icons.check), onPressed: controller.save),
      ],
      bottom: controller.getSaveIndicator ? linearProgressBarApp() : null,
    );
  }

  Widget widgetsImagen() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      color: Colors.grey.withOpacity(0.1),
      width: double.infinity,
      height: Get.size.height * 0.25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // button
          controller.getSaveIndicator
              ? Container()
              : controller.getNewProduct || controller.getEditModerator
                  ? IconButton(
                      onPressed: controller.getLoadImageCamera,
                      icon: Icon(Icons.camera_alt, color: Colors.grey))
                  : Container(),
          //  image
          controller.loadImage(),
          //  button
          controller.getSaveIndicator
              ? Container()
              : controller.getNewProduct || controller.getEditModerator
                  ? IconButton(
                      onPressed: controller.getLoadImageGalery,
                      icon: Icon(Icons.image, color: Colors.grey))
                  : Container(),
        ],
      ),
    );
  }

  Widget widgetFormEditText() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          space,
          TextField(
            enabled: controller.getSaveIndicator
                ? false
                : controller.getEditModerator || controller.getNewProduct,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            onChanged: (value) => controller.getProduct.description = value,
            decoration: InputDecoration(
                disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                border: OutlineInputBorder(),
                labelText: "Descripción"),
            textInputAction: TextInputAction.done,
            controller: controller.controllerTextEdit_descripcion,
          ),
          space,
          TextButton(
              onPressed: () async {
                String url = "https://www.google.com/search?q=" +
                    controller.controllerTextEdit_descripcion.text;
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text('Buscar en Google')),
          space,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                if (controller.getNewProduct || controller.getEditModerator) {
                  controller.showModalSelectMarca();
                }
              },
              child: controller.getMarkSelected.id == ''
                  ? Text("Seleccionar marca")
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        utilsWidget.viewCircleImage(
                            size: 25,
                            url: controller.getMarkSelected.image,
                            texto: controller.getMarkSelected.name),
                        SizedBox(width: 8),
                        Text(controller.getMarkSelected.name,
                            style: TextStyle(
                                color: controller.getNewProduct ||
                                        controller.getEditModerator
                                    ? null
                                    : Colors.grey))
                      ],
                    ),
              style: ButtonStyle(
                  side: controller.getEditModerator || controller.getNewProduct
                      ? null
                      : MaterialStateProperty.all(
                          BorderSide(color: Get.theme.scaffoldBackgroundColor)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(16))),
            ),
          ),
          // buttons categoty
          !controller.getAccountAuth ? Container() : space,
          !controller.getAccountAuth ? Container() : buttonsCategory(),
          space,
          // textfield prices
          !controller.getAccountAuth
              ? Container()
              : Column(
                  children: [
                    space,
                    TextField(
                      enabled: !controller.getSaveIndicator,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) =>
                          controller.getProduct.purchasePrice = controller
                              .controllerTextEdit_precio_compra.numberValue,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Precio de compra"),
                      textInputAction: TextInputAction.next,
                      //style: textStyle,
                      controller: controller.controllerTextEdit_precio_compra,
                    ),
                    space,
                    TextField(
                      enabled: !controller.getSaveIndicator,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      onChanged: (value) => controller.getProduct.salePrice =
                          controller
                              .controllerTextEdit_precio_venta.numberValue,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Precio de venta"),
                      textInputAction: TextInputAction.done,
                      //style: textStyle,
                      controller: controller.controllerTextEdit_precio_venta,
                    ),
                  ],
                ),
          !controller.getNewProduct ? Container() : space,
          controller.getProduct.code != ""
              ? Opacity(
                  opacity: 0.8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.qr_code_2_rounded, size: 14),
                        SizedBox(width: 5),
                        Text(controller.getProduct.code,
                            style: TextStyle(
                                height: 1,
                                fontSize: 12,
                                fontWeight: FontWeight.normal)),
                      ],
                    ),
                  ),
                )
              : Container(),
          space,
          controller.getSaveIndicator
              ? Container()
              : controller.getIsCatalogue
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          bottom: 12, top: 40, left: 0, right: 0),
                      child: button(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          colorAccent: Colors.white,
                          colorButton: Colors.red,
                          icon: Icon(Icons.delete),
                          text: 'Eliminar de mi catálogo',
                          onPressed: controller.showDialogDelete),
                    )
                  : Container(),

          /* OPCIONES PARA DESARROLLADOR - ELIMINAR ESTE CÓDIGO PARA PRODUCCION */
          controller.getNewProduct
              ? Container()
              : Column(
                  children: [
                    SizedBox(height: 20.0),
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          height: 3.0,
                          endIndent: 12.0,
                          indent: 12.0,
                          thickness: 2,
                        )),
                        Text("OPCIONES PARA MODERADOR"),
                        Expanded(
                            child: Divider(
                                thickness: 2,
                                height: 3.0,
                                endIndent: 12.0,
                                indent: 12.0))
                      ],
                    ),
                    SizedBox(height: !controller.getSaveIndicator ? 20.0 : 0.0),
                    FilterChip(
                      labelStyle: TextStyle(color: Colors.white),
                      checkmarkColor: Colors.white,
                      selectedColor: controller.getSaveIndicator
                          ? null
                          : controller.getEditModerator
                              ? Colors.amber
                              : Colors.grey,
                      selected: controller.getProduct.favorite,
                      label: Text(controller.getProduct.favorite
                          ? 'Destacado'
                          : 'Agregar a destacado'),
                      onSelected: (bool value) {
                        if (controller.getEditModerator) {
                          if (!controller.getSaveIndicator) {
                            controller.isFavorite();
                          }
                        }
                      },
                    ),
                    SizedBox(height: !controller.getSaveIndicator ? 20.0 : 0.0),
                    FilterChip(
                      labelStyle: TextStyle(color: Colors.white),
                      checkmarkColor: Colors.white,
                      selectedColor: controller.getSaveIndicator
                          ? null
                          : controller.getEditModerator
                              ? Colors.blue
                              : Colors.grey,
                      selected: controller.getProduct.verified,
                      label: Text(controller.getProduct.verified
                          ? 'Verificado'
                          : 'Quitar de verificados'),
                      onSelected: (bool value) {
                        if (controller.getEditModerator) {
                          if (!controller.getSaveIndicator) {
                            controller.checkProduct();
                          }
                        }
                      },
                    ),
                    SizedBox(height: !controller.getSaveIndicator ? 20.0 : 0.0),
                    controller.getSaveIndicator
                        ? Container()
                        : button(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            icon: Icon(Icons.security, color: Colors.white),
                            onPressed: () {
                              if (controller.getEditModerator) {
                                controller.showDialogSaveOPTDeveloper();
                              }
                              controller.setEditModerator =
                                  !controller.getEditModerator;
                            },
                            colorAccent: Colors.white,
                            colorButton: controller.getEditModerator
                                ? Colors.green
                                : Colors.orange,
                            text: controller.getEditModerator
                                ? 'Actualizar documento'
                                : "Editar documento",
                          ),
                    SizedBox(height: 20.0),
                    controller.getSaveIndicator
                        ? Container()
                        : button(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            icon: Icon(Icons.security, color: Colors.white),
                            onPressed: controller.showDialogDeleteOPTDeveloper,
                            colorAccent: Colors.white,
                            colorButton: Colors.red,
                            text: "Eliminar documento",
                          ),
                    SizedBox(height: 50.0),
                  ],
                ),
        ],
      ),
    );
  }

  /* WIDGETS COMPONENT */
  Widget buttonsCategory() {
    // Text of Button
    Text textCategory = Text(
        controller.getCategory.id == ''
            ? 'Categoría'
            : controller.getCategory.name,
        maxLines: 1,
        style: TextStyle(
            color: controller.getCategory.id == '' ? null : Colors.grey,
            overflow: TextOverflow.ellipsis));
    Text textSubcategory = Text(
        controller.getSubcategory.id == ''
            ? 'Subcategoría'
            : controller.getSubcategory.name,
        maxLines: 1,
        style: TextStyle(
            color: controller.getSubcategory.id == '' ? null : Colors.grey,
            overflow: TextOverflow.ellipsis));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: controller.getSaveIndicator ? null : SelectCategory.show,
            child: textCategory,
            style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16))),
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: controller.getSaveIndicator
                ? null
                : controller.getCategory.id == ''
                    ? null
                    : SelectSubCategoria.show,
            child: textSubcategory,
            style: ButtonStyle(
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(16))),
          ),
        )
      ],
    );
  }

  Widget button(
      {double width = double.infinity,
      required Widget icon,
      String text = '',
      required dynamic onPressed,
      EdgeInsets padding =
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      Color colorButton = Colors.purple,
      Color colorAccent = Colors.white}) {
    return FadeInRight(
        child: Padding(
      padding: padding,
      child: Container(
        width: width,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.all(12.0),
              primary: colorButton,
              textStyle: TextStyle(color: colorAccent)),
          icon: icon,
          label: Text(text, style: TextStyle(color: colorAccent)),
        ),
      ),
    ));
  }
}

// category
class SelectCategory extends StatefulWidget {
  SelectCategory();

  @override
  _SelectCategoryState createState() => _SelectCategoryState();

  static void show() {
    Widget widget = SelectCategory();
    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }
}

class _SelectCategoryState extends State<SelectCategory> {
  _SelectCategoryState();

  // Variables
  final Category categoriaSelected = Category();
  bool crearCategoria = false, loadSave = false;
  final WelcomeController welcomeController = Get.find();
  final ControllerProductsEdit controllerProductsEdit = Get.find();

  @override
  void initState() {
    crearCategoria = false;
    loadSave = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    if (welcomeController.getCatalogueCategoryList.length == 0) {
      return ListTile(
        onTap: () => showDialogSetCategoria(categoria: Category()),
        title: Text('Crear categoría', style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.add),
      );
    }

    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shrinkWrap: true,
        itemCount: welcomeController.getCatalogueCategoryList.length,
        itemBuilder: (BuildContext context, int index) {
          Category categoria =
              welcomeController.getCatalogueCategoryList[index];
          MaterialColor color = Utils.getRandomColor();
          return index == 0
              ? Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child:
                              Text('Categoría', style: TextStyle(fontSize: 18)),
                        )),
                        IconButton(
                            icon: Icon(Icons.add),
                            padding: const EdgeInsets.all(20.0),
                            onPressed: () =>
                                showDialogSetCategoria(categoria: Category()))
                      ],
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.1),
                        radius: 24.0,
                        child: Text(categoria.name.substring(0, 1),
                            style: TextStyle(
                                fontSize: 18.0,
                                color: color,
                                fontWeight: FontWeight.bold)),
                      ),
                      dense: true,
                      title: Text(categoria.name),
                      onTap: () {
                        controllerProductsEdit.setCategory = categoria;
                        controllerProductsEdit.updateAll();
                        Get.back();
                        SelectSubCategoria.show();
                      },
                      trailing: popupMenuItemCategoria(categoria: categoria),
                    ),
                    Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                  ],
                )
              : Column(
                  children: <Widget>[
                    Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      leading: CircleAvatar(
                        backgroundColor: color.withOpacity(0.1),
                        radius: 24.0,
                        child: categoria.name != ""
                            ? Text(categoria.name.substring(0, 1),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: color,
                                    fontWeight: FontWeight.bold))
                            : Text("C"),
                      ),
                      dense: true,
                      title: Text(categoria.name),
                      onTap: () {
                        controllerProductsEdit.setCategory = categoria;
                        controllerProductsEdit.setSubcategory = Category();
                        Get.back();
                        SelectSubCategoria.show();
                      },
                      trailing: popupMenuItemCategoria(categoria: categoria),
                    ),
                  ],
                );
        },
      ),
    );
  }


  Widget popupMenuItemCategoria({required Category categoria}) {
    final WelcomeController controller = Get.find();

    return new PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        new PopupMenuItem<String>(child: const Text('Editar'), value: 'editar'),
        new PopupMenuItem<String>(
            child: const Text('Eliminar'), value: 'eliminar'),
      ],
      onSelected: (value) async {
        switch (value) {
          case "editar":
            showDialogSetCategoria(categoria: categoria);
            break;
          case "eliminar":
            await showDialog<String>(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  contentPadding: const EdgeInsets.all(16.0),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                            "¿Desea continuar eliminando esta categoría?"),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    new TextButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    new TextButton(
                        child: loadSave == false
                            ? Text("ELIMINAR")
                            : CircularProgressIndicator(),
                        onPressed: () async {
                          controller.categoryDelete(idCategory: categoria.id);
                          Navigator.pop(context);
                        })
                  ],
                );
              },
            );
            break;
        }
      },
    );
  }

  showDialogSetCategoria({required Category categoria}) async {
    final WelcomeController controller = Get.find();
    bool loadSave = false;
    bool newProduct = false;
    TextEditingController textEditingController =
        TextEditingController(text: categoria.name);

    if (categoria.id == '') {
      newProduct = true;
      categoria = new Category();
      categoria.id = new DateTime.now().millisecondsSinceEpoch.toString();
    }

    await showDialog<String>(
      context: context,
      builder: (context) {
        return new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Categoria', hintText: 'Ej. golosinas'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Get.back();
                }),
            new TextButton(
                child: loadSave == false
                    ? Text(newProduct ? 'GUARDAR' : "ACTUALIZAR")
                    : CircularProgressIndicator(),
                onPressed: () async {
                  if (textEditingController.text != '') {
                    // set
                    categoria.name = textEditingController.text;
                    setState(() => loadSave = true);
                    // save
                    await controller
                        .categoryUpdate(categoria: categoria)
                        .whenComplete(() {
                      welcomeController.getCatalogueCategoryList.add(categoria);
                      setState(() {
                        Get.back();
                      });
                    }).catchError((error, stackTrace) =>
                            setState(() => loadSave = false));
                  }
                })
          ],
        );
      },
    );
  }
}

// subcategory
class SelectSubCategoria extends StatefulWidget {
  SelectSubCategoria();

  @override
  _SelectSubCategoriaState createState() => _SelectSubCategoriaState();

  static void show() {
    Widget widget = SelectSubCategoria();
    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }
}

class _SelectSubCategoriaState extends State<SelectSubCategoria> {
  _SelectSubCategoriaState();

  // Variables
  late Category categoriaSelected;
  bool crearSubCategoria = false, loadSave = false;
  final ControllerProductsEdit controllerProductsEdit = Get.find();

  @override
  void initState() {
    categoriaSelected = controllerProductsEdit.getCategory;
    crearSubCategoria = false;
    loadSave = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
    if (categoriaSelected.subcategories.length == 0) {
      return ListTile(
        title: Text('Crear subategoría', style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.add),
        onTap: () => showDialogSetSubcategoria(subcategoria: Category()),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      shrinkWrap: true,
      itemCount: categoriaSelected.subcategories.length,
      itemBuilder: (BuildContext _, int index) {
        Category subcategoria = new Category(
            id: categoriaSelected.subcategories.keys
                .elementAt(index)
                .toString(),
            name: categoriaSelected.subcategories.values
                .elementAt(index)
                .toString());
        MaterialColor colorIcon = Utils.getRandomColor();

        return index == 0
            ? Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child:
                            Text('Subategoría', style: TextStyle(fontSize: 18)),
                      )),
                      IconButton(
                          icon: Icon(Icons.add),
                          padding: const EdgeInsets.all(20.0),
                          onPressed: () => showDialogSetSubcategoria(
                              subcategoria: Category()))
                    ],
                  ),
                  Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    leading: CircleAvatar(
                      backgroundColor: colorIcon.withOpacity(0.1),
                      radius: 24.0,
                      child: Text(subcategoria.name.substring(0, 1),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: colorIcon,
                              fontWeight: FontWeight.bold)),
                    ),
                    dense: true,
                    title: Text(subcategoria.name),
                    onTap: () {
                      controllerProductsEdit.setSubcategory = subcategoria;
                      Get.back();
                    },
                    trailing:
                        popupMenuItemSubcategoria(subcategoria: subcategoria),
                  ),
                  Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                ],
              )
            : Column(
                children: <Widget>[
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    leading: CircleAvatar(
                      backgroundColor: colorIcon.withOpacity(0.1),
                      radius: 24.0,
                      child: subcategoria.name != ""
                          ? Text(subcategoria.name.substring(0, 1),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: colorIcon,
                                  fontWeight: FontWeight.bold))
                          : Text("C"),
                    ),
                    dense: true,
                    title: Text(subcategoria.name),
                    onTap: () {
                      controllerProductsEdit.setSubcategory = subcategoria;
                      controllerProductsEdit.updateAll();
                      Get.back();
                    },
                    trailing:
                        popupMenuItemSubcategoria(subcategoria: subcategoria),
                  ),
                  Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                ],
              );
      },
    );
  }

  Widget popupMenuItemSubcategoria({required Category subcategoria}) {
    final WelcomeController controller = Get.find();

    return new PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (_) => <PopupMenuItem<String>>[
        new PopupMenuItem<String>(child: const Text('Editar'), value: 'editar'),
        new PopupMenuItem<String>(
            child: const Text('Eliminar'), value: 'eliminar'),
      ],
      onSelected: (value) async {
        switch (value) {
          case "editar":
            showDialogSetSubcategoria(subcategoria: subcategoria);
            break;
          case "eliminar":
            await showDialog<String>(
              context: context,
              builder: (context) {
                return new AlertDialog(
                  contentPadding: const EdgeInsets.all(16.0),
                  content: new Row(
                    children: <Widget>[
                      new Expanded(
                        child: new Text(
                            "¿Desea continuar eliminando esta subategoría?"),
                      )
                    ],
                  ),
                  actions: <Widget>[
                    new TextButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    new TextButton(
                        child: loadSave == false
                            ? Text("ELIMINAR")
                            : CircularProgressIndicator(),
                        onPressed: () async {
                          controller.getCategorySelect.subcategories
                              .remove(subcategoria.id);
                          // save
                          await controller
                              .categoryUpdate(
                                  categoria: controller.getCategorySelect)
                              .whenComplete(() => Navigator.pop(context))
                              .catchError((error, stackTrace) => setState(() {
                                    loadSave = false;
                                  }));
                        })
                  ],
                );
              },
            );
            break;
        }
      },
    );
  }

  showDialogSetSubcategoria({required Category subcategoria}) async {
    final WelcomeController controller = Get.find();
    bool loadSave = false;
    bool newProduct = false;
    TextEditingController textEditingController =
        TextEditingController(text: subcategoria.name);

    if (subcategoria.id == '') {
      newProduct = true;
      subcategoria = new Category();
      subcategoria.id = new DateTime.now().millisecondsSinceEpoch.toString();
    }

    await showDialog<String>(
      context: context,
      builder: (context) {
        return new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: textEditingController,
                  autofocus: true,
                  decoration: new InputDecoration(
                      labelText: 'Subcategoría', hintText: 'Ej. golosinas'),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Get.back();
                }),
            new TextButton(
                child: loadSave == false
                    ? Text(newProduct ? 'GUARDAR' : "ACTUALIZAR")
                    : CircularProgressIndicator(),
                onPressed: () async {
                  if (textEditingController.text != '') {
                    // set
                    subcategoria.name = textEditingController.text;
                    controllerProductsEdit.getCategory
                        .subcategories[subcategoria.id] = subcategoria.name;
                    setState(() => loadSave = true);
                    // save
                    await controller
                        .categoryUpdate(
                            categoria: controllerProductsEdit.getCategory)
                        .whenComplete(() => Get.back())
                        .catchError((error, stackTrace) =>
                            setState(() => loadSave = false));
                  }
                })
          ],
        );
      },
    );
  }
}

// create marks
class CreateMark extends StatefulWidget {
  late final Mark mark;
  CreateMark({required this.mark, Key? key}) : super(key: key);

  @override
  _CreateMarkState createState() => _CreateMarkState();
}

class _CreateMarkState extends State<CreateMark> {
  // others controllers
  final ControllerProductsEdit controllerProductsEdit = Get.find();

  //var
  var uuid = Uuid();
  bool newMark = false;
  String title = 'Crear nueva marca';
  bool load = false;
  TextStyle textStyle = new TextStyle(fontSize: 24.0);
  ImagePicker _picker = ImagePicker();
  XFile xFile = XFile('');

  @override
  void initState() {
    newMark = widget.mark.id == '';
    title = newMark ? 'Crear nueva marca' : 'Editar';
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      body: body(),
    );
  }

  PreferredSizeWidget appbar() {
    Color? colorAccent = Get.theme.textTheme.bodyText1!.color;

    return AppBar(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Text(
        title,
        style: TextStyle(color: colorAccent),
      ),
      centerTitle: true,
      iconTheme: Get.theme.iconTheme.copyWith(color: colorAccent),
      actions: [
        newMark
            ? Container()
            : IconButton(onPressed: delete, icon: Icon(Icons.delete)),
        load
            ? Container()
            : IconButton(
                icon: Icon(Icons.check),
                onPressed: save,
              ),
      ],
      bottom: load ? linearProgressBarApp() : null,
    );
  }

  Widget body() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              xFile.path != ''
                  ? CircleAvatar(
                      backgroundImage: FileImage(File(xFile.path)),
                      radius: 76,
                    )
                  : CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: widget.mark.image,
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
                    ),
              load
                  ? Container()
                  : TextButton(
                      onPressed: getLoadImageMark,
                      child: Text("Cambiar imagen")),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            enabled: !load,
            controller: new TextEditingController(text: widget.mark.name),
            onChanged: (value) => widget.mark.name = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Nombre de la marca"),
            style: textStyle,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            enabled: !load,
            controller:
                new TextEditingController(text: widget.mark.description),
            onChanged: (value) => widget.mark.description = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Descripción (opcional)"),
            style: textStyle,
          ),
        ),
      ],
    );
  }

  //  MARK CREATE
  void getLoadImageMark() {
    _picker
        .pickImage(
      source: ImageSource.gallery,
      maxWidth: 720.0,
      maxHeight: 720.0,
      imageQuality: 55,
    )
        .then((value) {
      setState(() => xFile = value!);
    });
  }

  void delete() async {
    setState(() {
      load = true;
      title = 'Eliminando...';
    });

    if (widget.mark.id != '') {
      // delele archive storage
      await Database.referenceStorageProductPublic(id: widget.mark.id)
          .delete()
          .catchError((_) => null);
      // delete document firestore
      await Database.refFirestoreMark()
          .doc(widget.mark.id)
          .delete()
          .then((value) {
        // eliminar el objeto de la lista manualmente para evitar hacer una consulta innecesaria
        controllerProductsEdit.getMarks.remove(widget.mark);
        Get.back();
      });
    }
  }

  void save() async {
    setState(() {
      load = true;
      title = newMark ? 'Guardando...' : 'Actualizando...';
    });

    // set values
    widget.mark.verified = true;
    if (widget.mark.id == '') {
      widget.mark.id = uuid.v1();
      if (widget.mark.id == '') {
        widget.mark.id = new DateTime.now().millisecondsSinceEpoch.toString();
      }
    }
    if (widget.mark.name != '') {
      // image save
      // Si el "path" es distinto '' procede a guardar la imagen en la base de dato de almacenamiento
      if (xFile.path != '') {
        Reference ref =
            Database.referenceStorageProductPublic(id: widget.mark.id);
        // referencia de la imagen
        UploadTask uploadTask = ref.putFile(File(xFile.path));
        // cargamos la imagen a storage
        await uploadTask;
        // obtenemos la url de la imagen guardada
        await ref
            .getDownloadURL()
            .then((value) async {
              // set
              widget.mark.image = value;
              // mark save
              await Database.refFirestoreMark()
                  .doc(widget.mark.id)
                  .set(widget.mark.toJson())
                  .whenComplete(() {
                controllerProductsEdit.setUltimateSelectionMark = widget.mark;
                controllerProductsEdit.setMarkSelected = widget.mark;
                // agregar el obj manualmente para evitar consulta a la db  innecesaria
                controllerProductsEdit.getMarks.add(widget.mark);
                Get.back();
              });
            })
            .onError((error, stackTrace) {})
            .catchError((_) {});
      } else {
        // mark save
        await Database.refFirestoreMark()
            .doc(widget.mark.id)
            .set(widget.mark.toJson())
            .whenComplete(() {
          controllerProductsEdit.setUltimateSelectionMark = widget.mark;
          controllerProductsEdit.setMarkSelected = widget.mark;
          // agregar el obj manualmente para evitar consulta a la db  innecesaria
          controllerProductsEdit.getMarks.add(widget.mark);
          Get.back();
        });
      }
    } else {
      Get.snackbar('', 'Debes escribir un nombre de la marca');
    }
  }
}

// select mark
class WidgetSelectMark extends StatefulWidget {
  WidgetSelectMark({Key? key}) : super(key: key);

  @override
  _WidgetSelectMarkState createState() => _WidgetSelectMarkState();
}

class _WidgetSelectMarkState extends State<WidgetSelectMark> {
  //  controllers
  ControllerProductsEdit controllerProductsEdit = Get.find();
  //  var
  List<Mark> list = [];

  @override
  void initState() {
    loadMarks();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widgetView();
  }

  Widget widgetView() {
    if (list.length == 0) {
      return widgetAdd();
    }
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 12),
      shrinkWrap: true,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        Mark marcaSelect = list[index];
        if (index == 0) {
          return Column(
            children: [
              widgetAdd(),
              controllerProductsEdit.getUltimateSelectionMark.id == ''
                  ? Container()
                  : listTile(
                      marcaSelect:
                          controllerProductsEdit.getUltimateSelectionMark),
              listTile(marcaSelect: marcaSelect),
              Divider(endIndent: 12.0, indent: 12.0, height: 0),
            ],
          );
        }
        return Column(
          children: <Widget>[
            listTile(marcaSelect: marcaSelect),
            Divider(endIndent: 12.0, indent: 12.0, height: 0),
          ],
        );
      },
    );
  }

  // WIDGETS COMPONENT
  Widget widgetAdd() {
    return Column(
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(bottom: 12, left: 12, right: 12, top: 12),
          child: Row(
            children: [
              Expanded(child: Text('Marcas', style: TextStyle(fontSize: 18))),
              // TODO : delete icon 'add new mark for release'
              IconButton(
                  onPressed: () {
                    Get.back();
                    Get.to(() => CreateMark(
                        mark: Mark(
                            upgrade: Timestamp.now(),
                            creation: Timestamp.now())));
                  },
                  icon: Icon(Icons.add)),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Get.back();
                  showSearch(
                    context: context,
                    delegate: SearchPage<Mark>(
                      items: list,
                      searchLabel: 'Buscar marca',
                      suggestion: Center(
                        child: Text('ej. Miller'),
                      ),
                      failure: Center(
                        child: Text('No se encontro :('),
                      ),
                      filter: (product) => [
                        product.name,
                        product.description,
                      ],
                      builder: (mark) => Column(
                        children: <Widget>[
                          listTile(marcaSelect: mark),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0),
                        ],
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget listTile({required Mark marcaSelect}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: viewCircleImage(
          texto: marcaSelect.name, url: marcaSelect.image, size: 50.0),
      dense: true,
      title: Text(marcaSelect.name,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: 16.0, color: Get.theme.textTheme.bodyText1!.color)),
      onTap: () {
        controllerProductsEdit.setUltimateSelectionMark = marcaSelect;
        controllerProductsEdit.setMarkSelected = marcaSelect;
        Get.back();
      },
      onLongPress: () {
        // TODO : ver para antes de release
        Get.to(() => CreateMark(mark: marcaSelect));
      },
    );
  }

  // functions
  loadMarks() async {
    if (controllerProductsEdit.getMarks.length == 0) {
      await Database.readListMarksFuture().then((value) {
        setState(() {
          value.docs.forEach((element) {
            Mark mark = Mark.fromMap(element.data());
            mark.id = element.id;
            list.add(mark);
          });
          controllerProductsEdit.setMarks = list;
        });
      });
    } else {
      // datos ya descargados
      list = controllerProductsEdit.getMarks;
      setState(() => list = controllerProductsEdit.getMarks);
    }
  }
}
