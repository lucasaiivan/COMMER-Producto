import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  String id = "";
  String idAccount = '';
  bool verificado = false; // estado de verificación  al un moderador
  bool favorite = false;
  String idMarca = ""; // ID de la marca por defecto esta vacia
  String idNegocio = ""; // ID del negocios que actualizo el producto
  String urlImagen = "https://default"; // URL imagen
  String titulo = ""; // Titulo
  String descripcion = ""; // Informacion
  double precioVenta = 0.0;
  double precioCompra = 0.0;
  String codigo = "";
  String categoria = ""; // ID de la categoria del producto
  String subcategoria = ""; // ID de la subcategoria del producto
  bool enabled = true;
  Timestamp timestampCreation =
      Timestamp.now(); // Marca de tiempo ( hora en que se creo el producto )
  Timestamp timestampActualizacion =
      Timestamp.now(); // Marca de tiempo ( hora en que se edito el producto )

  Producto({
    this.id = "",
    this.idAccount='',
    this.verificado = false,
    this.favorite = false,
    this.idMarca = "",
    this.idNegocio = "",
    this.urlImagen = "",
    this.titulo = "",
    this.descripcion = "",
    this.precioVenta = 0.0,
    this.precioCompra = 0.0,
    this.codigo = "",
    this.categoria = "",
    this.subcategoria = "",
    this.enabled = true,
    timestampActualizacion,
    timestampCreation,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        'idAccount':idAccount,
        "verificado": verificado,
        "favorite": verificado,
        "id_marca": idMarca,
        "id_negocio": idNegocio,
        "urlimagen": urlImagen,
        "titulo": titulo,
        "descripcion": descripcion,
        "precio_venta": precioVenta,
        "precio_compra": precioCompra,
        "codigo": codigo,
        "categoria": categoria,
        "subcategoria": subcategoria,
        "timestamp_creation": timestampCreation,
        "timestamp_actualizacion": timestampActualizacion,
        "enabled": enabled,
      };

  factory Producto.fromMap(Map data) {
    return Producto(
      id: data['id'] ?? '',
      idAccount:data['idAccount']??'',
      verificado: data['verificado'] ?? false,
      favorite: data['favorite'] ?? false,
      idMarca: data['id_marca'] ?? '',
      idNegocio: data['id_negocio'] ?? '',
      urlImagen: data['urlimagen'] ?? 'https://default',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      precioVenta: data['precio_venta'] ?? 0.0,
      precioCompra: data['precio_compra'] ?? 0.0,
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      timestampActualizacion: data['timestamp_actualizacion'],
      timestampCreation: data['timestamp_creation'],
      enabled: data['enabled'] ?? true,
    );
  }
  Producto.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot['id'] ?? '';
    idAccount = documentSnapshot['idAccount'] ?? '';
    verificado = documentSnapshot['verificado'] ?? false;
    favorite = documentSnapshot['favorite'] ?? false;
    idMarca = documentSnapshot['id_marca'] ?? '';
    idNegocio = documentSnapshot['id_negocio'] ?? '';
    urlImagen = documentSnapshot['urlimagen'] ?? 'https://default';
    titulo = documentSnapshot['titulo'] ?? '';
    descripcion = documentSnapshot['descripcion'] ?? '';
    precioVenta = documentSnapshot['precio_venta'] ?? 0.0;
    precioCompra = documentSnapshot['precio_compra'] ?? 0.0;
    codigo = documentSnapshot['codigo'] ?? '';
    categoria = documentSnapshot['categoria'] ?? '';
    subcategoria = documentSnapshot['subcategoria'] ?? '';
    timestampActualizacion = documentSnapshot['timestamp_actualizacion'];
    timestampCreation = documentSnapshot['timestamp_creation'];
    enabled = documentSnapshot['enabled'] ?? true;
  }
  ProductoNegocio convertProductCatalogue() {
    ProductoNegocio productoNegocio = new ProductoNegocio();
    productoNegocio.id = this.id;
    productoNegocio.urlimagen = this.urlImagen;
    productoNegocio.verificado = this.verificado;
    productoNegocio.favorite = this.favorite;
    productoNegocio.idMarca = this.idMarca;
    productoNegocio.titulo = this.titulo;
    productoNegocio.descripcion = this.descripcion;
    productoNegocio.codigo = this.codigo;
    productoNegocio.categoria = this.categoria;
    productoNegocio.subcategoria = this.subcategoria;
    productoNegocio.enabled = this.enabled;

    return productoNegocio;
  }
}

