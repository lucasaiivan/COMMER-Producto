import 'package:cloud_firestore/cloud_firestore.dart';

class Producto {
  String id = "";
  bool verificado = false; // estado de verificación  al un moderador
  bool favorite = false;
  String idMarca = ""; // ID de la marca por defecto esta vacia
  String idNegocio = ""; // ID del negocios que actualizo el producto
  String urlImagen = "https://default"; // URL imagen
  String titulo = ""; // Titulo
  String descripcion = ""; // Informacion
  double precioVenta = 0.0;
  double precioCompra = 0.0;
  double precioComparacion = 0.0;
  String codigo = "";
  String categoria = ""; // ID de la categoria del producto
  String subcategoria = ""; // ID de la subcategoria del producto
  late Timestamp
      timestampCreation; // Marca de tiempo ( hora en que se creo el producto )
  late Timestamp
      timestampActualizacion; // Marca de tiempo ( hora en que se edito el producto )

  Producto({
    this.id = "",
    this.verificado = false,
    this.favorite = false,
    this.idMarca = "",
    this.idNegocio = "",
    this.urlImagen = "",
    this.titulo = "",
    this.descripcion = "",
    this.precioVenta = 0.0,
    this.precioCompra = 0.0,
    this.precioComparacion = 0.0,
    this.codigo = "",
    this.categoria = "",
    this.subcategoria = "",
    timestampActualizacion,
    timestampCreation,
    //this.timestampCreation,
    //this.timestamp_actualizacion,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "verificado": verificado,
        "favorite": verificado,
        "id_marca": idMarca,
        "id_negocio": idNegocio,
        "urlimagen": urlImagen,
        "titulo": titulo,
        "descripcion": descripcion,
        "precio_venta": precioVenta,
        "precio_compra": precioCompra,
        "precio_comparacion": precioComparacion,
        "codigo": codigo,
        "categoria": categoria,
        "subcategoria": subcategoria,
        "timestamp_creation": timestampCreation,
        "timestamp_actualizacion": timestampActualizacion,
      };

  factory Producto.fromMap(Map data) {
    return Producto(
      id: data['id'] ?? '',
      verificado: data['verificado'] ?? false,
      favorite: data['favorite'] ?? false,
      idMarca: data['id_marca'] ?? '',
      idNegocio: data['id_negocio'] ?? '',
      urlImagen: data['urlimagen'] ?? 'https://default',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      precioVenta: data['precio_venta'] ?? 0.0,
      precioCompra: data['precio_compra'] ?? 0.0,
      precioComparacion: data['precio_comparacion'] ?? 0.0,
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      timestampActualizacion: data['timestamp_actualizacion'],
      timestampCreation: data['timestamp_creation'],
    );
  }
  ProductoNegocio convertProductCatalogue() {
    ProductoNegocio productoNegocio = new ProductoNegocio();
    productoNegocio.id = this.id;
    productoNegocio.urlimagen = this.urlImagen;
    productoNegocio.idNegocio = this.idNegocio;
    productoNegocio.verificado = this.verificado;
    productoNegocio.favorite = this.favorite;
    productoNegocio.idMarca = this.idMarca;
    productoNegocio.titulo = this.titulo;
    productoNegocio.descripcion = this.descripcion;
    productoNegocio.codigo = this.codigo;
    productoNegocio.categoria = this.categoria;
    productoNegocio.subcategoria = this.subcategoria;
    //productoNegocio.timestampActualizacion=this.timestampActualizacion;
    //productoNegocio.timestampCreation=this.timestampCreation;

    return productoNegocio;
  }
}

class ProductoNegocio {
  // valores del producto
  String id = "";
  bool favorite = false;
  String idMarca = ""; // ID de la marca por defecto esta vacia
  String urlimagen = "https://default"; // URL imagen
  String titulo = ""; // Titulo
  String descripcion = ""; // Información
  String codigo = "";
  String categoria = ""; // ID de la categoria del producto
  String subcategoria = ""; // ID de la subcategoria del producto
  late Timestamp
      timestampCreation; // Marca de tiempo ( hora en que se creo el producto )
  late Timestamp
      timestampActualizacion; // Marca de tiempo ( hora en que se edito el producto )

  // Datos de publicacion
  String idNegocio = ""; // ID del negocios
  String idUsuario = ""; // ID del usuario quien creo la publicacion

  // Datos del producto
  bool verificado = false; // estado de verificación por un moderador
  bool productoPrecargado = false;
  // Variables
  bool habilitado = true;
  double precioVenta = 0.0;
  double precioCompra = 0.0;
  double precioComparacion = 0.0;

  late Timestamp
      timestampCompra; // Marca de tiempo ( hora en que se compro el producto )
  String signoMoneda;
  //Map<String,bool> mg=new Map();    // <ID,(true=me gusta | false=no me gusta)>
  int cantidad = 1;

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
    this.subcategoria = "",
    timestampCreation,
    timestampActualizacion,

