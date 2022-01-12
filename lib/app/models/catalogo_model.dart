import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id = "";
  String idAccount = ''; // ID del negocios que actualizo el producto
  bool verified = false; // estado de verificación  al un moderador
  bool favorite = false;
  String idMark = ""; // ID de la marca por defecto esta vacia
  String nameMark = '';
  String image = "https://default"; // URL imagen
  String description = ""; // Informacion
  double salePrice = 0.0;
  double purchasePrice = 0.0;
  String code = "";
  String category = ""; // ID de la categoria del producto
  String subcategory = ""; // ID de la subcategoria del producto
  bool enabled = true;
  Timestamp creation =
      Timestamp.now(); // Marca de tiempo ( hora en que se creo el producto )
  Timestamp upgrade =
      Timestamp.now(); // Marca de tiempo ( hora en que se edito el producto )

  Product({
    this.id = "",
    this.idAccount = '',
    this.verified = false,
    this.favorite = false,
    this.idMark = "",
    this.nameMark = '',
    this.image = "",
    this.description = "",
    this.salePrice = 0.0,
    this.purchasePrice = 0.0,
    this.code = "",
    this.category = "",
    this.subcategory = "",
    this.enabled = true,
    required this.upgrade,
    required this.creation,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        'idAccount': idAccount,
        "verified": verified,
        "favorite": favorite,
        "idMark": idMark,
        'nameMark': nameMark,
        "image": image,
        "description": description,
        "salePrice": salePrice,
        "purchasePrice": purchasePrice,
        "code": code,
        "category": category,
        "subcategory": subcategory,
        "creation": creation,
        "upgrade": upgrade,
        "enabled": enabled,
      };

  factory Product.fromMap(Map data) {
    return Product(
      id: data['id'] ?? '',
      idAccount: data.containsKey('idAccount')
          ? data['idAccount']
          : data['id_negocio'] ?? '',
      verified: data.containsKey('verified')
          ? data['verified']
          : data['verificado'] ?? false,
      favorite: data['favorite'] ?? false,
      idMark:
          data.containsKey('idMark') ? data['idMark'] : data['id_marca'] ?? '',
      nameMark: data['nameMark'] ?? '',
      image:
          data.containsKey('image') ? data['image'] : data['urlimagen'] ?? '',
      description: data.containsKey('description')
          ? data['description']
          : data['descripcion'] ?? '',
      salePrice: data.containsKey('salePrice')
          ? data['salePrice']
          : data['precio_venta'] ?? 0.0,
      purchasePrice: data.containsKey('purchasePrice')
          ? data['purchasePrice']
          : data['precio_compra'] ?? 0.0,
      code: data.containsKey('code') ? data['code'] : data['codigo'] ?? '',
      category: data.containsKey('category')
          ? data['category']
          : data['categoria'] ?? '',
      subcategory: data.containsKey('subcategory')
          ? data['subcategory']
          : data['subcategoria'] ?? '',
      upgrade: data.containsKey('upgrade')
          ? data['upgrade']
          : data['timestamp_actualizacion'] ?? Timestamp.now(),
      creation: data.containsKey('creation')
          ? data['creation']
          : data['timestamp_creation'] ?? Timestamp.now(),
      enabled: data['enabled'] ?? true,
    );
  }
  Product.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    // convert
    Map data = documentSnapshot.data() as Map;
    // set
    id = data['id'] ?? '';
    idAccount = data.containsKey('idAccount')
        ? data['idAccount']
        : data['id_negocio'] ?? '';
    verified = data.containsKey('verified')
        ? data['verified']
        : data['verificado'] ?? false;
    favorite = data['favorite'] ?? false;
    idMark =
        data.containsKey('idMark') ? data['idMark'] : data['id_marca'] ?? '';
    nameMark = data['nameMark'] ?? '';
    image = data.containsKey('image') ? data['image'] : data['urlimagen'] ?? '';
    description = data.containsKey('description')
        ? data['description']
        : data['descripcion'] ?? '';
    salePrice = data.containsKey('salePrice')
        ? data['salePrice']
        : data['precio_venta'] ?? 0.0;
    purchasePrice = data.containsKey('purchasePrice')
        ? data['purchasePrice']
        : data['precio_compra'] ?? 0.0;
    code = data.containsKey('code') ? data['code'] : data['codigo'] ?? '';
    category = data.containsKey('category')
        ? data['category']
        : data['categoria'] ?? '';
    subcategory = data.containsKey('subcategory')
        ? data['subcategory']
        : data['subcategoria'] ?? '';
    upgrade = data.containsKey('upgrade')
        ? data['upgrade']
        : data['timestamp_actualizacion'] ?? Timestamp.now();
    creation = data.containsKey('creation')
        ? data['creation']
        : data['timestamp_creation'] ?? Timestamp.now();
    enabled = data['enabled'] ?? true;
  }
  ProductCatalogue convertProductCatalogue() {
    ProductCatalogue productoNegocio = new ProductCatalogue(
        upgrade: Timestamp.now(), creation: Timestamp.now());
    productoNegocio.id = this.id;
    productoNegocio.image = this.image;
    productoNegocio.verified = this.verified;
    productoNegocio.favorite = this.favorite;
    productoNegocio.idMark = this.idMark;
    productoNegocio.nameMark = this.nameMark;
    productoNegocio.description = this.description;
    productoNegocio.code = this.code;
    productoNegocio.category = this.category;
    productoNegocio.subcategory = this.subcategory;
    productoNegocio.enabled = this.enabled;
    productoNegocio.salePrice = this.salePrice;
    productoNegocio.purchasePrice = this.purchasePrice;

    return productoNegocio;
  }
}

