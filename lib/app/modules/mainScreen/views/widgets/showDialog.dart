import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/services/database.dart';

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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );
  }
}

class _ViewCategoriaState extends State<ViewCategoria> {
  _ViewCategoriaState({required this.buildContextPrincipal});

  // Variables
  final Categoria categoriaSelected = Categoria();
  bool crearCategoria = false, loadSave = false;
  final BuildContext buildContextPrincipal;
  final WelcomeController controller = Get.find();

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
        itemCount: controller.getCatalogueCategoryList.length,
        itemBuilder: (BuildContext context, int index) {
          Categoria categoria = controller.getCatalogueCategoryList[index];
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
                            onPressed: () {} //_showDialogSetCategoria(),
                            )
                      ],
                    ),
                    controller.getCatalogueCategoryList.length != 0
                        ? ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            leading: CircleAvatar(
                              radius: 24.0,
                              child: Icon(Icons.all_inclusive),
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
                        Get.back();
                        controller.setCategorySelect = categoria;
                        ViewSubCategoria.show(
                            buildContext: buildContext, categoria: categoria);
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
                        Get.back();
                        controller.setCategorySelect = categoria;
                        ViewSubCategoria.show(
                            buildContext: buildContext, categoria: categoria);
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
            _showDialogSetCategoria(categoria: categoria);
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

  _showDialogSetCategoria({required Categoria categoria}) async {
    bool loadSave = false;
    bool newProduct = false;
    TextEditingController textEditingController =  TextEditingController(text: categoria.nombre);

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
                onPressed: () async{
                   await controller.categoryEdit(categoria: categoria);
                   Get.back();
                })
          ],
        );
      },
    );
  }
}

class ViewSubCategoria extends StatefulWidget {
  final BuildContext buildContext;
  final Categoria categoria;
  ViewSubCategoria({required this.buildContext, required this.categoria});

  @override
  _ViewSubCategoriaState createState() => _ViewSubCategoriaState(
      buildContextPrincipal: buildContext, categoriaSelected: categoria);

  static void show(
      {required BuildContext buildContext, required Categoria categoria}) {
    Widget widget =
        ViewSubCategoria(buildContext: buildContext, categoria: categoria);
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

class _ViewSubCategoriaState extends State<ViewSubCategoria> {
  _ViewSubCategoriaState(
      {required this.buildContextPrincipal, required this.categoriaSelected});

  // Variables
  late Categoria categoriaSelected;
  bool crearSubCategoria = false, loadSave = false;
  final BuildContext buildContextPrincipal;
  final WelcomeController controller = Get.find();

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
                          onPressed: () {} //_showDialogSetCategoria(),
                          )
                    ],
                  ),
                  categoriaSelected.subcategorias.length != 0
                      ? ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          leading: CircleAvatar(
                            radius: 24.0,
                            child: Icon(Icons.all_inclusive),
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
                      controller.setsubCategorySelect = subcategoria;
                      Get.back();
                    },
                    trailing: popupMenuItemCategoria(categoria: subcategoria),
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
                      controller.setsubCategorySelect = subcategoria;
                      Get.back();
                    },
                    trailing: popupMenuItemCategoria(categoria: subcategoria),
                  ),
                  Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                ],
              );
      },
    );
  }

  Widget popupMenuItemCategoria({required Categoria categoria}) {
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
            _showDialogSetCategoria(categoria: categoria);
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
                          /* await Global.getDataCatalogoCategoria(
                                idNegocio: Global.oPerfilNegocio.id,
                                idCategoria: categoria.id)
                            .deleteDoc();
                        setState(() {
                          for (var i = 0;
                              i < Global.listCategoriasCatalogo.length;
                              i++) {
                            if (Global.listCategoriasCatalogo[i].id ==
                                categoria.id) {
                              Global.listCategoriasCatalogo.remove(i);
                            }
                          }
                          Navigator.pop(context);
                        }); */
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

  _showDialogSetCategoria({required Categoria categoria}) async {
    bool loadSave = false;
    bool newProduct = false;
    TextEditingController controller =
        TextEditingController(text: categoria.nombre);

    await showDialog<String>(
      context: context,
      builder: (context) {
        return new AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  controller: controller,
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
                  Navigator.pop(context);
                }),
            new TextButton(
                child: loadSave == false
                    ? Text(newProduct ? 'GUARDAR' : "ACTUALIZAR")
                    : CircularProgressIndicator(),
                onPressed: () async {
                  /* if (controller.text != "") {
                  setState(() {
                    loadSave = true;
                  });
                  categoria.nombre = controller.text;
                  await Global.getDataCatalogoCategoria(
                          idNegocio: Global.oPerfilNegocio.id,
                          idCategoria: categoria.id)
                      .upSetCategoria(categoria.toJson());
                  Navigator.pop(context);
                } else {} */
                })
          ],
        );
      },
    );
  }
}
