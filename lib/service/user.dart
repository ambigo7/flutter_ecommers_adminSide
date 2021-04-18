import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class UserService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'users';

  // Get data Users
  Future<List<DocumentSnapshot>> getUsers() =>
      _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });
}