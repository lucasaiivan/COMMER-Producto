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
    this.keyName = '',
    this.urlfotoPerfil = '',
    //required this.timestamCreation ,
    //required this.timestampSesion,
    this.idBusiness = '',
  });

  late String id;
  late String email;
  late String urlfotoPerfil;
  late String keyName;
  //late Timestamp timestamCreation;
  //late Timestamp timestampSesion;
  late String idBusiness;

  factory UsersModel.fromJson(Map<String, dynamic> json) => UsersModel(
        id: json["id"],
        email: json["email"],
        keyName: json["keyName"] ?? json["nombre"],
        urlfotoPerfil: json["urlfotoPerfil"],
        //timestamCreation: json["timestamCreation"] ?? json["timestamp_creation"],
        //timestampSesion: json["timestampSesion"] ?? json["timestamp_sesion"],
        idBusiness: json["idBusiness"] ?? json["id_cuenta_negocio"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "keyName": keyName,
        "urlfotoPerfil": urlfotoPerfil,
        //"timestamCreation": timestamCreation,
        //"timestampSesion": timestampSesion,
        "idBusiness": idBusiness,
      };
  UsersModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    this.id = documentSnapshot.id;
    this.email = documentSnapshot["email"];
    this.keyName = documentSnapshot["nombre"]  ;
    this.urlfotoPerfil = documentSnapshot["urlfotoPerfil"] ?? 'null';
    //this.timestamCreation = documentSnapshot["timestamCreation"] ?? documentSnapshot["timestamp_creation"];
    //this.timestampSesion = documentSnapshot["timestampSesion"] ?? documentSnapshot["timestamp_sesion"];
    this.idBusiness = documentSnapshot["id_cuenta_negocio"] ;
  }
}



class ProfileBusinessModel {
  
  // Informacion del negocios
    String id="";
    String username="";
    String imagen_perfil="";
    String nombre_negocio="";
    String descripcion="";
    //Timestamp timestamp_creation; // Fecha en la que se creo la cuenta
    //Timestamp timestamp_login; // Fecha de las ultima ves que inicio la app
    String signo_moneda ="\$" ;


    // informacion de cuenta
    bool bloqueo=false;
    String  mensaje_bloqueo="";
    bool cuenta_activa = true;  // Estado de el uso de la cuenta dependiendo el uso // Las cuentas desactivadas no aprecen en el mapa
    bool cuenta_verificada=false; // Cuenta verificada

    // Ubicacion
    String codigo_pais="";
    String pais="";
    String provincia="";
    String ciudad="";
    String direccion="";
   

  ProfileBusinessModel({
    // Informacion del negocios
    this.id="",
    this.username="",
    this.imagen_perfil="",
    this.nombre_negocio="",
    this.descripcion="",
    //this.timestamp_creation, // Fecha en la que se creo la cuenta
    //this.timestamp_login, // Fecha de las ultima ves que inicio la app
    this.signo_moneda ="\$" ,
    // informacion de cuenta
    this.bloqueo=false,
    this.mensaje_bloqueo="",
    this.cuenta_activa = true, // Estado de el uso de la cuenta dependiendo el uso // Las cuentas desactivadas no aprecen en el mapa
    this.cuenta_verificada=false, // Cuenta verificada

    // Ubicacion
    this.codigo_pais="",
    this.pais="",
    this.provincia="",
    this.ciudad="",
    this.direccion="",
    });
  ProfileBusinessModel.fromMap(Map data) {
    id = data['id'];
    username=data['username'];
    imagen_perfil = data['imagen_perfil'] ?? '';
    nombre_negocio = data['nombre_negocio'];
    descripcion = data['descripcion'];
   // timestamp_creation = data['timestamp_creation'];
    //timestamp_login = data['timestamp_login'];
    signo_moneda = data['signo_moneda']??"\$";
    bloqueo = data['bloqueo'];
    mensaje_bloqueo = data['mensaje_bloqueo'];
    cuenta_activa = data['cuenta_activa'];
    cuenta_verificada = data['cuenta_verificada'];
    codigo_pais = data['codigo_pais'];
    direccion = data['direccion'];
    ciudad = data['ciudad'];
    provincia = data['provincia'];
    pais = data['pais'];
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "username":username,
        "imagen_perfil": imagen_perfil,
        "nombre_negocio": nombre_negocio,
        "descripcion": descripcion,
        //"timestamp_creation": timestamp_creation,
        //"timestamp_login": timestamp_login,
        "signo_moneda": signo_moneda,
        "bloqueo": bloqueo,
        "mensaje_bloqueo": mensaje_bloqueo,
        "cuenta_activa": cuenta_activa,
        "cuenta_verificada": cuenta_verificada,
        "codigo_pais": codigo_pais,
        "pais": pais,
        "provincia": provincia,
        "ciudad": ciudad,
        "direccion": direccion,
        
    };

    ProfileBusinessModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    this.id = documentSnapshot.id;
    this.username = documentSnapshot["username"];
    this.imagen_perfil = documentSnapshot["imagen_perfil"]  ;
    this.nombre_negocio = documentSnapshot["nombre_negocio"] ?? 'null';
    this.descripcion = documentSnapshot["descripcion"];
    this.signo_moneda = documentSnapshot["signo_moneda"];
    this.bloqueo = documentSnapshot["bloqueo"];
    this.mensaje_bloqueo = documentSnapshot["mensaje_bloqueo"];
    this.cuenta_activa = documentSnapshot["cuenta_activa"];
    this.cuenta_verificada = documentSnapshot["cuenta_verificada"];
    this.codigo_pais = documentSnapshot["codigo_pais"];
    this.pais = documentSnapshot["pais"];
    this.provincia = documentSnapshot["provincia"];
    this.ciudad = documentSnapshot["ciudad"];
    this.direccion = documentSnapshot["direccion"];
  }

}