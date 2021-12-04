import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producto/app/models/catalogo_model.dart';

class ControllerProductsEdit extends GetxController {
  // variable para mostrar al usaurio una viste para editar o crear un nuevo producto
  bool _newProduct = true;
  set setNewProduct(bool value) => _newProduct = value;
  bool get getNewProduct => _newProduct;

  // parameter
  ProductoNegocio _product = ProductoNegocio();
  set setProduct(ProductoNegocio product) => _product = product;
  ProductoNegocio get getProduct => _product;

  // TextEditingController
  TextEditingController controllerTextEdit_descripcion =
      TextEditingController();
  MoneyMaskedTextController controllerTextEdit_precio_venta =
      MoneyMaskedTextController();
  MoneyMaskedTextController controllerTextEdit_precio_compra =
      MoneyMaskedTextController();

  // editable
  bool _editable = true;
  set setEditable(bool value) => _editable = value;
  bool get getEditable => _editable;

  // marca
  Marca _markSelected = Marca(
      timestampActualizado: Timestamp.now(),
      timestampCreacion: Timestamp.now());
  set setMarkSelected(Marca value) => _markSelected = value;
  Marca get getMarkSelected => _markSelected;

  // imagen

  ImagePicker _picker = ImagePicker();
  XFile _xFileImage = XFile('');
  set setXFileImage(XFile value) => _xFileImage = value;
  XFile get getXFileImage => _xFileImage;

  // indicardor para cuando se guarde los datos
  bool _saveIndicador = false;
  set setSaveIndicator(bool value) => _saveIndicador = value;
  bool get getSaveIndicator => _saveIndicador;

  @override
  void onInit() {
    // llamado inmediatamente después de que se asigna memoria al widget - ej. fetchApi(); //

    // se obtiene el parametro y decidimos si es una vista para editrar o un producto nuevo
    setProduct = Get.arguments['product'] ?? ProductoNegocio();
    if (getProduct.descripcion == '') {
      setNewProduct = true;
    } else {
      setNewProduct = false;
    }
    // load data
    if (getNewProduct == false) loadDataProduct();

    super.onInit();
  }

  @override
  void onReady() {
    // llamado después de que el widget se representa en la pantalla - ej. showIntroDialog(); //
    super.onReady();
  }

  @override
  void onClose() {
    // llamado justo antes de que el controlador se elimine de la memoria - ej. closeStream(); //
    super.onClose();
  }

  void loadDataProduct() {
    controllerTextEdit_descripcion =
        TextEditingController(text: getProduct.descripcion);
    controllerTextEdit_precio_venta =
        MoneyMaskedTextController(initialValue: getProduct.precioVenta);
    controllerTextEdit_precio_compra =
        MoneyMaskedTextController(initialValue: getProduct.precioCompra);
  }

  void getLoadImageGalery() {
    _picker
        .pickImage(
      source: ImageSource.gallery,
      maxWidth: 720.0,
      maxHeight: 720.0,
      imageQuality: 55,
    )
        .then((value) {
      setXFileImage = value!;
      update(['updateAll']);
    });
  }

  void getLoadImageCamera() {
    _picker
        .pickImage(
      source: ImageSource.camera,
      maxWidth: 720.0,
      maxHeight: 720.0,
      imageQuality: 55,
    )
        .then((value) {
      setXFileImage = value!;
      update(['updateAll']);
    });
  }

  /* Widget loadImage() {
    if (getXFileImage.path != '') {
      return Image.file(File(getXFileImage.path));
    } else {
      return Container();
    }
  } */
  Widget loadImage() {
    if (getXFileImage.path != '') {
      // el usuario cargo un nueva imagen externa
      return AspectRatio(
        child: Image.file(File(getXFileImage.path), fit: BoxFit.cover),
        aspectRatio: 100 / 100,
      );
    } else if (getProduct.urlimagen != '') {
      // se visualiza la imagen del producto
      return AspectRatio(
        child: Image.network(getProduct.urlimagen),
        aspectRatio: 100 / 100,
      );
    } else {
      // muestra un fondo gris por defecto
      return AspectRatio(
        aspectRatio: 100 / 100,
        child: Container(
          color: Colors.grey,
          child: Center(
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
          ),
        ),
      );
    }
  }

  void showDialogDelete({required BuildContext buildContext}) {
    showDialog(
      context: buildContext,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
              "¿Seguro que quieres eliminar este producto de tu catálogo?"),
          content: new Text(
              "El producto será eliminado de tu catálogo y toda la información acumulada"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Borrar"),
              onPressed: () {
                Navigator.of(context).pop();
                //deleteProduct(context: buildContext);
              },
            ),
          ],
        );
      },
    );
  }

  showModalSelectMarca() {
    Widget widget = Scaffold();
    // muestre la hoja inferior modal de getx
    Get.bottomSheet(
      widget,
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      enableDrag: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    );

    /* showModalBottomSheet(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        backgroundColor: Theme.of(buildContext).canvasColor,
        context: buildContext,
        builder: (_) {
          // Variables
          listMarcasAll = new List<Marca>();
          return Scaffold(
            appBar: AppBar(
              title: Text("Marcas"),
              actions: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(buildContext).push(MaterialPageRoute(builder: (BuildContext context) =>PageCreateMarca()))
                        .then((value) {
                      setState(() {
                        Navigator.of(buildContext).pop();
                        this.marca = value;
                        this.producto.titulo = this.marca.titulo;
                      });
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () async {
                    if (listMarcasAll.length != 0) {
                      // Muestra un "showSearch" y espera ah revolver un resultado
                      showSearch(
                              context: buildContext,
                              delegate: DataSearchMarcaProduct(
                                  listMarcas: listMarcasAll))
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            Navigator.of(buildContext).pop();
                            this.marca = value;
                            this.producto.titulo = this.marca.titulo;
                          });
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            body: FutureBuilder(
              future: Global.getMarcasAll().getDataMarca(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  listMarcasAll = snapshot.data;
                  if (listMarcasAll.length != 0) {
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      shrinkWrap: true,
                      itemCount: listMarcasAll.length,
                      itemBuilder: (BuildContext context, int index) {
                        Marca marcaSelect = listMarcasAll[index];
                        return Column(
                          children: <Widget>[
                            ListTile(
                              leading: viewCircleImage(texto: marcaSelect.titulo,url: marcaSelect.url_imagen,size: 50.0),
                              dense: true,
                              title: Row(
                                children: <Widget>[
                                  marcaSelect.verificado == true
                                      ? Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: new Image.asset(
                                              'assets/icon_verificado.png',
                                              width: 16.0,
                                              height: 16.0))
                                      : new Container(),
                                  Expanded(
                                    child: Text(marcaSelect.titulo,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .color)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                setState(() {
                                  this.marca = marcaSelect;
                                  this.producto.titulo = this.marca.titulo;
                                  Navigator.pop(buildContext);
                                });
                              },
                              trailing:popupMenuItemCategoria(marca:marcaSelect ),
                            ),
                            Divider(endIndent: 12.0, indent: 12.0),
                          ],
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("Cargando..."));
                  }
                } else {
                  return Center(child: Text("Cargando..."));
                }
              },
            ),
          );
        }); */
  }
}
