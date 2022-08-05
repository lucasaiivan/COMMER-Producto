import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';

import '../../../../utils/functions.dart';

class ViewCategoria extends StatefulWidget {
  final BuildContext buildContext;
  ViewCategoria({required this.buildContext});

  @override
  _ViewCategoriaState createState() =>
      _ViewCategoriaState(buildContextPrincipal: buildContext);

  static void show({required BuildContext buildContext}) {
    Widget widget = ViewCategoria(buildContext: buildContext);
    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
  }
}

class _ViewCategoriaState extends State<ViewCategoria> {
  _ViewCategoriaState({required this.buildContextPrincipal});

  // Variables
  final Category categoriaSelected = Category();
  bool crearCategoria = false, loadSave = false;
  final BuildContext buildContextPrincipal;
  final HomeController controller = Get.find();

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
    if (controller.getCatalogueCategoryList.length == 0) {
      return ListTile(
        onTap:() => showDialogSetCategoria(categoria: Category()),
        title: Text('Crear categoría', style: TextStyle(fontSize: 18)),
        trailing: Icon(Icons.add),
      );
    }
    return Obx(
      () => ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        shrinkWrap: true,
        itemCount: controller.getCatalogueCategoryList.length,
        itemBuilder: (BuildContext context, int index) {

          //get 
          Category categoria = controller.getCatalogueCategoryList[index];
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
                    controller.getCatalogueCategoryList.length != 0
                        ? ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            leading: CircleAvatar(
                              backgroundColor: color.withOpacity(0.1),
                              radius: 24.0,
                              child: Icon(Icons.all_inclusive,color: color),
                            ),
                            dense: true,
                            title: Text("Mostrar todos",
                                style: TextStyle(fontSize: 16.0)),
                            onTap: () {
                              controller.catalogueFilterReset();
                              Get.back();
                            },
                          )
                        : Container(),
                    Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                    listTileItem(categoria: categoria),
                    Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                  ],
                )
              : Column(
                  children: <Widget>[
                    listTileItem(categoria: categoria),
                    Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                  ],
                );
        },
      ),
    );
  }

  // listTile view
  Widget listTileItem({required Category categoria}) {

    //  values 
    MaterialColor color = Utils.getRandomColor();

    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
        Get.back();
        controller.setCategorySelect = categoria;
        ViewSubCategoria.show(categoria: categoria);
      },
      trailing: dropdownButtonCategory(categoria: categoria),
    );
  }

  // menu options
  Widget dropdownButtonCategory({required Category categoria}) {
    final HomeController controller = Get.find();

    return DropdownButton<String>(
      icon: Icon(Icons.more_vert),
      value: null,
      elevation: 10,
      underline: Container(),
      items: [
        DropdownMenuItem(
          child: Text("Editar"),
          value: 'editar',
        ),
        DropdownMenuItem(
          child: Text("Eliminar"),
          value: 'eliminar',
        ),
      ],
      onChanged: (value) async {
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
                          Get.back();
                        }),
                    new TextButton(
                        child: loadSave == false
                            ? Text("ELIMINAR")
                            : CircularProgressIndicator(),
                        onPressed: () async {
                          controller.categoryDelete(idCategory: categoria.id);
                          Get.back();
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
    final HomeController controller = Get.find();
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

class ViewSubCategoria extends StatefulWidget {
  final Category categoria;
  ViewSubCategoria({required this.categoria});

  @override
  _ViewSubCategoriaState createState() =>
      _ViewSubCategoriaState(categoriaSelected: categoria);

  static void show({required Category categoria}) {
    Widget widget = ViewSubCategoria(categoria: categoria);
    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
    );
    
  }


  
}

class _ViewSubCategoriaState extends State<ViewSubCategoria> {
  _ViewSubCategoriaState({required this.categoriaSelected});

  // Variables
  late Category categoriaSelected;
  bool crearSubCategoria = false, loadSave = false;
  final HomeController controller = Get.find();

  @override
  void initState() {
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
      return Row(
        children: [
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Subategoría', style: TextStyle(fontSize: 18)),
          )),
          IconButton(
              icon: Icon(Icons.add),
              padding: const EdgeInsets.all(20.0),
              onPressed: () =>
                  showDialogSetSubcategoria(subcategoria: Category()))
        ],
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      shrinkWrap: true,
      itemCount: categoriaSelected.subcategories.length,
      itemBuilder: (BuildContext _, int index) {

        //  values 
        MaterialColor color = Utils.getRandomColor();
        Category subcategoria = new Category(
            id: categoriaSelected.subcategories.keys
                .elementAt(index)
                .toString(),
            name: categoriaSelected.subcategories.values
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
                              subcategoria: Category()))
                    ],
                  ),
                  categoriaSelected.subcategories.length != 0
                      ? ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.1),
                            radius: 24.0,
                            child: Icon(Icons.all_inclusive,color: color,),
                          ),
                          dense: true,
                          title: Text("Mostrar todos",
                              style: TextStyle(fontSize: 16.0)),
                          onTap: () {
                            controller.setCategorySelect = categoriaSelected;
                            Get.back();
                          },
                        )
                      : Container(),
                  Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                  listTileItem(subcategoria: subcategoria),
                  Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                ],
              )
            : Column(
                children: <Widget>[
                  listTileItem(subcategoria: subcategoria),
                  Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                ],
              );
      },
    );
  }

  // listTile view
  Widget listTileItem({required Category subcategoria}) {
    
    //  values 
    MaterialColor color = Utils.getRandomColor();

    return ListTile(
      contentPadding:
          EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        radius: 24.0,
        child: subcategoria.name != ""
            ? Text(subcategoria.name.substring(0, 1),
                style: TextStyle(
                    fontSize: 18.0,
                    color: color,
                    fontWeight: FontWeight.bold))
            : Text("C"),
      ),
      dense: true,
      title: Text(subcategoria.name),
      onTap: () {
        controller.setsubCategorySelect = subcategoria;
        Get.back();
      },
      trailing:
          dropdownButtonSubcategory(subcategoria: subcategoria),
    );
  }

  // menu options
  Widget dropdownButtonSubcategory({required Category subcategoria}) {
    final HomeController controller = Get.find();

    return DropdownButton<String>(
      icon: Icon(Icons.more_vert),
      value: null,
      elevation: 10,
      underline: Container(),
      items: [
        DropdownMenuItem(
          child: Text("Editar"),
          value: 'editar',
        ),
        DropdownMenuItem(
          child: Text("Eliminar"),
          value: 'eliminar',
        ),
      ],
      onChanged: (value) async {
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
                        child: const Text('CANCEL'), onPressed: Get.back),
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
                              .whenComplete(() => Get.back())
                              .catchError((error, stackTrace) =>
                                  setState(() => loadSave = false));
                          Get.back();
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
    final HomeController controller = Get.find();
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
                    controller.getCategorySelect
                        .subcategories[subcategoria.id] = subcategoria.name;
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
