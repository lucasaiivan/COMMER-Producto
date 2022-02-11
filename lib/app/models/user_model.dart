import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  UsersModel({
    this.id = '',
    this.email = '',
  });

  late String id;
  late String email;

  factory UsersModel.fromDocument(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return UsersModel(
      id: data.containsKey("id") ? doc["id"] : '',
      email: data.containsKey("email") ? doc["email"] : '',
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
      };
}

class ProfileAccountModel {
  // Informacion del negocios
  String id = "";
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

  // data user creation
  Timestamp creation = Timestamp.now(); // Fecha en la que se creo la cuenta
  String idAuthUserCreation = ''; // id del usuario que creo la cuenta

  ProfileAccountModel({
    // account info
    // informacion de cuenta
    // location
    // data user creation
    this.id = "",
    this.username='',
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
    this.idAuthUserCreation = '',
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
    Map data = documentSnapshot.data() as Map;

    //  set
    this.id = data.containsKey('id') ? data['id'] : documentSnapshot.id;
    this.username = data["username"] ?? '';
    this.image =
        data.containsKey('image') ? data['image'] : data["imagen_perfil"] ?? '';
    this.name = data.containsKey('name')
        ? data['name']
        : data["nombre_negocio"] ?? 'null';
    this.description = data.containsKey('description')
        ? data['description']
        : data["descripcion"] ?? '';
    this.currencySign = data.containsKey('currencySign')
        ? data['currencySign']
        : data["signo_moneda"] ?? '';
    this.blockingAccount = data.containsKey('blockingAccount')
        ? data['blockingAccount']
        : data["bloqueo"] ?? '';
    this.blockingMessage = data.containsKey('blockingMessage')
        ? data['blockingMessage']
        : data["mensaje_bloqueo"] ?? '';
    this.verifiedAccount = data.containsKey('verifiedAccount')
        ? data['verifiedAccount']
        : data["cuenta_verificada"] ?? false;
    this.countrycode = data.containsKey('countrycode')
        ? data['countrycode']
        : data["codigo_pais"] ?? '';
    this.country =
        data.containsKey('country') ? data['country'] : data["pais"] ?? '';
    this.province = data.containsKey('province')
        ? data['province']
        : data["provincia"] ?? '';
    this.town = data.containsKey('town') ? data['town'] : data["ciudad"] ?? '';
    this.address =
        data.containsKey('address') ? data['address'] : data["direccion"] ?? '';
  }
}

class AdminUser {
  // usuario administador

  String idUser = "";
  String idAccount = "";
  bool activated = true;
  int permitType = 0; // tipo de permiso // 0 = administrador | 1 = etandar

  AdminUser({
    this.idUser = "",
    this.idAccount = "",
    this.activated = false,
    this.permitType = 0,
  });

  AdminUser.fromMap(Map data) {
    idUser =
        data.containsKey('idUser') ? data['idUser'] : data['id_usuario'] ?? "";
    idAccount = data['idAccount'] ?? "";
    activated = data.containsKey('activated')
        ? data['activated']
        : data['estadoCuentaUsuario'] ?? '';
    permitType = data.containsKey('permitType')
        ? data['permitType']
        : data['tipocuenta'] ?? '';
  }

  AdminUser.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    Map data = documentSnapshot.data() as Map;

    //  set
    idUser =data.containsKey("idUser")? data["idUser"]: '';
    idAccount =data.containsKey("idAccount")? data["idAccount"]: '';
    activated = data.containsKey("activated")? data["activated"]:data["estadoCuentaUsuario"]??false;
    permitType = data.containsKey("permitType")? data["permitType"]:data["tipocuenta"]?? 0;
  }
  Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "idAccount": idAccount,
        "activated": activated,
        "permitType": permitType,
      };
}
