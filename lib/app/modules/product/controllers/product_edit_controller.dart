import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:producto/app/models/catalogo_model.dart';
import 'package:producto/app/modules/mainScreen/controllers/welcome_controller.dart';
import 'package:producto/app/services/database.dart';

import '../views/product_edit_view.dart';

class ControllerProductsEdit extends GetxController {
  // others controllers
  final WelcomeController welcomeController = Get.find();

  // text appbar
  String _textAppbar = 'Editar';
  set setTextAppBar(String value) => _textAppbar = value;
  String get getTextAppBar => _textAppbar;

  // variable para saber si el producto ya esta o no en el cátalogo
  bool _inCatalogue = false;
  set setIsCatalogue(bool value) => _inCatalogue = value;
  bool get getIsCatalogue => _inCatalogue;

  // variable para mostrar al usuario una viste para editar o crear un nuevo producto
  bool _newProduct = true;
  set setNewProduct(bool value) => _newProduct = value;
  bool get getNewProduct => _newProduct;

  // variable para editar el documento en modo de moderador
  bool _edit = false;
  set setEdit(bool value) {
    _edit = value;
    update(['updateAll']);
  }

  bool get getEdit => _edit;

  // parameter
  ProductCatalogue _product = ProductCatalogue(
      upgrade: Timestamp.now(),
      creation: Timestamp.now());
  set setProduct(ProductCatalogue product) => _product = product;
  ProductCatalogue get getProduct => _product;

  // TextEditingController
  TextEditingController controllerTextEdit_descripcion =
      TextEditingController();
  MoneyMaskedTextController controllerTextEdit_precio_venta =
      MoneyMaskedTextController();
  MoneyMaskedTextController controllerTextEdit_precio_compra =
      MoneyMaskedTextController();

  // marca
  Mark _markSelected = Mark(
      upgrade: Timestamp.now(), creation: Timestamp.now());
  set setMarkSelected(Mark value) {
    _markSelected = value;
    getProduct.idMark = value.id;
    getProduct.nameMark = value.name;
    update(['updateAll']);
  }

  Mark get getMarkSelected => _markSelected;

  // marcas
  List<Mark> _marks = [];
  set setMarks(List<Mark> value) => _marks = value;
  List<Mark> get getMarks => _marks;

  //  category
  Category _category = Category();
  set setCategory(Category value) {
    _category = value;
    getProduct.category = value.id;
    getProduct.nameCategory = value.name;
    update(['updateAll']);
  }

  Category get getCategory => _category;

  //  subcategory
  Category _subcategory = Category();
  set setSubcategory(Category value) {
    _subcategory = value;
    getProduct.subcategory = value.id;
    getProduct.nameSubcategory = value.name;
    update(['updateAll']);
  }

  Category get getSubcategory => _subcategory;

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
    setProduct = Get.arguments['product'] ??
        ProductCatalogue(
            upgrade: Timestamp.now(),
            creation: Timestamp.now());
    if (getProduct.description == '') {
      setNewProduct = true;
    } else {
      setNewProduct = false;
    }
    // load data product
    if (getNewProduct == false) {
      // el documento existe
      loadDataProduct();
      isCatalogue();
    }

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

  updateAll() => update(['updateAll']);
  back() => Get.back();

  isCatalogue() {
    welcomeController.getCataloProducts.forEach((element) {
      if (element.id == getProduct.id) {
        setIsCatalogue = true;
        update(['updateAll']);
      }
    });
  }

