// To parse this JSON data, do
//
//     final usersModel = usersModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

UserAuthModel usersModelFromJson(String str) =>
    UserAuthModel.fromJson(json.decode(str));

String usersModelToJson(UserAuthModel data) => json.encode(data.toJson());

class UserAuthModel {
  UserAuthModel({
    required this.uid,
    required this.nombre,
    required this.keyName,
    required this.email,
    required this.creationTime,
    required this.lastSignInTime,
    required this.photoUrl,
    required this.status,
    required this.updatedTime,
  });

  String uid;
  String nombre;
  String keyName;
  String email;
  String creationTime;
  String lastSignInTime;
  String photoUrl;
  String status;
  String updatedTime;

  factory UserAuthModel.fromJson(Map<String, dynamic> json) => UserAuthModel(
        uid: json["uid"],
        nombre: json["nombre"],
        keyName: json["keyName"],
        email: json["email"],
        creationTime: json["creationTime"],
        lastSignInTime: json["lastSignInTime"],
        photoUrl: json["photoUrl"],
        status: json["status"],
        updatedTime: json["updatedTime"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": nombre,
        "keyName": keyName,
        "email": email,
        "creationTime": creationTime,
        "lastSignInTime": lastSignInTime,
        "photoUrl": photoUrl,
        "status": status,
        "updatedTime": updatedTime,
      };
}

class UsersModel {
  UsersModel({
    this.id = '',
    this.email = '',
    //required this.timestamCreation ,
    //required this.timestampSesion,
    this.idBusiness = '',
  });

  late String id;
  late String email;
  //late Timestamp timestamCreation;
  //late Timestamp timestampSesion;
  late String idBusiness;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        id: json["id"],
        email: json["email"],
        //timestamCreation: json["timestamCreation"] ?? json["timestamp_creation"],
        //timestampSesion: json["timestampSesion"] ?? json["timestamp_sesion"],
        idBusiness: json["idBusiness"] ?? json["id_cuenta_negocio"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        //"timestamCreation": timestamCreation,
        //"timestampSesion": timestampSesion,
        "idBusiness": idBusiness,
      };
  UsersModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    this.id = documentSnapshot.id;
    this.email = documentSnapshot["email"];
    //this.timestamCreation = documentSnapshot["timestamCreation"] ?? documentSnapshot["timestamp_creation"];
    //this.timestampSesion = documentSnapshot["timestampSesion"] ?? documentSnapshot["timestamp_sesion"];
    this.idBusiness = documentSnapshot["id_cuenta_negocio"];
  }
}

class ProfileBusinessModel {
  // Informacion del negocios
  String id = "";
  String username = "";
  String imagenPerfil = "";
  String nombreNegocio = "";
  String descripcion = "";
  //Timestamp timestamp_creation; // Fecha en la que se creo la cuenta
  //Timestamp timestamp_login; // Fecha de las ultima ves que inicio la app
  String signoMoneda = "\$";

  // informacion de cuenta
  bool bloqueo = false;
  String mensajeBloqueo = "";
  bool cuentaActiva =
      true; // Estado de el uso de la cuenta dependiendo el uso // Las cuentas desactivadas no aprecen en el mapa
  bool cuentaVerificada = false; // Cuenta verificada

  // Ubicacion
  String codigoPais = "";
  String pais = "";
  String provincia = "";
  String ciudad = "";
  String direccion = "";

  // data app
  String admin = '';

