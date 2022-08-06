import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.superAdmin = false,
    this.email = '',
  });

  bool superAdmin = false;
  String email = '';

  factory UserModel.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UserModel(
      superAdmin: doc["superAdmin"] ?? false,
      email: data.containsKey("email") ? doc["email"] : '',
    );
  }

  Map<String, dynamic> toJson() => {
        "superAdmin": superAdmin,
        "email": email,
      };

  factory UserModel.fromMap(Map data) {
    return UserModel(
      // Valores del producto
      superAdmin: data['isuperAdmind'] ?? false,
      email: data['email'] ?? '',
    );
  }

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    // get
    Map data = documentSnapshot.data() as Map;

    //  set
    superAdmin = data['superAdmin'] ?? false;
    email = data["email"] ?? '';
  }
}

class ProfileAccountModel {
  // Informacion de la cuenta
  Timestamp creation = Timestamp.now(); // Fecha en la que se creo la cuenta
  String id =
      ""; // el ID de la cuenta por defecto es el ID del usuario quien lo creo
  String username = "";
  String image = "";
  String name = "";
  String description = "";
  String currencySign = "\$";

  // account info
  bool blockingAccount = false;
  String blockingMessage = "";
  bool verifiedAccount = false; // Cuenta verificada

  // location
  String countrycode = "";
  String country = "";
  String province = ""; // provincia o estado
  String town = ""; // ciudad o pueblo
  String address = ""; // dirección

  ProfileAccountModel({
    // account info
    // informacion de cuenta
    // location
    // data user creation
    this.id = "",
    this.username = '',
    this.image = "",
    this.name = "",
    this.description = "",
    this.currencySign = "\$",
    this.blockingAccount = false,
    this.blockingMessage = "",
    this.verifiedAccount = false, // Cuenta verificada
    this.countrycode = "",
    this.country = "",
    this.province = "",
    this.town = "",
    this.address = "",
    required this.creation,
  });

  ProfileAccountModel.fromMap(Map data) {
    id = data['id'];
    username = data['username'];
    image =
        data.containsKey('image') ? data['image'] : data['imagen_perfil'] ?? '';
    name = data.containsKey('name') ? data['name'] : data['nombre_negocio'];
    description = data.containsKey('description')
        ? data['description']
        : data['descripcion'];
    creation = data.containsKey('creation')
        ? data['creation']
        : data['timestamp_creation'];
    currencySign = data.containsKey('currencySign')
        ? data['currencySign']
        : data['signo_moneda'] ?? "\$";
    blockingAccount = data.containsKey('blockingAccount')
        ? data['blockingAccount']
        : data['bloqueo'];
    blockingMessage = data.containsKey('blockingMessage')
        ? data['blockingMessage']
        : data['mensaje_bloqueo'];
    verifiedAccount = data.containsKey('verifiedAccount')
        ? data['verifiedAccount']
        : data['cuenta_verificada'];
    countrycode = data.containsKey('countrycode')
        ? data['countrycode']
        : data['codigo_pais'];
    address = data.containsKey('address') ? data['address'] : data['direccion'];
    town = data.containsKey('town') ? data['town'] : data['ciudad'];
    province =
        data.containsKey('province') ? data['province'] : data['provincia'];
    country = data.containsKey('country') ? data['country'] : data['pais'];
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "image": image,
        "name": name,
        "description": description,
        "creation": creation,
        "currencySign": currencySign,
        "blockingAccount": blockingAccount,
        "blockingMessage": blockingMessage,
        "verifiedAccount": verifiedAccount,
        "countrycode": countrycode,
        "country": country,
        "province": province,
        "town": town,
        "address": address,
      };

  ProfileAccountModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    // get
    Map data = documentSnapshot.data() as Map;

    //  set
    creation = data["creation"];
    id = data.containsKey('id') ? data['id'] : documentSnapshot.id;
    username = data["username"] ?? '';
    image =
        data.containsKey('image') ? data['image'] : data["imagen_perfil"] ?? '';
    name = data.containsKey('name')
        ? data['name']
        : data["nombre_negocio"] ?? 'null';
    description = data.containsKey('description')
        ? data['description']
        : data["descripcion"] ?? '';
    currencySign = data.containsKey('currencySign')
        ? data['currencySign']
        : data["signo_moneda"] ?? '';
    blockingAccount = data.containsKey('blockingAccount')
        ? data['blockingAccount']
        : data["bloqueo"] ?? '';
    blockingMessage = data.containsKey('blockingMessage')
        ? data['blockingMessage']
        : data["mensaje_bloqueo"] ?? '';
    verifiedAccount = data.containsKey('verifiedAccount')
        ? data['verifiedAccount']
        : data["cuenta_verificada"] ?? false;
    countrycode = data.containsKey('countrycode')
        ? data['countrycode']
        : data["codigo_pais"] ?? '';
    country =
        data.containsKey('country') ? data['country'] : data["pais"] ?? '';
    province = data.containsKey('province')
        ? data['province']
        : data["provincia"] ?? '';
    town = data.containsKey('town') ? data['town'] : data["ciudad"] ?? '';
    address =
        data.containsKey('address') ? data['address'] : data["direccion"] ?? '';
  }
}
