import 'package:cloud_firestore/cloud_firestore.dart';

class UserServices {
  String collection = 'users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    // String number = value['number'];

    await _firestore.collection(collection).doc(id).set(values);
  }

  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    // String number = value['number'];

    await _firestore.collection(collection).doc(id).update(values);
  }

  Future<DocumentSnapshot> getUserByID(String id) async {
    var result = await _firestore.collection(collection).doc(id).get();
    return result;
  }
}
