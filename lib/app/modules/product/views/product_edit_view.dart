import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/modules/product/controllers/product_edit_controller.dart';
import 'package:producto/app/utils/widgets_utils_app.dart';
import 'package:producto/app/utils/widgets_utils_app.dart' as utilsWidget;

class ProductEdit extends StatelessWidget {
  ProductEdit({Key? key}) : super(key: key);

  final ControllerProductsEdit controller = Get.find();
  final Widget space = SizedBox(
    height: 16.0,
    width: 16.0,
  );

  @override
  Widget build(BuildContext context) {
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
    return AppBar(
      elevation: 0.0,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      iconTheme: Theme.of(contextPrincipal).iconTheme.copyWith(
          color: Theme.of(contextPrincipal).textTheme.bodyText1!.color),
      title: controller.getSaveIndicator
          ? Text(controller.getTextAppBar,
              style: TextStyle(
                  fontSize: 18.0,
                  color: Theme.of(contextPrincipal).textTheme.bodyText1!.color))
          : Text(controller.getIsCatalogue ? 'Editar' : 'Nuevo',
              style: TextStyle(
                  fontSize: 18.0,
                  color:
                      Theme.of(contextPrincipal).textTheme.bodyText1!.color)),
      actions: <Widget>[
        IconButton(
            icon: controller.getSaveIndicator ? Container() : Icon(Icons.check),
            onPressed: controller.save),
      ],
      bottom: controller.getSaveIndicator ? linearProgressBarApp() : null,
    );
  }

