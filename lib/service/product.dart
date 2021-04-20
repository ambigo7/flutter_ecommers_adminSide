import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'products';

  //create product data to cloud firestore
  void uploadProduct(Map<String, dynamic> data){
    //Generate Key for brandID
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).doc(productId).set(data);

  }
  // Get data PRoducts
  Future<List<DocumentSnapshot>> getProducts() =>
      _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });
}