  Future<void> save() async {
    if (getProduct.id != '') {
      if (getProduct.category != '') {
        if (getProduct.description != '') {
          if (getProduct.idMark != '' && getProduct.nameMark != '') {
            if(getProduct.salePrice != 0 ){
              // activate indicator load
              setSaveIndicator = true;
              setTextAppBar = 'Actualizando...';
              updateAll();

              // image
              // Si el "path" es distinto '' procede a guardar la imagen en la base de dato de almacenamiento
              if (getXFileImage.path != '') {
                Reference ref = FirebaseStorage.instance
                    .ref()
                    .child("APP")
                    .child("ARG")
                    .child("PRODUCTOS")
                    .child(getProduct.id);
                UploadTask uploadTask = ref.putFile(File(getXFileImage.path));
                await uploadTask;
                // obtenemos la url de la imagen guardada
                await ref
                    .getDownloadURL()
                    .then((value) => getProduct.image = value);
              }
              // Mods - save data product global
              if (getNewProduct || getEdit) {
                getProduct.verified =true; // TODO: Para desarrollo verificado es FALSE // Cambiar esto cuando se lanze a producción
                saveProductPublic();
              }

              // registra el precio en una colección publica para todos los usuarios
              if (welcomeController.getProfileAccountSelected.id != "") {
                Price precio = new Price(
                  id: welcomeController.getProfileAccountSelected.id,
                  idAccount: welcomeController.getProfileAccountSelected.id,
                  imageAccount: welcomeController.getProfileAccountSelected.image,
                  nameAccount: welcomeController.getProfileAccountSelected.name ,
                  price: getProduct.salePrice,
                  currencySign: getProduct.currencySign,
                  province:welcomeController.getProfileAccountSelected.province,
                  town: welcomeController.getProfileAccountSelected.town,
                  time: Timestamp.fromDate(new DateTime.now()),
                );
                // Firebase set
                await Database.refFirestoreRegisterPrice(
                        idProducto: getProduct.id, isoPAis: 'ARG')
                    .doc(precio.id)
                    .set(precio.toJson());
              }
              // add/update data product in catalogue
              getProduct.upgrade = Timestamp.now();
              Database.refFirestoreCatalogueProduct(
                      idAccount: welcomeController.getProfileAccountSelected.id)
                  .doc(getProduct.id)
                  .set(getProduct.toJson())
                  .whenComplete(() async {
                    await Future.delayed(Duration(seconds: 3)).then((value) {
                      setSaveIndicator = false;
                      Get.back();
                      Get.back();
                    });
                  })
                  .onError((error, stackTrace) => setSaveIndicator = false)
                  .catchError((_) => setSaveIndicator = false);
          } else {
            Get.snackbar(
                '😐', 'debe proporcionar un precio');
          }
          } else {
            Get.snackbar(
                'No se puedo continuar 😐', 'debes seleccionar una marca');
          }
        } else {
          Get.snackbar('No se puedo continuar 👎',
              'debes escribir una descripción del producto');
        }
      } else {
        Get.snackbar(
            'No se puedo guardar los datos', 'debes seleccionar una categoría');
      }
    }
  }

  // DEVELOPER OPTIONS
  Future<void> saveProductPublic() async {
    if (getProduct.id != '') {
      if (getProduct.category != '') {
        if (getProduct.description != '') {
          if (getProduct.idMark != '') {

            // activate indicator load
            setSaveIndicator = true;
            setTextAppBar = 'Actualizando...';
            updateAll();

            // set
            Product newProduct = getProduct.convertProductoDefault();
            newProduct.idAccount =welcomeController.getProfileAccountSelected.id;
            newProduct.upgrade =  Timestamp.fromDate(new DateTime.now());

            // firestore - save product public
            await Database.refFirestoreProductPublic()
                .doc(newProduct.id)
                .set(newProduct.toJson())
                .whenComplete(() {
              Get.back();
              Get.back();
            });
          } else {
            Get.snackbar(
                'No se puedo continuar 😐', 'debes seleccionar una marca');
          }
        } else {
          Get.snackbar('No se puedo continuar 👎',
              'debes escribir una descripción del producto');
        }
      } else {
        Get.snackbar(
            'No se puedo guardar los datos', 'debes seleccionar una categoría');
      }
    }
  }

  void deleteProducPublic() async {
    // activate indicator load
    setSaveIndicator = true;
    setTextAppBar = 'Eliminando...';
    updateAll();

    // delete doc product in catalogue account
    await Database.refFirestoreCatalogueProduct(
            idAccount: welcomeController.getProfileAccountSelected.id)
        .doc(getProduct.id)
        .delete();
    // delete doc product
    await Database.refFirestoreProductPublic()
        .doc(getProduct.id)
        .delete()
        .whenComplete(() {
      Get.back();
      Get.back();
    });
  }