  Widget widgetsImagen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: controller.loadImage(),
        ),
        controller.getSaveIndicator
            ? Container()
            : controller.getNewProduct
                ? Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FloatingActionButton.extended(
                          heroTag: '',
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Get.theme.primaryColor,
                          foregroundColor: Colors.white,
                          onPressed: controller.getLoadImageGalery,
                          icon: Icon(Icons.photo_library, color: Colors.white),
                          label: Text('Galeria',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: FloatingActionButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          backgroundColor: Get.theme.primaryColor,
                          foregroundColor: Colors.white,
                          onPressed: controller.getLoadImageCamera,
                          child: Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ),
                    ],
                  )
                : Container(),
      ],
    );
  }

  Widget widgetFormEditText() {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [],
          ),
          buttonsCategory(),
          space,
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: controller.getMarkSelected.id == ''
                  ? controller.showModalSelectMarca
                  : controller.getNewProduct
                      ? controller.showModalSelectMarca
                      : null,
              child: controller.getMarkSelected.id == ''
                  ? Text("Seleccionar marca")
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        utilsWidget.viewCircleImage(
                            size: 25,
                            url: controller.getMarkSelected.urlImage,
                            texto: controller.getMarkSelected.name),
                        SizedBox(width: 5),
                        Text(controller.getMarkSelected.name,
                            style: TextStyle(
                                color: controller.getNewProduct
                                    ? null
                                    : Colors.grey))
                      ],
                    ),
              style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(16))),
            ),
          ),
          space,
          TextField(
            enabled: !controller.getSaveIndicator,
            minLines: 1,
            maxLines: 5,
            keyboardType: TextInputType.multiline,
            //enabled: !producto.verificado,
            onChanged: (value) => controller.getProduct.descripcion = value,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Descripción"),
            //style: controller.getProduct.verificado ? textStyle_disabled : textStyle,
            controller: controller.controllerTextEdit_descripcion,
          ),
          space,
          TextField(
            enabled: !controller.getSaveIndicator,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => controller.getProduct.precioCompra =
                controller.controllerTextEdit_precio_compra.numberValue,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de compra"),
            //style: textStyle,
            controller: controller.controllerTextEdit_precio_compra,
          ),
          space,
          TextField(
            enabled: !controller.getSaveIndicator,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => controller.getProduct.precioVenta =
                controller.controllerTextEdit_precio_venta.numberValue,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Precio de venta"),
            //style: textStyle,
            controller: controller.controllerTextEdit_precio_venta,
          ),
          !controller.getNewProduct ? Container() : space,
          !controller.getNewProduct
              ? Container()
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Text(controller.getProduct.codigo,
                        style: TextStyle(
                            color: Get.theme.textTheme.headline1!.color,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
          space,
          controller.getSaveIndicator
              ? Container()
              : controller.getIsCatalogue
                  ? Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(
                          bottom: 12, top: 40, left: 0, right: 0),
                      child: button(
                          padding: 0,
                          colorAccent: Colors.white,
                          colorButton: Colors.red,
                          icon: Icon(Icons.delete),
                          text: 'Eliminar de mi catálogo',
                          onPressed: controller.showDialogDelete),
                    )
                  : Container(),

          /* OPCIONES PARA DESARROLLADOR - ELIMINAR ESTE CÓDIGO PARA PRODUCCION */
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                  child: Divider(
                height: 2.0,
                endIndent: 12.0,
                indent: 12.0,
              )),
              Text("Opciones para desarrollador"),
              Expanded(
                  child: Divider(height: 1.0, endIndent: 12.0, indent: 12.0))
            ],
          ),
          //SizedBox(height: 20.0),
          //buttonAddFavorite(context: builderContext),
          SizedBox(height: !controller.getSaveIndicator ? 20.0 : 0.0),
          controller.getSaveIndicator
              ? Container()
              : buttonEditProductoOPTDeveloper(),
          SizedBox(height: 20.0),
          controller.getSaveIndicator
              ? Container()
              : buttonDeleteProductoOPTDeveloper(),
          SizedBox(height: 50.0),
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
            : controller.getCategory.nombre,
        maxLines: 1,
        style: TextStyle(
            color: controller.getCategory.id == '' ? null : Colors.grey,
            overflow: TextOverflow.ellipsis));
    Text textSubcategory = Text(
        controller.getSubcategory.id == ''
            ? 'Subcategoría'
            : controller.getSubcategory.nombre,
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
            onPressed:
                controller.getSaveIndicator ? null : SelectSubCategoria.show,
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
      {required Widget icon,
      String text = '',
      required dynamic onPressed,
      double padding = 12.0,
      Color colorButton = Colors.purple,
      Color colorAccent = Colors.white}) {
    return FadeInRight(
        child: Padding(
      padding: EdgeInsets.all(padding),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            padding: EdgeInsets.all(12.0),
            primary: colorButton,
            textStyle: TextStyle(color: colorAccent)),
        icon: icon,
        label: Text(text, style: TextStyle(color: colorAccent)),
      ),
    ));
  }

  // TODO: OPCIONES PARA EL DESARROLLADOR ( Eliminar para producción )
  /* Widget buttonAddFavorite({@required BuildContext context}) {
    return this.producto.favorite? SizedBox(
            width: double.infinity,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {setState(() {this.producto.favorite=!this.producto.favorite;});},
                style: ElevatedButton.styleFrom(padding:EdgeInsets.all(12.0),primary: Colors.grey[900],onPrimary: Colors.white30,textStyle: TextStyle(color: Colors.black)),
                icon: Icon(Icons.favorite, color: Colors.white),
                label: Text("Quitar de favoritos",style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        : SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {setState(() {this.producto.favorite=!this.producto.favorite;});},
              style: ElevatedButton.styleFrom(padding:EdgeInsets.all(12.0),primary: Colors.orange[400],onPrimary: Colors.white30,textStyle: TextStyle(color: Colors.black)),
              icon: Icon(Icons.favorite, color: Colors.white),
              label: Text("Agregar a favoritos",style: TextStyle( color: Colors.white)),
            ),
          );
  } */
  Widget buttonEditProductoOPTDeveloper() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.saveProductGlobal,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(12.0),
            primary: Colors.orange[400],
            onPrimary: Colors.white30,
            textStyle: TextStyle(color: Colors.black)),
        icon: Icon(Icons.security, color: Colors.white),
        label: Text("Editar", style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget buttonDeleteProductoOPTDeveloper() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          showDialogDeleteOPTDeveloper();
        },
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(12.0),
            primary: Colors.red[400],
            onPrimary: Colors.white30,
            textStyle: TextStyle(color: Colors.black)),
        icon: Icon(Icons.security, color: Colors.white),
        label: Text("Borrar producto (Moderador)",
            style: TextStyle(color: Colors.white)),
      ),
    );
  }

  void showDialogDeleteOPTDeveloper() {
    Get.dialog(AlertDialog(
      title: new Text(
          "¿Seguro que quieres eliminar este producto definitivamente? (Desarrollador)"),
      content: new Text(
          "El producto será eliminado de tu catálogo ,de la base de dato global y toda la información acumulada menos el historial de precios registrado"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new TextButton(
          child: new Text("Cancelar"),
          onPressed: () =>Get.back(),
        ),
        new TextButton(
          child: new Text("Borrar"),
          onPressed: () {
            Get.back();
            controller.deleteProducGlobal();
          },
        ),
      ],
    ));
  }

  void showDialogSaveOPTDeveloper() {
    Get.dialog(AlertDialog(
      title: new Text(
          "¿Seguro que quieres actualizar este producto? (Desarrollador)"),
      content: new Text(
          "El producto será actualizado de tu catálogo ,de la base de dato global y toda la información acumulada menos el historial de precios registrado"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        new TextButton(
          child: new Text("Cancelar"),
          onPressed: () => Get.back(),
        ),
        new TextButton(
          child: new Text("Borrar"),
          onPressed: () {
            Get.back();
            controller.saveProductGlobal();
          },
        ),
      ],
    ));
  }
}

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }
}

