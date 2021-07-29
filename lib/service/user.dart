import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_shop_admin/models/user.dart';
import 'package:uuid/uuid.dart';

class UserService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'users';


  Future<UserModel> getUserById(String id) =>
      _firestore
          .collection(ref)
          .doc(id)
          .get()
          .then((doc){
        return UserModel.fromSnapshot(doc);
      });
  // Get data Users
  Future<List<DocumentSnapshot>> getUsers() =>
      _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });
}