  ProfileBusinessModel({
    // Informacion del negocios
    this.id = "",
    this.username = "",
    this.imagenPerfil = "",
    this.nombreNegocio = "",
    this.descripcion = "",
    //this.timestamp_creation, // Fecha en la que se creo la cuenta
    //this.timestamp_login, // Fecha de las ultima ves que inicio la app
    this.signoMoneda = "\$",
    // informacion de cuenta
    this.bloqueo = false,
    this.mensajeBloqueo = "",
    this.cuentaActiva =
        true, // Estado de el uso de la cuenta dependiendo el uso // Las cuentas desactivadas no aprecen en el mapa
    this.cuentaVerificada = false, // Cuenta verificada

    // Ubicacion
    this.codigoPais = "",
    this.pais = "",
    this.provincia = "",
    this.ciudad = "",
    this.direccion = "",

    // data app
    this.admin = '',
  });
  ProfileBusinessModel.fromMap(Map data) {
    id = data['id'];
    username = data['username'];
    imagenPerfil = data['imagen_perfil'] ?? '';
    nombreNegocio = data['nombre_negocio'];
    descripcion = data['descripcion'];
    // timestamp_creation = data['timestamp_creation'];
    //timestamp_login = data['timestamp_login'];
    signoMoneda = data['signo_moneda'] ?? "\$";
    bloqueo = data['bloqueo'];
    mensajeBloqueo = data['mensaje_bloqueo'];
    cuentaActiva = data['cuenta_activa'];
    cuentaVerificada = data['cuenta_verificada'];
    codigoPais = data['codigo_pais'];
    direccion = data['direccion'];
    ciudad = data['ciudad'];
    provincia = data['provincia'];
    pais = data['pais'];
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "imagen_perfil": imagenPerfil,
        "nombre_negocio": nombreNegocio,
        "descripcion": descripcion,
        //"timestamp_creation": timestamp_creation,
        //"timestamp_login": timestamp_login,
        "signo_moneda": signoMoneda,
        "bloqueo": bloqueo,
        "mensaje_bloqueo": mensajeBloqueo,
        "cuenta_activa": cuentaActiva,
        "cuenta_verificada": cuentaVerificada,
        "codigo_pais": codigoPais,
        "pais": pais,
        "provincia": provincia,
        "ciudad": ciudad,
        "direccion": direccion,
      };

  ProfileBusinessModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    this.id = documentSnapshot.id;
    //this.username = documentSnapshot["username"]??'';
    this.imagenPerfil = documentSnapshot["imagen_perfil"] ?? '';
    this.nombreNegocio = documentSnapshot["nombre_negocio"] ?? 'null';
    this.descripcion = documentSnapshot["descripcion"] ?? '';
    //this.signoMoneda = documentSnapshot["signo_moneda"]??'';
    this.bloqueo = documentSnapshot["bloqueo"] ?? '';
    this.mensajeBloqueo = documentSnapshot["mensaje_bloqueo"] ?? '';
    this.cuentaActiva = documentSnapshot["cuenta_activa"] ?? false;
    this.cuentaVerificada = documentSnapshot["cuenta_verificada"] ?? false;
    this.codigoPais = documentSnapshot["codigo_pais"] ?? '';
    this.pais = documentSnapshot["pais"] ?? '';
    this.provincia = documentSnapshot["provincia"] ?? '';
    this.ciudad = documentSnapshot["ciudad"] ?? '';
    this.direccion = documentSnapshot["direccion"] ?? '';
  }
}

class AdminUsuarioCuenta {
  String idUser = "";
  String idAccount = "";
  bool estadoCuentaUsuario = true;
  int tipoUsuario = 0;
  int tipocuenta = 0; // 0 = null | 1 = administrador  | 2 = etandar
  bool propietarioCuenta =
      false; // True el usuario fue quien creo la cuenta del negocios

  AdminUsuarioCuenta({
    this.idUser = "",
    this.idAccount = "",
    this.estadoCuentaUsuario = false,
    this.tipoUsuario = 0,
    this.tipocuenta = 0,
  });

  AdminUsuarioCuenta.fromMap(Map data) {
    idUser = data['id_usuario'] ?? "";
    idAccount = data['idAccount'] ?? "";
    estadoCuentaUsuario = data['estado_cuenta_usuario'] ?? '';
    tipoUsuario = data['tipo_usuario'] ?? '';
    tipocuenta = data['tipocuenta'] ?? '';
    propietarioCuenta = data['propietario_cuenta'] ?? '';
  }

  AdminUsuarioCuenta.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    idUser = documentSnapshot['id_usuario'] ?? "";
    idAccount = documentSnapshot['idAccount'] ?? '';
    estadoCuentaUsuario = documentSnapshot['estado_cuenta_usuario'] ?? '';
    tipoUsuario = documentSnapshot['tipo_usuario'] ?? '';
    tipocuenta = documentSnapshot['tipocuenta'] ?? '';
    propietarioCuenta = documentSnapshot['propietario_cuenta'] ?? '';
  }
  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "idAccount": idAccount,
        "estadoCuentaUsuario": estadoCuentaUsuario,
        "tipocuenta": tipocuenta,
        "propietarioCuenta": propietarioCuenta,
    };
}
