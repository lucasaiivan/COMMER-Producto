import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:producto/app/models/user_model.dart';

// operaciones CRUD Firestore

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
        .whenComplete(() => print(
            "#####################  firebase: Notes item added to the database"))
        .catchError((e) => print('#####################  firebase:' + e));
  }

  // Leer datos
  //  Podemos leer datos de Firestore de dos formas: como Futureo como Stream. Puede usar Futuresi desea leer los datos una sola vez.
  //  Pero en nuestro caso, necesitamos los últimos datos disponibles en la base de datos, por lo que los usaremos Stream, ya que sincronizará automáticamente los datos cada vez que se modifiquen en la base de datos.
  static Future<DocumentSnapshot<Map<String, dynamic>>> readUserModel( String id) => FirebaseFirestore.instance.collection('USUARIOS').doc(id).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readProfileBusinessModel( String id) => FirebaseFirestore.instance.collection('NEGOCIOS').doc(id).get();

  //  Actualizar datos
  //  Para actualizar los datos en la base de datos, puede usar el update()método en el documentReferencerobjeto pasando los nuevos datos como un mapa. Para actualizar un documento en particular de la base de datos, deberá usar su ID de documento único .
  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('USUARIOS').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  //  Borrar datos
  //  Para eliminar una nota de la base de datos, puede usar su ID de documento particular y eliminarlo usando el delete()método en el documentReferencerobjeto.
  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}
