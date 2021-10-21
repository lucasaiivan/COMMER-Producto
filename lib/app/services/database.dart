import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:producto/app/models/user_model.dart';

// operations of CRUD Firestore

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('USUARIOS');
late final String userUid;

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Database({required String id}) {
    this.setUserUid = id;
  }

  set setUserUid(String ui) => userUid = ui;

  //  Escribir datos
  //  La operación de escritura se utilizará para agregar un nuevo elemento de nota a Firestore.
  static Future<void> addItem({
    required String name,
    required String username,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "username": username,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print( "#####################  firebase: Notes item added to the database"))
        .catchError((e) => print('#####################  firebase:' + e));
  }

  // read values 
  //  Podemos leer datos de Firestore de dos formas: como Futuro como Stream. Puede usar Future si desea leer los datos una sola vez.
  //  de lo contrario usaremos Stream, ya que sincronizará automáticamente los datos cada vez que se modifiquen en la base de datos.
  // future - QuerySnapshot
  static Future<QuerySnapshot<Map<String, dynamic>>> readProductsFuture( {int limit=0}) => limit!=0?FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').orderBy("favorite",descending: true).limit(limit).get():FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').orderBy("favorite",descending: true).get();
  static Future<QuerySnapshot<Map<String, dynamic>>> readProductsForMakFuture( {required String idMark,int limit=0}) => limit!=0?FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').where("id_marca",isEqualTo: idMark).limit(limit).get():FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').where("id_marca",isEqualTo: idMark).get();
  static Future<QuerySnapshot<Map<String, dynamic>>> readListPricesProductFuture( {required String id,String isoPAis = 'ARG'}) => FirebaseFirestore.instance.collection('APP/$isoPAis/PRODUCTOS/$id/REGISTRO_PRECIOS_$isoPAis').get();
  // future - DocumentSnapshot
  static Future<DocumentSnapshot<Map<String, dynamic>>> readUserModelFuture( String id) => FirebaseFirestore.instance.collection('USUARIOS').doc(id).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readProfileBusinessModelFuture( String id) => FirebaseFirestore.instance.collection('NEGOCIOS').doc(id).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readProductCatalogueFuture( { required String idBusiness,required String idProduct}) => FirebaseFirestore.instance.collection('NEGOCIOS/$idBusiness/EXTENSION_CATALOGO/').doc(idProduct).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readCategotyCatalogueFuture( { required String idBusiness,required String idCategory}) => FirebaseFirestore.instance.collection('/NEGOCIOS/$idBusiness/EXTENSION_CATALOGO_CATEGORIA/').doc(idCategory).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readSubcategotyCatalogueFuture( { required String idBusiness,required String idCategory,required String idSubcategory}) => FirebaseFirestore.instance.collection('NEGOCIOS/$idBusiness/EXTENSION_CATALOGO_CATEGORIA/$idCategory/SUBCATEGORIA/').doc(idSubcategory).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readMarkFuture( { required String id}) => FirebaseFirestore.instance.collection('/APP/ARG/MARCAS/').doc(id).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readManagedAccounts( { required String idAccountBussiness,required String idAccountUser}) => FirebaseFirestore.instance.collection('/NEGOCIOS/$idAccountBussiness/ADMINISTRADOR_NEGOCIOS/').doc(idAccountUser).get();
  // stream - DocumentSnapshot
  static Stream<DocumentSnapshot<Map<String, dynamic>>> readUserModelStream( String id) => FirebaseFirestore.instance.collection('USUARIOS').doc(id).snapshots();
  static Stream<DocumentSnapshot<Map<String, dynamic>>> readProfileBusinessModelStream( String id) => FirebaseFirestore.instance.collection('NEGOCIOS').doc(id).snapshots();
  // stream - QuerySnapshot
  static Stream<QuerySnapshot<Map<String, dynamic>>> readProductsCatalogueStream( { required String id}) => FirebaseFirestore.instance.collection('NEGOCIOS/$id/EXTENSION_CATALOGO').orderBy("timestamp_creation",descending: true).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> readManagedAccountsQueryStream( { required String id}) => FirebaseFirestore.instance.collection('/USUARIOS/$id/ADMINISTRADOR_NEGOCIOS').snapshots();
  

  //  update value
  //  Para actualizar los datos en la base de datos, puede usar el update()método en el documentReferencerobjeto pasando los nuevos datos como un mapa. Para actualizar un documento en particular de la base de datos, deberá usar su ID de documento único .
  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer = _mainCollection.doc(userUid).collection('USUARIOS').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  //  dalete value
  //  Para eliminar una nota de la base de datos, puede usar su ID de documento particular y eliminarlo usando el delete()método en el documentReferencerobjeto.
  static Future<void> deleteItem({ required String docId }) async {
    DocumentReference documentReferencer =_mainCollection.doc(userUid).collection('items').doc(docId);
    await documentReferencer.delete().whenComplete(() => print('Note item deleted from the database')).catchError((e) => print(e));
  }
}