class ProductCatalogue {
  // valores del producto
  String id = "";
  bool favorite = false;
  String idMark = ""; // ID de la marca por defecto esta vacia
  String nameMark = ''; // nombre de la marca
  String image = "https://default"; // URL imagen
  String description = ""; // Información
  String code = "";
  String category = ""; // ID de la categoria del producto
  String nameCategory = ""; // name category
  String subcategory = ""; // ID de la subcategoria del producto
  String nameSubcategory = ""; // name subcategory
  Timestamp creation =
      Timestamp.now(); // Marca de tiempo ( hora en que se creo el documento )
  Timestamp upgrade =
      Timestamp.now(); // Marca de tiempo ( hora en que se actualizaron los datos )

  // Datos del producto
  bool enabled = true;
  bool verified = false; // estado de verificación por un moderador
  // Variables
  double salePrice = 0.0;
  double purchasePrice = 0.0;
  String currencySign= "\$"; // signo de la moneda

  ProductCatalogue({
    // Valores del producto
    this.id = "",
    this.verified = false,
    this.favorite = false,
    this.image = "",
    this.description = "",
    this.code = "",
    this.category = "",
    this.nameCategory = '',
    this.subcategory = "",
    this.nameSubcategory = '',
    required this.creation,
    required this.upgrade,
    this.enabled = true,

    // valores de la cuenta
    this.salePrice = 0.0,
    this.purchasePrice = 0.0,
    this.currencySign = "\$",
    this.idMark = '',
    this.nameMark = '',
  });

  factory ProductCatalogue.fromMap(Map data) {
    return ProductCatalogue(
      // Valores del producto
      id: data['id'] ?? '',
      verified: data.containsKey('verified')
          ? data['verified']
          : data['verificado'] ?? false,
      favorite: data.containsKey('favorite')
          ? data['favorite']
          : data['favorito'] ?? false,
      idMark:
          data.containsKey('idMark') ? data['idMark'] : data['id_marca'] ?? '',
      nameMark: data['nameMark'] ?? '',
      image: data.containsKey('image')
          ? data['image']
          : data['urlimagen'] ?? 'https://default',
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
      upgrade: data.containsKey('upgrade')
          ? data['upgrade']
          : data['timestamp_actualizacion'] ?? Timestamp.now(),
      creation: data.containsKey('creation')
          ? data['creation']
          : data['timestamp_creation'] ?? Timestamp.now(),
      enabled: data['enabled'] ?? true,
      // valores de la cuenta
      salePrice: data.containsKey('salePrice')
          ? data['salePrice']
          : data['precio_venta'] ?? 0.0,
      purchasePrice: data.containsKey('purchasePrice')
          ? data['purchasePrice']
          : data['precio_compra'] ?? 0.0,
      currencySign:
          data.containsKey('currencySign') ? data['currencySign'] : data['signo_moneda'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "enabled": enabled,
        "salePrice": salePrice,
        "purchasePrice": purchasePrice,
        "creation": creation,
        "upgrade": upgrade,
        "currencySign": currencySign,
      };

  Product convertProductoDefault() {
    // convertimos en el modelo para producto global
    Product productoDefault = new Product(upgrade: Timestamp.now(), creation: Timestamp.now());
    productoDefault.id = this.id;
    productoDefault.image = this.image;
    productoDefault.verified = this.verified;
    productoDefault.favorite = this.favorite;
    productoDefault.idMark = this.idMark;
    productoDefault.nameMark = this.nameMark;
    productoDefault.description = this.description;
    productoDefault.code = this.code;
    productoDefault.upgrade = this.upgrade;
    productoDefault.creation = this.creation;
    productoDefault.enabled = this.enabled;

    return productoDefault;
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
    currencySign = data.containsKey('currencySign') ? data['currencySign'] : data['moneda'] ?? '';
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
    name =  data.containsKey('name') ? data['name'] : data['nombre'] ?? '';
    subcategories =data.containsKey('subcategories')
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
  Timestamp creation = Timestamp.now(); // Marca de tiempo de la creacion del documento
  Timestamp upgrade = Timestamp.now(); // Marca de tiempo de la ultima actualizacion

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
    description = data.containsKey('description') ? data['description'] : data['descripcion'] ?? '';
    image = data.containsKey('image') ? data['image'] : data['url_imagen'] ?? '';
    verified = data.containsKey('verified') ? data['verified'] : data['verificado'] ?? false;
    creation = data.containsKey('creation') ? data['creation'] :data['timestampCreacion'] ?? Timestamp.now();
    upgrade = data.containsKey('upgrade') ? data['upgrade'] :data['timestampUpdate'] ?? Timestamp.now();
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
