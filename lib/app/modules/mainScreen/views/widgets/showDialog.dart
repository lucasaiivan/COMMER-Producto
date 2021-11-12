import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';

class ViewCategoria extends StatefulWidget {
  final BuildContext buildContext;
  ViewCategoria({required this.buildContext});

  @override
  _ViewCategoriaState createState() =>
      _ViewCategoriaState(buildContextPrincipal: buildContext);

  static void show({required BuildContext buildContext}) {
    /* showModalBottomSheet(
        context: buildContext,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Get.theme.canvasColor,
        builder: (ctx) {
          return ClipRRect(child: ViewCategoria(buildContext: buildContext));
        });
 */
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
                              /* buildContext
                                          .read<ProviderCatalogo>()
                                          .setNombreFiltro = "Todos";
                                      buildContext.read<ProviderCatalogo>()
                                        )  .setCategoria = null;
                                buildContext
                                    .read<ProviderCatalogo>()
                                    .setIdMarca = "";
                                Navigator.pop(context,
                                    Global.listCategoriasCatalogo[index]); */
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
                        controller.setCategorySelect = categoria;
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
                        controller.setCategorySelect = categoria;
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
    if (categoria == null) {
      newProduct = true;
      categoria = new Categoria();
      categoria.id = new DateTime.now().millisecondsSinceEpoch.toString();
    }
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

/* class ViewSubCategoria extends StatefulWidget {
  final Categoria categoria;
  final BuildContext buildContextCategoria;
  ViewSubCategoria({required this.buildContextCategoria, required this.categoria});

  @override
  ViewSubCategoriaState createState() => ViewSubCategoriaState(
      paramCategoria: this.categoria,
      buildContextCategoria: buildContextCategoria);
}

class ViewSubCategoriaState extends State<ViewSubCategoria> {
  ViewSubCategoriaState({required this.buildContextCategoria, required this.paramCategoria});
  // Variables
  final BuildContext buildContextCategoria;
  final Categoria paramCategoria ;
  bool crearCategoria=false, loadSave = false;
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
  Widget build(BuildContext buildContextSubcategoria) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Subcategoria"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                _showDialogSetSubCategoria(categoria: this.paramCategoria),
          )
        ],
      ),
      body: controller.getsubCatalogueCategoryList.length != 0
          ? ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 15.0),
              shrinkWrap: true,
              itemCount: controller.getsubCatalogueCategoryList.length,
              itemBuilder: (BuildContext context, int index) {
                Categoria subcategoria = new Categoria(
                    id: this
                        .paramCategoria
                        .subcategorias
                        .keys
                        .elementAt(index)
                        .toString(),
                    nombre: this
                        .paramCategoria
                        .subcategorias
                        .values
                        .elementAt(index)
                        .toString());
                return index == 0
                    ? Column(
                        children: <Widget>[
                          this.paramCategoria.subcategorias.length != 0
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
                                    Navigator.pop(buildContextCategoria);
                                    Navigator.pop(buildContextSubcategoria);
                                  },
                                )
                              : Container(),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
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
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setNombreFiltro = subcategoria.nombre;
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setSubategoria = subcategoria;
                              Navigator.pop(buildContextCategoria);
                              Navigator.pop(buildContextSubcategoria);
                            },
                            trailing: popupMenuItemSubCategoria(
                                categoria: paramCategoria,
                                subcategoria: subcategoria),
                          ),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                        ],
                      )
                    : Column(
                        children: <Widget>[
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
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
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setNombreFiltro = subcategoria.nombre;
                              buildContextSubcategoria
                                  .read<ProviderCatalogo>()
                                  .setSubategoria = subcategoria;
                              Navigator.pop(buildContextCategoria);
                              Navigator.pop(buildContextSubcategoria);
                            },
                            trailing: popupMenuItemSubCategoria(
                                categoria: paramCategoria,
                                subcategoria: subcategoria),
                          ),
                          Divider(endIndent: 12.0, indent: 12.0, height: 0.0),
                        ],
                      );
              },
            )
          : ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              leading: CircleAvatar(
                radius: 24.0,
                child: Icon(Icons.all_inclusive),
              ),
              dense: true,
              title: Text("Mostrar todos", style: TextStyle(fontSize: 16.0)),
              onTap: () {
                Navigator.pop(buildContextCategoria);
                Navigator.pop(buildContextSubcategoria);
              },
            ),
    );
  }

  Widget popupMenuItemSubCategoria(
      {@required Categoria categoria, @required Categoria subcategoria}) {
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
            _showDialogSetSubCategoria(
                categoria: categoria, subcategoria: subcategoria);
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
                          "¿Desea continuar eliminando esta subcategoría?"),
                    )
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                      child: const Text('CANCEL'),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  new FlatButton(
                      child: loadSave == false
                          ? Text("ELIMINAR")
                          : CircularProgressIndicator(),
                      onPressed: () async {
                        categoria.subcategorias.remove(subcategoria.id);
                        await Global.getDataCatalogoCategoria(
                                idNegocio: Global.oPerfilNegocio.id,
                                idCategoria: categoria.id)
                            .upSetCategoria(categoria.toJson());
                        setState(() {
                          Navigator.pop(context);
                        });
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

  _showDialogSetSubCategoria(
      {@required Categoria categoria, Categoria subcategoria}) async {
    bool newSubcategoria = false;
    if (subcategoria == null) {
      newSubcategoria = true;
      subcategoria = new Categoria();
      subcategoria.id = new DateTime.now().millisecondsSinceEpoch.toString();
    }
    bool loadSave = false;
    TextEditingController controller =
        TextEditingController(text: subcategoria.nombre);

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
                    labelText: 'Subcategoria', hintText: 'Ej. chocolates'),
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
                  ? Text(newSubcategoria ? 'GUARDAR' : "ACTUALIZAR")
                  : CircularProgressIndicator(),
              onPressed: () async {
                if (controller.text != "") {
                  setState(() {
                    loadSave = true;
                  });
                  subcategoria.nombre = controller.text;
                  categoria.subcategorias[subcategoria.id] =
                      subcategoria.nombre;
                  await Global.getDataCatalogoCategoria(
                          idNegocio: Global.oPerfilNegocio.id,
                          idCategoria: categoria.id)
                      .upSetCategoria(categoria.toJson());
                  Navigator.pop(context);
                } else {}
              })
        ],
      );
      },
    );
  }
} */