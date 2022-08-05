import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id = "";
  String idAccount = ''; // ID del negocios que actualizo el producto
  bool verified = false; // estado de verificación  al un moderador
  bool outstanding = false; // producto destacado
  String idMark = ""; // ID de la marca por defecto esta vacia
  String nameMark = '';
  String image = ""; // URL imagen
  String description = ""; // Informacion
  String code = "";
  Timestamp creation =Timestamp.now(); // Marca de tiempo ( hora en que se creo el producto )
  Timestamp upgrade =Timestamp.now(); // Marca de tiempo ( hora en que se edito el producto )

  Product({
    this.id = "",
    this.idAccount = '',
    this.verified = false,
    this.outstanding = false,
    this.idMark = "",
    this.nameMark = '',
    this.image = "",
    this.description = "",
    this.code = "",
    required this.upgrade,
    required this.creation,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        'idAccount': idAccount,
        "verified": verified,
        "outstanding": outstanding,
        "idMark": idMark,
        'nameMark': nameMark,
        "image": image,
        "description": description,
        "code": code,
        "creation": creation,
        "upgrade": upgrade,
      };

  factory Product.fromMap(Map data) {
    return Product(
      id: data['id'] ?? '',
      idAccount: data.containsKey('idAccount')? data['idAccount']: data['id_negocio'] ?? '',
      verified: data.containsKey('verified')? data['verified']: data['verificado'] ?? false,
      outstanding: data['outstanding'] ?? false,
      idMark:data.containsKey('idMark') ? data['idMark'] : data['id_marca'] ?? '',
      nameMark: data['nameMark'] ?? '',
      image:data.containsKey('image') ? data['image'] : data['urlimagen'] ?? '',
      description: data.containsKey('description')? data['description']: data['descripcion'] ?? '',
      code: data.containsKey('code') ? data['code'] : data['codigo'] ?? '',
      upgrade: data.containsKey('upgrade')? data['upgrade']: data['timestamp_actualizacion'] ?? Timestamp.now(),
      creation: data.containsKey('creation')? data['creation']: data['timestamp_creation'] ?? Timestamp.now(),
    );
  }
  Product.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    // convert
    Map data = documentSnapshot.data() as Map;
    // set
    id = data['id'] ?? '';
    idAccount = data.containsKey('idAccount')? data['idAccount']: data['id_negocio'] ?? '';
    verified = data.containsKey('verified')? data['verified']: data['verificado'] ?? false;
    outstanding = data['outstanding'] ?? false;
    idMark =data.containsKey('idMark') ? data['idMark'] : data['id_marca'] ?? '';
    nameMark = data['nameMark'] ?? '';
    image = data.containsKey('image') ? data['image'] : data['urlimagen'] ?? '';
    description = data.containsKey('description')? data['description']: data['descripcion'] ?? '';
    code = data.containsKey('code') ? data['code'] : data['codigo'] ?? '';
    upgrade = data.containsKey('upgrade')? data['upgrade']: data['timestamp_actualizacion'] ?? Timestamp.now();
    creation = data.containsKey('creation')? data['creation']: data['timestamp_creation'] ?? Timestamp.now();
  }
  ProductCatalogue convertProductCatalogue() {
    //  create value
    ProductCatalogue productCatalogue =   ProductCatalogue(upgrade: Timestamp.now(), creation: Timestamp.now(),documentCreation: Timestamp.now(),documentUpgrade: Timestamp.now());
    //  set
    productCatalogue.id = id;
    productCatalogue.image = image;
    productCatalogue.verified = verified;
    productCatalogue.outstanding = outstanding;
    productCatalogue.idMark = idMark;
    productCatalogue.nameMark = nameMark;
    productCatalogue.description = description;
    productCatalogue.code = code;
    productCatalogue.upgrade = upgrade;
    productCatalogue.creation = creation;

    return productCatalogue;
  }
}

class ProductCatalogue {
  // valores del producto
  String id = "";
  bool outstanding = false; // producto destacado
  bool favorite = false;
  String idMark = ""; // ID de la marca por defecto esta vacia
  String nameMark = ''; // nombre de la marca
  String image = ""; // URL imagen
  String description = ""; // Información
  String code = "";
  String category = ""; // ID de la categoria del producto
  String nameCategory = ""; // name category
  String subcategory = ""; // ID de la subcategoria del producto
  String nameSubcategory = ""; // name subcategory
  Timestamp creation =Timestamp.now(); // Marca de tiempo ( hora en que se creo el documento  )
  Timestamp upgrade = Timestamp.now(); // Marca de tiempo ( hora en que se actualizo el documento )
  Timestamp documentCreation =Timestamp.now(); // Marca de tiempo ( hora en que se creo el producto publico )
  Timestamp documentUpgrade =Timestamp.now();// Marca de tiempo ( hora en que se actualizo el producto publico )
  bool verified = false; // estado de verificación por un moderador
  int quantityStock = 0;
  int sales = 0;
  bool stock = false;
  int alertStock = 5;
  double salePrice = 0.0;
  double purchasePrice = 0.0;
  String currencySign = "\$"; // signo de la moneda
  // var optional
  bool select = false;
  int quantity = 0;