class ProductoNegocio {
  // valores del producto
  String id = "";
  bool favorite = false;
  String idMarca = ""; // ID de la marca por defecto esta vacia
  String nameMark = ''; // nombre de la marca
  String urlimagen = "https://default"; // URL imagen
  String titulo = ""; // Titulo
  String descripcion = ""; // Información
  String codigo = "";
  String categoria = ""; // ID de la categoria del producto
  String categoriaName = ""; // name category
  String subcategoria = ""; // ID de la subcategoria del producto
  String subcategoriaName = ""; // name subcategory
  Timestamp timestampCreation =
      Timestamp.now(); // Marca de tiempo ( hora en que se creo el producto )
  Timestamp timestampActualizacion =
      Timestamp.now(); // Marca de tiempo ( hora en que se edito el producto )

  // Datos del producto
  bool enabled = true;
  bool verificado = false; // estado de verificación por un moderador
  // Variables
  double precioVenta = 0.0;
  double precioCompra = 0.0;
  String signoMoneda;

  ProductoNegocio({
    // Valores del producto
    this.id = "",
    this.verificado = false,
    this.favorite = false,
    this.urlimagen = "",
    this.titulo = "",
    this.descripcion = "",
    this.codigo = "",
    this.categoria = "",
    this.categoriaName = '',
    this.subcategoria = "",
    this.subcategoriaName = '',
    timestampCreation,
    timestampActualizacion,
    this.enabled = true,

    // valores de la cuenta
    this.precioVenta = 0.0,
    this.precioCompra = 0.0,
    this.signoMoneda = "",
    this.idMarca = '',
    this.nameMark = '',
  });

