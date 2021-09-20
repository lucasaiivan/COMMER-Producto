
import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /* Future<void> addTodo(String todo) async {
    try{
      await _firestore
        .collection('todos')
        .add({
          'createdAt': Timestamp.now(),
          'finished': false,
          'todo': todo
        });
    } catch (err) {
      print(err);
      rethrow;
    }
  } */

  /* Future<void> deleteTodo(Todo todo) async {
    try {
      await _firestore
        .collection('todos')
        .doc(todo.todoId)
        .delete();
    } catch (err) {
      print(err);
      rethrow;
    }
  } */

 static void initUserModel(String id) async {

    FirebaseFirestore.instance
    .collection('USUARIOS')
    .doc(id)
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('####################### Document exists on the database');
      }
    });
  }
}
