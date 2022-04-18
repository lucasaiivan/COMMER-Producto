import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// operations of CRUD Firestore
class Database {

  //  Escribir datos
  //...
  //...
  //..

  // read values
  //  Podemos leer datos de Firestore de dos formas: como Futuro como Stream. Puede usar Future si desea leer los datos una sola vez.
  //  de lo contrario usaremos Stream, ya que sincronizará automáticamente los datos cada vez que se modifiquen en la base de datos.
  // future - QuerySnapshot
  static Future<QuerySnapshot<Map<String, dynamic>>> readProductsFavoritesFuture({int limit = 0}) =>limit != 0? FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').where('favorite',isEqualTo:true).limit(limit).get(): FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').where('favorite',isEqualTo:true).get();
  static Future<QuerySnapshot<Map<String, dynamic>>> readProductsFuture({int limit = 0}) =>limit != 0? FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').where("favorite", isEqualTo: true).limit(limit).get(): FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').orderBy("favorite", descending: true).get();
  static Future<QuerySnapshot<Map<String, dynamic>>> readProductsForMakFuture({required String idMark, int limit = 0}) =>limit != 0? FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').where("idMark", isEqualTo: idMark).limit(limit).get() : FirebaseFirestore.instance.collection('APP/ARG/PRODUCTOS').where("idMark", isEqualTo: idMark).get();
  static Future<QuerySnapshot<Map<String, dynamic>>>readListPricesProductFuture({required String id, String isoPAis = 'ARG', int limit = 50}) =>FirebaseFirestore.instance.collection('APP/$isoPAis/PRODUCTOS/$id/PRICES').limit(limit).orderBy("time", descending: true).get();
  static Future<QuerySnapshot<Map<String, dynamic>>> readCategoryListFuture({required String idAccount}) =>FirebaseFirestore.instance.collection('/ACCOUNTS/$idAccount/CATEGORY').get();
  static Future<QuerySnapshot<Map<String, dynamic>>> readListMarksFuture() =>FirebaseFirestore.instance.collection('/APP/ARG/MARCAS').get();
  // future - DocumentSnapshot
  static Future<DocumentSnapshot<Map<String, dynamic>>> readProductGlobalFuture({required String id}) =>FirebaseFirestore.instance.collection('/APP/ARG/PRODUCTOS/').doc(id).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>>readProfileAccountModelFuture(String id) =>FirebaseFirestore.instance.collection('ACCOUNTS').doc(id).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>>readProductCatalogueFuture({required String idAccount, required String idProduct}) =>FirebaseFirestore.instance.collection('ACCOUNTS/$idAccount/CATALOGUE/').doc(idProduct).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>>readCategotyCatalogueFuture({required String idAccount, required String idCategory}) =>FirebaseFirestore.instance.collection('/ACCOUNTS/$idAccount/CATEGORY/').doc(idCategory).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readMarkFuture({required String id}) =>FirebaseFirestore.instance.collection('/APP/ARG/MARCAS/').doc(id).get();
  static Future<DocumentSnapshot<Map<String, dynamic>>> readVersionApp() =>FirebaseFirestore.instance.collection('/APP/').doc('INFO').get();

  // stream - DocumentSnapshot
  static Stream<DocumentSnapshot<Map<String, dynamic>>> readAccountModelStream(String id) =>FirebaseFirestore.instance.collection('ACCOUNTS').doc(id).snapshots();
  // stream - QuerySnapshot
  static Stream<QuerySnapshot<Map<String, dynamic>>>readProductsCatalogueStream({required String id}) =>FirebaseFirestore.instance.collection('ACCOUNTS/$id/CATALOGUE').orderBy("upgrade", descending: true).snapshots();
  static Stream<QuerySnapshot<Map<String, dynamic>>> readCategoriesQueryStream({required String idAccount}) =>FirebaseFirestore.instance.collection('/ACCOUNTS/$idAccount/CATEGORY') .snapshots();
  // STORAGE reference
  static Reference referenceStorageAccountImageProfile({required String id}) => FirebaseStorage.instance.ref().child("ACCOUNTS").child(id).child("PROFILE").child("imageProfile");
  static Reference referenceStorageProductPublic({required String id}) => FirebaseStorage.instance.ref().child("APP").child("ARG").child("PRODUCTOS").child(id);
  
  // Firestore - CollectionReference
  static CollectionReference refFirestoreAccount() => FirebaseFirestore.instance.collection('/ACCOUNTS/');
  static CollectionReference refFirestoreCategory({required String idAccount}) =>FirebaseFirestore.instance.collection('/ACCOUNTS/$idAccount/CATEGORY/');
  static CollectionReference refFirestoreCatalogueProduct({required String idAccount}) =>FirebaseFirestore.instance.collection('/ACCOUNTS/$idAccount/CATALOGUE/');
  static CollectionReference refFirestoreProductPublic() =>FirebaseFirestore.instance.collection('/APP/ARG/PRODUCTOS/');
  static CollectionReference refFirestoreRegisterPrice({required String idProducto, String isoPAis = 'ARG'}) =>FirebaseFirestore.instance.collection('/APP/$isoPAis/PRODUCTOS/$idProducto/PRICES/');
  static CollectionReference refFirestoreMark() =>FirebaseFirestore.instance.collection('/APP/ARG/MARCAS/');
  static CollectionReference refFirestoreReportProduct({String iso='ARG'}) =>FirebaseFirestore.instance.collection('/APP/$iso/REPORTS/');

  //  update value
  //  Para actualizar los datos en la base de datos, puede usar el update()método en el documentReferencerobjeto pasando los nuevos datos como un mapa. Para actualizar un documento en particular de la base de datos, deberá usar su ID de documento único .
  //...
  //...
  //...

  //  dalete value
  //  Para eliminar una nota de la base de datos, puede usar su ID de documento particular y eliminarlo usando el delete()método en el documentReferencerobjeto.
  //...
  //...
  //...
}