  factory ProductoNegocio.fromMap(Map data) {
    return ProductoNegocio(
      // Valores del producto
      id: data['id'] ?? '',
      verificado: data['verificado'] ?? false,
      favorite: data['favorite'] ?? false,
      idMarca: data['id_marca'] ?? '',
      nameMark: data['nameMark'] ?? '',
      urlimagen: data['urlimagen'] ?? 'https://default',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      categoriaName: data['categoriaName'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      subcategoriaName: data['subcategoriaName'] ?? '',
      timestampActualizacion:
          data['timestamp_actualizacion'] ?? Timestamp.now(),
      timestampCreation: data['timestamp_creation'] ?? Timestamp.now(),
      enabled: data['enabled'] ?? true,
      // valores de la cuenta
      precioVenta: data['precio_venta'] ?? 0.0,
      precioCompra: data['precio_compra'] ?? 0.0,
      signoMoneda: data['signo_moneda'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "verificado": verificado,
        "favorite": verificado,
        "id_marca": idMarca,
        "nameMark": nameMark,
        "urlimagen": urlimagen,
        "titulo": titulo,
        "descripcion": descripcion,
        "codigo": codigo,
        "categoria": categoria,
        "categoriaName": categoriaName,
        "subcategoria": subcategoria,
        "subcategoriaName": subcategoriaName,
        "enabled": enabled,
        "precio_venta": precioVenta,
        "precio_compra": precioCompra,
        "timestamp_creation": timestampCreation,
        "timestamp_actualizacion": timestampActualizacion,
        "signo_moneda": signoMoneda,
      };

  Producto convertProductoDefault() {
    // convertimos en el modelo para producto global
    Producto productoDefault = new Producto();
    productoDefault.id = this.id;
    productoDefault.urlImagen = this.urlimagen;
    productoDefault.verificado = this.verificado;
    productoDefault.favorite = this.favorite;
    productoDefault.idMarca = this.idMarca;
    productoDefault.titulo = this.titulo;
    productoDefault.descripcion = this.descripcion;
    productoDefault.codigo = this.codigo;
    productoDefault.timestampActualizacion = this.timestampActualizacion;
    productoDefault.timestampCreation = this.timestampCreation;
    productoDefault.enabled = this.enabled;

    return productoDefault;
  }
}

DateTime date = Timestamp.now() as DateTime;

class Precio {
  String idNegocio = "";
  double precio = 0.0;
  late Timestamp timestamp;
  String moneda = "";
  String provincia = "";
  String ciudad = "";

  Precio({
    required this.idNegocio,
    required this.precio,
    required this.timestamp,
    required this.moneda,
    this.provincia = '',
    this.ciudad = '',
  });

  Precio.fromMap(Map data) {
    idNegocio = data['id_negocio'] ?? '';
    precio = data['precio'] ?? 0.0;
    timestamp = data['timestamp'];
    moneda = data['moneda'] ?? '';
    provincia = data['provincia'] ?? '';
    ciudad = data['ciudad'] ?? '';
  }
  Map<String, dynamic> toJson() => {
        "id_negocio": idNegocio,
        "precio": precio,
        "timestamp": timestamp,
        "moneda": moneda,
        "provincia": provincia,
        "ciudad": ciudad,
      };
}

class Categoria {
  String id = "";
  String nombre = "";
  Map<String, dynamic> subcategorias = Map<String, dynamic>();

  Categoria({
    this.id = "",
    this.nombre = "",
    this.subcategorias = const {},
  });
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "subcategorias": subcategorias,
      };
  factory Categoria.fromMap(Map<String, dynamic> data) {
    return Categoria(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      subcategorias: data['subcategorias'] ?? new Map<String, dynamic>(),
    );
  }
  Categoria.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot['id'] ?? '';
    nombre = documentSnapshot['nombre'] ?? '';
    subcategorias =
        documentSnapshot['subcategorias'] ?? new Map<String, dynamic>();
  }
}

class Marca {
  String id = "";
  String name = "";
  String description = "";
  String urlImage = "";
  bool verified = false;

  // Datos de la creación
  String idUsuarioCreador = ""; // ID el usuaruio que creo el productos
  late Timestamp
      timestampCreacion; // Marca de tiempo de la creacion del documento
  late Timestamp
      timestampUpdate; // Marca de tiempo de la ultima actualizacion

  Marca({
    this.id = "",
    this.name = "",
    this.description = "",
    this.urlImage = "",
    this.verified = false,
    required this.timestampUpdate,
    required this.timestampCreacion,
  });
  Marca.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot['id'] ?? '';
    name = documentSnapshot['name'] ?? documentSnapshot['titulo']??'';
    description = documentSnapshot['description'] ?? documentSnapshot['descripcion']??'';
    urlImage = documentSnapshot['urlImage'] ?? documentSnapshot['url_imagen'] ?? '';
    verified = documentSnapshot['verified']??documentSnapshot['verificado']??false;
    timestampCreacion = documentSnapshot['timestampCreacion']??Timestamp.now();
    timestampUpdate = documentSnapshot['timestampUpdate']??Timestamp.now();
  }
  Marca.fromMap(Map data) {
    id = data['id'] ?? '';
    name = data['name'] ?? '';
    description = data['description'] ?? (data['descripcion']??'');
    urlImage = data['urlImage'] ?? (data['url_imagen'] ?? '');
    verified = data['verified'] ?? (data['verificado'] ?? false);
    timestampCreacion = data['timestampCreacion']??Timestamp.now();
    timestampUpdate = data['timestampUpdate']??Timestamp.now();
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "urlImage": urlImage,
        "verified": verified,
        "timestampCreacion": timestampCreacion,
        "timestampUpdate": timestampUpdate,
      };
}
