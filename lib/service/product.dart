import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'products';

  //create product data to cloud firestore
  void uploadProduct({String productName, String brand, String category, int quantity,List sizes, List images, double price}){
    //Generate Key for brandID
    var id = Uuid();
    String productId = id.v1();

    _firestore.collection(ref).doc(productId).set({
      'name': productName,
      'id': productId,
      'price': price,
      'brand': brand,
      'category': category,
      'quantity': quantity,
      'sizes': sizes,
      'imageUrl': images

    });
  }
}