  ProductCatalogue({
    // Valores del producto
    this.id = "",
    this.verified = false,
    this.favorite = false,
    this.outstanding = false,
    this.image = "",
    this.description = "",
    this.code = "",
    this.category = "",
    this.nameCategory = '',
    this.subcategory = "",
    this.nameSubcategory = '',
    this.stock = false,
    this.quantityStock = 0,
    this.alertStock = 5,
    required this.creation,
    required this.upgrade,
    required this.documentCreation,
    required this.documentUpgrade,

    // value account
    this.sales = 0,
    this.salePrice = 0.0,
    this.purchasePrice = 0.0,
    this.currencySign = "\$",
    this.idMark = '',
    this.nameMark = '',
    this.select = false,
    // var app
    this.quantity = 1,
  });

  factory ProductCatalogue.fromMap(Map data) {
    return ProductCatalogue(
      // Valores del producto
      id: data['id'] ?? '',
      verified: data.containsKey('verified')? data['verified']: data['verificado'] ?? false,
      outstanding:  data['outstanding'] ?? false,
      favorite: data.containsKey('favorite')? data['favorite']: data['favorito'] ?? false,
      idMark:data.containsKey('idMark') ? data['idMark'] : data['id_marca'] ?? '',
      nameMark: data['nameMark'] ?? '',
      image: data.containsKey('image')? data['image']: data['urlimagen'] ?? 'https://default',
      description: data.containsKey('description')
          ? data['description']
          : data['descripcion'] ?? '',
      code: data.containsKey('code') ? data['code'] : data['codigo'] ?? '',
      category: data.containsKey('category')
          ? data['category']
          : data['categoria'] ?? '',
      nameCategory: data.containsKey('nameCategory')
          ? data['nameCategory']
          : data['categoriaName'] ?? '',
      subcategory: data.containsKey('subcategory')
          ? data['subcategory']
          : data['subcategoria'] ?? '',
      nameSubcategory: data.containsKey('nameSubcategory')
          ? data['nameSubcategory']
          : data['subcategoriaName'] ?? '',
      upgrade: data.containsKey('upgrade')? data['upgrade']: data['timestamp_actualizacion'] ?? Timestamp.now(),
      creation: data.containsKey('creation')? data['creation']: data['timestamp_creation'] ?? Timestamp.now(),
      documentCreation: data['documentCreation'] ?? Timestamp.now(),
      documentUpgrade:  data['documentUpgrade'] ?? Timestamp.now(),
      // valores de la cuenta
      salePrice: data.containsKey('salePrice')
          ? data['salePrice']
          : data['precio_venta'] ?? 0.0,
      purchasePrice: data.containsKey('purchasePrice')
          ? data['purchasePrice']
          : data['precio_compra'] ?? 0.0,
      currencySign: data.containsKey('currencySign')
          ? data['currencySign']
          : data['signo_moneda'] ?? '',
      quantity: data['quantity'] ?? 1,
      quantityStock: data['quantityStock'] ?? 0,
      sales: data['sales'] ?? 0,
      select: false,
      stock: data['stock'] ?? false,
      alertStock: data['alertStock'] ?? 5,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        'outstanding':outstanding,
        "verified": verified,
        "favorite": favorite,
        "idMark": idMark,
        "nameMark": nameMark,
        "image": image,
        "description": description,
        "code": code,
        "category": category,
        "nameCategory": nameCategory,
        "subcategory": subcategory,
        "nameSubcategory": nameSubcategory,
        "salePrice": salePrice,
        "purchasePrice": purchasePrice,
        "creation": creation,
        "upgrade": upgrade,
        "documentCreation": documentCreation,
        "documentUpgrade": documentUpgrade,
        "currencySign": currencySign,
        "quantity": quantity,
        "stock": stock,
        "quantityStock": quantityStock,
        "sales": sales,
        "alertStock": alertStock,
      };

  Product convertProductoDefault() {
    // convertimos en el modelo para producto global
    Product productoDefault = Product(upgrade: Timestamp.now(), creation: Timestamp.now());
    productoDefault.id = id;
    productoDefault.image = image;
    productoDefault.verified = verified;
    productoDefault.outstanding = outstanding;
    productoDefault.idMark =  idMark;
    productoDefault.nameMark =  nameMark;
    productoDefault.description =  description;
    productoDefault.code = code;
    return productoDefault;
  }

  ProductCatalogue updateData({required Product product}) {
    // actualizamos los datos del documento publico
    id = product.id;
    image = product.image;
    verified = product.verified;
    outstanding = product.outstanding;
    idMark = product.idMark;
    nameMark = product.nameMark;
    description = product.description;
    code = product.code;
    documentCreation = product.creation;
    documentUpgrade = product.upgrade;
    return this;
  }
}

class Price {
  String id = '';
  double price = 0.0;
  late Timestamp time; // marca de tiempo en la que se registro el precio
  String currencySign = ""; // signo de la moneda
  String province = ""; // provincia
  String town = ""; // ciudad o pueblo
  // data account
  String idAccount = "";
  String imageAccount = ''; // imagen de perfil de la cuenta
  String nameAccount = ''; // nombre de la cuenta

