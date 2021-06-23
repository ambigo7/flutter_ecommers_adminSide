import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class OrderService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'orders';

  // Get data Orders
  Future<List<DocumentSnapshot>> getOrders() =>
      _firestore
          .collection(ref)
          .where('status', isEqualTo: "Incomplete")
          .get()
          .then((snaps) {
        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getSold() =>
      _firestore
          .collection(ref)
          .where('status', isEqualTo: "Completed")
          .get()
          .then((snaps) {
        return snaps.docs;
      });
}