  void loadDataProduct() {
    // set
    controllerTextEdit_descripcion =
        TextEditingController(text: getProduct.description);
    controllerTextEdit_precio_venta =
        MoneyMaskedTextController(initialValue: getProduct.salePrice);
    controllerTextEdit_precio_compra =
        MoneyMaskedTextController(initialValue: getProduct.purchasePrice);

    // primero verificamos que no tenga el metadato del dato de la marca para hacer un consulta inecesaria
    if (getProduct.idMark != '') readMarkProducts();
    if (getProduct.category != '') readCategory();
  }

  void readMarkProducts() {
    Database.readMarkFuture(id: getProduct.idMark).then((value) {
      setMarkSelected = Mark.fromMap(value.data() as Map);
      getProduct.nameMark = getMarkSelected.name; // guardamos un metadato
      update(['updateAll']);
    }).onError((error, stackTrace) {
      setMarkSelected = Mark(
          upgrade: Timestamp.now(), creation: Timestamp.now());
    }).catchError((_) {
      setMarkSelected = Mark(
          upgrade: Timestamp.now(), creation: Timestamp.now());
    });
  }

  void readCategory() {
    Database.readCategotyCatalogueFuture(
            idAccount: welcomeController.getProfileAccountSelected.id,
            idCategory: getProduct.category)
        .then((value) {
      setCategory = Category.fromDocumentSnapshot(documentSnapshot: value);
      if (getProduct.subcategory != '') readSubcategory();
    }).onError((error, stackTrace) {
      setCategory = Category(id: '0000', name: '');
      setSubcategory = Category(id: '0000', name: '');
    }).catchError((_) {
      setCategory = Category(id: '0000', name: '');
      setSubcategory = Category(id: '0000', name: '');
    });
  }

  void readSubcategory() {
    getCategory.subcategories.forEach((key, value) {
      if (key == getProduct.subcategory) {
        setSubcategory = Category(id: key, name: value.toString());
      }
    });
  }

  // read imput image
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

  Widget loadImage() {
    // devuelve la imagen del product
    if (getXFileImage.path != '') {
      // el usuario cargo un nueva imagen externa
      return AspectRatio(
        child: Image.file(File(getXFileImage.path), fit: BoxFit.cover),
        aspectRatio: 1 / 1,
      );
    } else {
      // se visualiza la imagen del producto
      return AspectRatio(
        aspectRatio: 1 / 1,
        child: CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: getProduct.image,
          placeholder: (context, url) => Container(
            color: Colors.grey.withOpacity(0.3),
            child: Center(child: Icon(Icons.cloud, color: Colors.white)),
          ),
          imageBuilder: (context, image) => Container(
            child: Image(image: image),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.withOpacity(0.3),
            child: Center(
              child: Icon(Icons.error, color: Colors.white),
            ),
          ),
        ),
      );
    }
  }

  void showDialogDelete() {
    Widget widget = AlertDialog(
      title: new Text(
          "¿Seguro que quieres eliminar este producto de tu catálogo?"),
      content: new Text(
          "El producto será eliminado de tu catálogo y toda la información acumulada"),
      actions: <Widget>[
        // usually buttons at the bottom of the dialog
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Get.back();
          },
        ),
        TextButton(
          child: const Text('Si, eliminar'),
          onPressed: () {
            Database.refFirestoreCatalogueProduct(
                    idAccount: welcomeController.getProfileAccountSelected.id)
                .doc(getProduct.id)
                .delete()
                .whenComplete(() {
                  Get.back();
                  back();
                  back();
                })
                .onError((error, stackTrace) => Get.back())
                .catchError((ex) => Get.back());
          },
        ),
      ],
    );

    Get.dialog(widget);
  }

  showModalSelectMarca() {
    Widget widget = SelectMark();
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