class _SelectCategoryState extends State<SelectCategory> {
  _SelectCategoryState();

  // Variables
  final Categoria categoriaSelected = Categoria();
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
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shrinkWrap: true,
        itemCount: welcomeController.getCatalogueCategoryList.length,
        itemBuilder: (BuildContext context, int index) {
          Categoria categoria =
              welcomeController.getCatalogueCategoryList[index];
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
                                showDialogSetCategoria(categoria: Categoria()))
                      ],
                    ),
                    Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                    ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black26,
                        radius: 24.0,
                        child: Text(categoria.nombre.substring(0, 1),
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      dense: true,
                      title: Text(categoria.nombre),
                      onTap: () {
                        controllerProductsEdit.setCategory = categoria;
                        controllerProductsEdit.updateAll();
                        Get.back();
                      },
                      trailing: popupMenuItemCategoria(categoria: categoria),
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
                        backgroundColor: Colors.black26,
                        radius: 24.0,
                        child: categoria.nombre != ""
                            ? Text(categoria.nombre.substring(0, 1),
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold))
                            : Text("C"),
                      ),
                      dense: true,
                      title: Text(categoria.nombre),
                      onTap: () {
                        controllerProductsEdit.setCategory = categoria;
                        controllerProductsEdit.setSubcategory = Categoria();
                        Get.back();
                      },
                      trailing: popupMenuItemCategoria(categoria: categoria),
                    ),
                    Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                  ],
                );
        },
      ),
    );
  }

  Widget popupMenuItemCategoria({required Categoria categoria}) {
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

  showDialogSetCategoria({required Categoria categoria}) async {
    final WelcomeController controller = Get.find();
    bool loadSave = false;
    bool newProduct = false;
    TextEditingController textEditingController =
        TextEditingController(text: categoria.nombre);

    if (categoria.id == '') {
      newProduct = true;
      categoria = new Categoria();
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
                    categoria.nombre = textEditingController.text;
                    setState(() => loadSave = true);
                    // save
                    await controller
                        .categoryUpdate(categoria: categoria)
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }
}

class _SelectSubCategoriaState extends State<SelectSubCategoria> {
  _SelectSubCategoriaState();

  // Variables
  late Categoria categoriaSelected;
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
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      shrinkWrap: true,
      itemCount: categoriaSelected.subcategorias.length,
      itemBuilder: (BuildContext _, int index) {
        Categoria subcategoria = new Categoria(
            id: categoriaSelected.subcategorias.keys
                .elementAt(index)
                .toString(),
            nombre: categoriaSelected.subcategorias.values
                .elementAt(index)
                .toString());

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
                              subcategoria: Categoria()))
                    ],
                  ),
                  Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                  ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    leading: CircleAvatar(
                      backgroundColor: Colors.black26,
                      radius: 24.0,
                      child: Text(subcategoria.nombre.substring(0, 1),
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                    ),
                    dense: true,
                    title: Text(subcategoria.nombre),
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
                      backgroundColor: Colors.black26,
                      radius: 24.0,
                      child: subcategoria.nombre != ""
                          ? Text(subcategoria.nombre.substring(0, 1),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                          : Text("C"),
                    ),
                    dense: true,
                    title: Text(subcategoria.nombre),
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

  Widget popupMenuItemSubcategoria({required Categoria subcategoria}) {
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
                          controller.getCategorySelect.subcategorias
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

  showDialogSetSubcategoria({required Categoria subcategoria}) async {
    final WelcomeController controller = Get.find();
    bool loadSave = false;
    bool newProduct = false;
    TextEditingController textEditingController =
        TextEditingController(text: subcategoria.nombre);

    if (subcategoria.id == '') {
      newProduct = true;
      subcategoria = new Categoria();
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
                    subcategoria.nombre = textEditingController.text;
                    controller.getCategorySelect
                        .subcategorias[subcategoria.id] = subcategoria.nombre;
                    setState(() => loadSave = true);
                    // save
                    await controller
                        .categoryUpdate(categoria: controller.getCategorySelect)
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
