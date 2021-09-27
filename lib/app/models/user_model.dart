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
