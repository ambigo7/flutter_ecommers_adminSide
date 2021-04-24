import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class OrderService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'orders';

  // Get data Users
  Future<List<DocumentSnapshot>> getOrders() =>
      _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });
}