  Price({
    required this.id,
    required this.idAccount,
    required this.imageAccount,
    required this.nameAccount,
    required this.price,
    required this.time,
    required this.currencySign,
    this.province = '',
    this.town = '',
  });

  Price.fromMap(Map data) {
    id = data['id'] ?? '';
    idAccount = data['idAccount'] ?? '';
    imageAccount = data.containsKey('imageAccount')
        ? data['imageAccount']
        : data['urlImageAccount'] ?? '';
    nameAccount = data['nameAccount'] ?? '';
    price = data.containsKey('price') ? data['price'] : data['precio'] ?? 0.0;
    time = data.containsKey('time') ? data['time'] : data['timestamp'];
    currencySign = data.containsKey('currencySign')
        ? data['currencySign']
        : data['moneda'] ?? '';
    province = data.containsKey('province')
        ? data['province']
        : data['provincia'] ?? '';
    town = data.containsKey('town') ? data['town'] : data['ciudad'] ?? '';
  }
  Map<String, dynamic> toJson() => {
        'id': id,
        "idAccount": idAccount,
        "imageAccount": imageAccount,
        "nameAccount": nameAccount,
        "price": price,
        "time": time,
        "currencySign": currencySign,
        "province": province,
        "town": town,
      };
}

class Category {
  String id = "";
  String name = "";
  Map<String, dynamic> subcategories = Map<String, dynamic>();

  Category({
    this.id = "",
    this.name = "",
    this.subcategories = const {},
  });
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "subcategories": subcategories,
      };
  factory Category.fromMap(Map<String, dynamic> data) {
    return Category(
      id: data['id'] ?? '',
      name: data.containsKey('name') ? data['name'] : data['nombre'] ?? '',
      subcategories: data.containsKey('subcategories')
          ? data['subcategories']
          : data['subcategorias'] ?? new Map<String, dynamic>(),
    );
  }
  Category.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    Map data = documentSnapshot.data() as Map;

    id = data['id'] ?? '';
    name = data.containsKey('name') ? data['name'] : data['nombre'] ?? '';
    subcategories = data.containsKey('subcategories')
        ? data['subcategories']
        : data['subcategorias'] ?? new Map<String, dynamic>();
  }
}

class Mark {
  String id = "";
  String name = "";
  String description = "";
  String image = "";
  bool verified = false;
  // Datos de la creación
  String idUsuarioCreador = ""; // ID el usuaruio que creo el productos
  Timestamp creation =
      Timestamp.now(); // Marca de tiempo de la creacion del documento
  Timestamp upgrade =
      Timestamp.now(); // Marca de tiempo de la ultima actualizacion

  Mark({
    this.id = "",
    this.name = "",
    this.description = "",
    this.image = "",
    this.verified = false,
    required this.upgrade,
    required this.creation,
  });
  Mark.fromMap(Map data) {
    id = data['id'] ?? '';
    name = data.containsKey('name') ? data['name'] : data['titulo'] ?? '';
    description = data.containsKey('description')
        ? data['description']
        : data['descripcion'] ?? '';
    image =
        data.containsKey('image') ? data['image'] : data['url_imagen'] ?? '';
    verified = data.containsKey('verified')
        ? data['verified']
        : data['verificado'] ?? false;
    creation = data.containsKey('creation')
        ? data['creation']
        : data['timestampCreacion'] ?? Timestamp.now();
    upgrade = data.containsKey('upgrade')
        ? data['upgrade']
        : data['timestampUpdate'] ?? Timestamp.now();
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "image": image,
        "verified": verified,
        "creation": creation,
        "upgrade": upgrade,
      };
}

class ReportProduct {
  String id = ''; // idUser=idUserReport
  String idProduct = '';
  String idUserReport = '';
  String description = '';
  late Timestamp time; // Marca de tiempo ( hora en que se reporto el producto )

  ReportProduct({
    this.id = "",
    this.idProduct = "",
    this.idUserReport = "",
    this.description = "",
    required this.time,
  });
  Map<String, dynamic> toJson() => {
        "id": id,
        "idProduct": idProduct,
        "idUserReport": idUserReport,
        "description": description,
        "time": time,
      };
  factory ReportProduct.fromMap(Map<String, dynamic> data) {
    return ReportProduct(
      id: data['id'] ?? '',
      idProduct: data['name'] ?? '',
      idUserReport: data['idUserReport'] ?? '',
      description: data['description'] ?? '',
      time: data['time'],
    );
  }
  ReportProduct.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    Map data = documentSnapshot.data() as Map;

    id = data['id'] ?? '';
    idProduct = data['name'] ?? '';
    idUserReport = data['idUserReport'] ?? '';
    description = data['description'] ?? '';
    time = data['time'];
  }
}