    // valores de la cuenta
    this.habilitado = false,
    this.precioVenta = 0.0,
    this.precioCompra = 0.0,
    this.precioComparacion = 0.0,
    this.productoPrecargado = false,
    timestampCompra,
    this.signoMoneda = "",
    this.idMarca = '',
  });

  factory ProductoNegocio.fromMap(Map data) {
    return ProductoNegocio(
      // Valores del producto
      id: data['id'] ?? '',
      verificado: data['verificado'] ?? false,
      favorite: data['favorite'] ?? false,
      idMarca: data['id_marca'] ?? '',
      urlimagen: data['urlimagen'] ?? 'https://default',
      titulo: data['titulo'] ?? '',
      descripcion: data['descripcion'] ?? '',
      codigo: data['codigo'] ?? '',
      categoria: data['categoria'] ?? '',
      subcategoria: data['subcategoria'] ?? '',
      timestampActualizacion: data['timestamp_actualizacion'],
      timestampCreation: data['timestamp_creation'],
      // valores de la cuenta
      productoPrecargado: data['producto_precargado'] ?? true,
      habilitado: data['habilitado'] ?? true,
      precioVenta: data['precio_venta'] ?? 0.0,
      precioCompra: data['precio_compra'] ?? 0.0,
      precioComparacion: data['precio_comparacion'] ?? 0.0,
      timestampCompra: data['timestamp_compra'] ?? null,
      signoMoneda: data['signo_moneda'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "verificado": verificado,
        "favorite": verificado,
        "id_marca": idMarca,
        "urlimagen": urlimagen,
        "titulo": titulo,
        "descripcion": descripcion,
        "codigo": codigo,
        "categoria": categoria,
        "subcategoria": subcategoria,
        "producto_precargado": productoPrecargado,
        "habilitado": habilitado,
        "precio_venta": precioVenta,
        "precio_compra": precioCompra,
        "precio_comparacion": precioComparacion,
        "timestamp_compra": timestampCompra,
        "timestamp_creation": timestampCreation,
        "timestamp_actualizacion": timestampActualizacion,
        "signo_moneda": signoMoneda,
        "cantidad": cantidad,
      };

  Producto convertProductoDefault() {
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

    return productoDefault;
  }
}

DateTime  date = Timestamp.now() as DateTime;

class Precio {
  String idNegocio = "";
  double precio = 0.0;
  late Timestamp timestamp;
  String moneda = "";
  String provincia = "";
  String ciudad = "";

  Precio({
    required this.idNegocio ,
    required this.precio ,
    required this.timestamp,
    required this.moneda,
    this.provincia='',
    this.ciudad='',
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
    String id="";
    String nombre="";
    Map<String, dynamic> subcategorias = Map<String, dynamic>();

  Categoria({
    this.id="", 
    this.nombre="",
    this.subcategorias= const {},
    });
  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "subcategorias": subcategorias,
  };
  factory Categoria.fromMap(Map data) {
    return Categoria(
      id: data['id'] ?? '',
      nombre: data['nombre'] ?? '',
      subcategorias: data['subcategorias'] ?? new Map<String, dynamic>(),
    );
  }
}

class Marca {
  String id = "";
  String titulo = "";
  String descripcion = "";
  String urlImagen = "";
  bool verificado=false;

  // Datos de la creación
  String idUsuarioCreador = ""; // ID el usuaruio que creo el productos
  late Timestamp timestampCreacion; // Marca de tiempo de la creacion del documento
  String idUsuarioActualizado = ""; // ID el usuaruio que actualizo el productos
  late Timestamp timestampActualizado; // Marca de tiempo de la ultima actualizacion
  
  Marca({
    this.id = "",
    this.titulo = "",
    this.descripcion = "",
    this.urlImagen = "",
    this.verificado=false,
    required this.timestampActualizado,
    required this.timestampCreacion,
  });
  Marca.fromDocumentSnapshot( {required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot['id'] ?? '';
    titulo = documentSnapshot['titulo'] ?? '';
    descripcion = documentSnapshot['descripcion'] ?? '';
    urlImagen = documentSnapshot['url_imagen'] ?? 'default';
    //verificado = documentSnapshot['verificado']??'' ;
    //idUsuarioCreador = documentSnapshot['id_usuario_creador'] ?? '';
    //idUsuarioActualizado = documentSnapshot['id_usuario_actualizado'] ?? '';
    //timestampCreacion = documentSnapshot['timestamp_creacion'];
    //timestampActualizado = documentSnapshot['timestamp_actualizado'];
  }
  Marca.fromMap(Map data) {
    id = data['id'] ?? '';
    titulo = data['titulo'] ?? '';
    descripcion = data['descripcion'] ?? '';
    urlImagen = data['url_imagen'] ?? 'default';
    verificado = data['verificado'] ?? false;
    idUsuarioCreador = data['id_usuario_creador'] ?? '';
    idUsuarioActualizado = data['id_usuario_actualizado'] ?? '';
    timestampCreacion = data['timestamp_creacion'];
    timestampActualizado = data['timestamp_actualizado'];
  }
  Map<String, dynamic> toJson() => {
        "id": id ,
        "titulo": titulo,
        "descripcion": descripcion,
        "urlImagen": urlImagen,
        "verificado": verificado,
        "idUsuarioActualizado": idUsuarioActualizado,
        "timestampCreacion": timestampCreacion,
        "timestampActualizado": timestampActualizado,
      };
}
